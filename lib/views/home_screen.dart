import 'dart:ui';
import '../responsive_layout.dart';
import '../views/user/mobile_request_dialog.dart';
import '../views/user/request_screen.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../components/animated_btn.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSignInDialogShown = false;
  late RiveAnimationController _btnAnimationController;
  late RiveAnimationController _websiteAnimationController;

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation("active", autoplay: false);
    _websiteAnimationController = OneShotAnimation("active", autoplay: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/Backgrounds/background.jpg"),
                repeat: ImageRepeat.repeat
            ),
          ),
          child: AnimatedPositioned(
            duration: const Duration(milliseconds: 240),
            top: isSignInDialogShown ? -50 : 0,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: ResponsiveLayout(
                  tiny: Column(
                    children: [
                      SizedBox(
                        child: Column(children: [
                          Image.asset('assets/Backgrounds/logo.png',
                              width: 500, height: 250),
                          const Text(
                            "An online learning platform with a digital twin, designed for young people combining education and play.",
                            style: TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                          Image.asset(
                              'assets/Backgrounds/kids-image.jpg'),
                        ]),
                      ),
                      const Spacer(
                        flex: 2,
                      ),
                      AnimatedBtn(
                        btnAnimationController: _btnAnimationController,
                        press: () {
                          _btnAnimationController.isActive = true;
                          Future.delayed(const Duration(milliseconds: 800), () {
                            setState(() {
                              isSignInDialogShown = true;
                            });
                            RequestDialog(context, onClosed: (_) {
                              setState(() {
                                isSignInDialogShown = false;
                              });
                            });
                          });
                        },
                        label: 'Request Access',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AnimatedBtn(
                        btnAnimationController: _websiteAnimationController,
                        press: () async {
                          _websiteAnimationController.isActive = true;
                          await Future.delayed(
                              const Duration(milliseconds: 800));

                          const url = 'https://africxrjob.org/';

                          if (await canLaunchUrlString(url)) {
                            await launchUrlString(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        label: 'More infos',
                      ),
                      const Spacer(
                        flex: 2,
                      ),
                    ],
                  ),
                  phone: Column(
                    children: [
                      SizedBox(
                        child: Column(
                                children: [
                                  Image.asset('assets/Backgrounds/logo.png', width: 500, height: 250),
                                  const Text(
                                    "An online learning platform with a digital twin, designed for young people combining education and play.",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white
                                    ),
                                  ),
                                  Image.asset('assets/Backgrounds/kids-image.jpg'),
                                ]
                        ),
                      ),
                      const Spacer(),
                      AnimatedBtn(
                        btnAnimationController: _btnAnimationController,
                        press: () {
                          _btnAnimationController.isActive = true;
                          Future.delayed(const Duration(milliseconds: 800), () {
                            setState(() {
                              isSignInDialogShown = true;
                            });
                            RequestDialog(context, onClosed: (_) {
                              setState(() {
                                isSignInDialogShown = false;
                              });
                            });
                          });
                        },
                        label: 'Request Access',
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                    ],
                  ),
                  tablet: Column(
                    children: [
                      const Spacer(),
                      SizedBox(
                        child: Column(children: [
                          Image.asset('assets/Backgrounds/logo.png',
                              width: 400, height: 200),
                          const Text(
                            "An online learning platform with a digital twin, designed for young people combining education and play.",
                            style: TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                          Image.asset(
                              'assets/Backgrounds/kids-image.jpg'),
                        ]),
                      ),
                      const Spacer(
                      ),
                      AnimatedBtn(
                        btnAnimationController: _btnAnimationController,
                        press: () {
                          _btnAnimationController.isActive = true;
                          Future.delayed(const Duration(milliseconds: 800), () {
                            setState(() {
                              isSignInDialogShown = true;
                            });
                            RequestDialog(context, onClosed: (_) {
                              setState(() {
                                isSignInDialogShown = false;
                              });
                            });
                          });
                        },
                        label: 'Request Access',
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                    ],
                  ),
                  largeTablet: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Image.asset('assets/Backgrounds/logo.png',
                                    width: 500, height: 250),
                                const Text(
                                  "An online learning platform with a digital twin, designed for young people combining education and play.",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                                Image.asset(
                                    'assets/Backgrounds/kids-image.jpg'),
                              ],
                            ),
                          ),
                          const Expanded(flex: 1, child: RequestPage())
                        ],
                      ),
                    ),
                  ),
                  computer: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(100),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Image.asset('assets/Backgrounds/logo.png',
                                    width: 500, height: 250),
                                const Text(
                                  "An online learning platform with a digital twin, designed for young people combining education and play.",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                                Image.asset(
                                    'assets/Backgrounds/kids-image.jpg'),
                              ],
                            ),
                          ),
                          const Expanded(flex: 1, child: RequestPage())
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
