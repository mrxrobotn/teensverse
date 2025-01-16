import '../../../constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import '../../../controllers/session_controller.dart';

class CreateSession extends StatefulWidget {
  CreateSession({super.key, required this.sessionsNumber});
  final int sessionsNumber; // Use 'final' since this field is immutable.

  @override
  State<CreateSession> createState() => _CreateSessionState();
}

class _CreateSessionState extends State<CreateSession> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isShowLoading = false;
  bool isShowConfetti = false;

  late SMITrigger check;
  late SMITrigger error;
  late SMITrigger reset;
  late SMITrigger confetti;

  // Access the sessionsNumber from the widget
  late int sessionsNumber = widget.sessionsNumber + 1;

  TextEditingController name = TextEditingController();
  bool isActive = false;
  List<String> users = [];

  StateMachineController getRiveController(Artboard artboard) {
    StateMachineController? controller =
    StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);
    return controller;
  }

  void checkLoginStatus(BuildContext context) async {
    setState(() {
      isShowLoading = true;
      isShowConfetti = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (_formKey.currentState!.validate()) {
        // Show success
        check.fire();
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            isShowLoading = false;
          });
          createSession("${name.text}_$sessionsNumber", isActive, users);
          name.text = "";
          isActive = true;
          Navigator.of(context).pop();
          const snackBar = SnackBar(
            content: Text('Session created'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      } else {
        error.fire();
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            isShowLoading = false;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: 520,
        height: 520,
        child: Column(
          children: [
            const Text(
              "New Session",
              style: TextStyle(fontSize: 34, fontFamily: "Poppins"),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                "Please fill this form with the right informations.",
                textAlign: TextAlign.center,
              ),
            ),
            Stack(
              children: [
                Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "TYPE A DATE",
                          style: TextStyle(color: Colors.black54),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 16),
                          child: TextFormField(
                            controller: name,
                            validator: (value) {
                              // Regular expression for DD-MM-YYYY_sessionNumber
                              final regex = RegExp(r'^\d{2}-\d{2}-\d{4}$');
                              if (value == null || value.isEmpty) {
                                return "Required Field";
                              } else if (!regex.hasMatch(value)) {
                                return "Invalid format. Use DD-MM-YYYY";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Icon(Icons.event),
                              ),
                              hintText: "DD-MM-YYYY",
                              errorStyle: TextStyle(
                                color: chartColor2,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 24),
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              checkLoginStatus(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: chartColor1,
                              minimumSize: const Size(double.infinity, 56),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            icon: const Icon(
                              CupertinoIcons.add,
                              color: textField,
                            ),
                            label: const Text("ADD", style: TextStyle(color: textField)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                isShowLoading
                    ? CustomPositioned(
                  child: RiveAnimation.asset(
                    "assets/RiveAssets/check.riv",
                    onInit: (artboard) {
                      StateMachineController controller =
                      getRiveController(artboard);
                      check = controller.findSMI("Check") as SMITrigger;
                      error = controller.findSMI("Error") as SMITrigger;
                      reset = controller.findSMI("Reset") as SMITrigger;
                    },
                  ),
                )
                    : const SizedBox(),
                isShowConfetti
                    ? CustomPositioned(
                  child: Transform.scale(
                    scale: 6,
                    child: RiveAnimation.asset(
                      "assets/RiveAssets/confetti.riv",
                      onInit: (artboard) {
                        StateMachineController controller =
                        getRiveController(artboard);
                        confetti = controller.findSMI("Trigger explosion") as SMITrigger;
                      },
                    ),
                  ),
                )
                    : const SizedBox()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
