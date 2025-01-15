import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants.dart';
import '../../controllers/user_controller.dart';
import 'components/sessions_list.dart';

Future<Object?> RequestDialog(BuildContext context,
    {required ValueChanged onClosed}) {
  return showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: "Request",
      context: context,
      transitionDuration: const Duration(milliseconds: 400),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        Tween<Offset> tween =
            Tween(begin: const Offset(0, -1), end: Offset.zero);
        return SlideTransition(
            position: tween.animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
            child: child);
      },
      pageBuilder: (context, _, __) => Center(
            child: Container(
              height: 700,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                borderRadius:  BorderRadius.circular(10.0),
                color: Colors.white,
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                resizeToAvoidBottomInset:
                    false, // avoid overflow error when keyboard shows up
                body: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SingleChildScrollView(
                      child: Column(children: [
                        Container(
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                                image: AssetImage("assets/Backgrounds/button-bg.png"),
                                repeat: ImageRepeat.repeat
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text(
                                  "Request Access",
                                  style: TextStyle(fontSize: 34, color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Request access to enter and join the experience in the TeensVerse.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const MobileRequestForm()
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          )).then(onClosed);
}

class MobileRequestForm extends StatefulWidget {
  const MobileRequestForm({
    super.key,
  });

  @override
  State<MobileRequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<MobileRequestForm> {
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
            final userData = await getUserData(epicGamesId);
            if (userData != null && userData['canAccess'] == true && userData['isAuthorized'] == true) {
              print('You are authorized and have access');
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Welcome back!'),
                    content: const SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text(
                              'Your request to join a session has been accepted. Enjoy the experience'),
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
            }
            else if (userData != null && userData['isAuthorized'] == true) {

              // User is authorized
              print('You are authorized.');
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return SessionsList(role: userData['role'], userId: userData['_id'], name: userData['name']);
                },
              );
            }
            else {
              // User is not authorized
              print('User is not authorized.');
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('you are not authorized.'),
                    content: const SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text(
                              'You already have a request sent with this EpicGames ID. Please wait for the admin approval.'),
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
            }
          }
          else {
            RequestAceess(context);
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

  void RequestAceess(BuildContext context) {
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
                          'Your request has been succesfully registered. Please monitor your email inbox for additional information.'),
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
                crossAxisAlignment: CrossAxisAlignment.center,
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
