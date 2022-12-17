import 'package:flutter/material.dart';

import 'package:helpayr/constants/Theme.dart';
import 'package:helpayr/screens/googleLogin.dart';
import 'package:helpayr/screens/terms_and_conditions.dart';
import 'package:page_transition/page_transition.dart';

class Onboarding extends StatefulWidget {
  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  bool isClicked = false;
  @override
  Widget build(BuildContext context) {
    final ButtonStyle button = TextButton.styleFrom(
      backgroundColor: HelpayrColors.info,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
    return Scaffold(
        body: Stack(
      children: [
        Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/imgs/onboarding-free.png"),
                    fit: BoxFit.cover))),
        SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 70.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/helpayrblue.png",
                        scale: 4,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 1.0),
                        child: Text(
                          "Lending Hands In A Few Taps",
                          style: TextStyle(
                            shadows: [
                              Shadow(
                                  color: Colors.blue,
                                  blurRadius: 1,
                                  offset: Offset(2, 2))
                            ],
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SafeArea(
            child: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: isClicked
                      ? () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              duration: Duration(milliseconds: 200),
                              child: ChooseLogin(),
                              childCurrent: Onboarding(),
                            ),
                          );
                        }
                      : null,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 50,
                    child: Center(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: HelpayrColors.info,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue,
                          blurRadius: 15,
                          offset: Offset(4, 4),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: isClicked
                      ? () {
                          Navigator.pushNamed(context, '/login');
                        }
                      : null,
                  child: Container(
                    child: Center(
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width / 2,
                    height: 50,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue,
                          blurRadius: 15,
                          offset: Offset(4, 4),
                        )
                      ],
                      color: HelpayrColors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                        activeColor: Colors.blue,
                        fillColor: MaterialStateProperty.all(Colors.white),
                        value: isClicked,
                        onChanged: (newbool) {
                          setState(() {
                            isClicked = newbool;
                          });
                          print(isClicked);
                        }),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Terms(),
                          ),
                        );
                      },
                      child: Text(
                        "Terms and Conditions ",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )),
      ],
    ));
  }
}
