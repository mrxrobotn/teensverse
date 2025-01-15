import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rive/rive.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../constants.dart';
import '../../../controllers/user_controller.dart';

class RequestForm extends StatefulWidget {
  const RequestForm({
    super.key,
  });

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isShowLoading = false;
  bool isShowConfetti = false;

  late SMITrigger check;
  late SMITrigger error;
  late SMITrigger reset;
  late SMITrigger confetti;

  TextEditingController epicGamesId = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  List<String> events = [];
  List<String> sessions = [];
  String room = "0";
  bool canAccess = false;
  bool isAuthorized = false;
  String role = 'Student';
  bool _isButtonDisabled = false;

  StateMachineController getRiveController(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);
    return controller;
  }

  Future<void> checkUserAndSendRequest(String epicGamesId) async {
    try {
      final userExists = await checkUser(epicGamesId);
      if (_formKey.currentState!.validate()) {
        Future.delayed(const Duration(seconds: 2), () async {
          if (userExists) {
            print('User exists.');
            showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Alert!'),
                  content: const SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Text(
                            'You already have a request sent with this EpicGames ID. Please check your email.'),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            SendResquestData(context);
            print('User does not exist.');
          }
        });
        setState(() {
          _isButtonDisabled = true;
        });
      }
    } catch (e) {
      print('Failed to check user existence: $e');
    }
  }

  void SendResquestData(BuildContext context) {
    setState(() {
      isShowLoading = true;
      isShowConfetti = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      if (_formKey.currentState!.validate()) {
        // show success
        check.fire();
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            isShowLoading = false;
          });
          createUser(epicGamesId.text, name.text, email.text, sessions, canAccess, isAuthorized, role);
          epicGamesId.text = "";
          name.text = "";
          email.text = "";
          role = "Student";
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Thank You'),
                content: const SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(
                          'Your request has been successfully registered. Please wait for admin approval and monitor your email inbox for additional informations.'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      confetti.fire();
                    },
                  ),
                ],
              );
            },
          );
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
    return Stack(
      children: [
        Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  const Text("NAME"),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: textField, // Container background color
                    ),
                    child: TextFormField(
                      controller: name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter a name";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Username',
                        filled: true,
                        fillColor: Colors.transparent,
                        errorStyle: TextStyle(color: chartColor2),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text("EMAIL"),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: textField, // Container background color
                    ),
                    child: TextFormField(
                      controller: email,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter an email address";
                        } else if (!RegExp(
                                r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                            .hasMatch(value)) {
                          return "Please enter a valid email address";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        filled: true,
                        fillColor: Colors.transparent,
                        errorStyle: TextStyle(color: chartColor2),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text("EPIC GAMES ID"),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: textField, // Container background color
                    ),
                    child: TextFormField(
                      controller: epicGamesId,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter an ID";
                        } else if (!RegExp(r'^[a-z0-9]{32}$').hasMatch(value)) {
                          return "Please enter a valid Epic Games ID (32 characters)";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Epic Games ID',
                        filled: true,
                        fillColor: Colors.transparent,
                        errorStyle: TextStyle(color: chartColor2),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    children: [
                      const Text(
                          "If you don't have an Epic Games account, please follow "),
                      InkWell(
                          child: const Text(
                            'this link.',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: chartColor1),
                          ),
                          onTap: () => launchUrl(Uri.parse(
                              'https://www.epicgames.com/id/register/date-of-birth?redirect_uri=https%3A%2F%2Fwww.epicgames.com%2Faccount'))),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text("ROLE"),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: role,
                    onChanged: (String? newValue) {
                      setState(() {
                        role = newValue!;
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(27),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 3, color: textField),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Select an option',
                    ),
                    items: <String>['Student', 'Parent', 'Educator']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 6),
                  ElevatedButton.icon(
                      onPressed: _isButtonDisabled
                          ? null
                          : () {
                              checkUserAndSendRequest(epicGamesId.text);
                            },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: chartColor1,
                          minimumSize: const Size(double.infinity, 56),
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      icon: const Icon(
                        CupertinoIcons.arrow_right,
                        color: backgroundColorLight,
                      ),
                      label: const Text("Request",
                          style: TextStyle(color: backgroundColorLight))),
                ],
              ),
            )),
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
              ))
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
                    confetti =
                        controller.findSMI("Trigger explosion") as SMITrigger;
                  },
                ),
              ))
            : const SizedBox()
      ],
    );
  }
}
