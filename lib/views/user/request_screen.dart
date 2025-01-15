import 'package:flutter/material.dart';
import 'components/user_request_form.dart';

class RequestPage extends StatelessWidget {
  const RequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 100, right: 100),
        child: Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            borderRadius:  BorderRadius.circular(10.0),
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                          image: AssetImage("assets/Backgrounds/button-bg.png"),
                          repeat: ImageRepeat.repeat
                        ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 10),
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
                  const RequestForm()
                ]
            ),
          ),
        ),
      ),
    );
  }
}
