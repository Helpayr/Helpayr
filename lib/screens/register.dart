import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:helpayr/constants/Theme.dart';

//widgets
import 'package:helpayr/widgets/navbar.dart';

import '../widgets/drawer.dart';
import '../widgets/input.dart';

class Register extends StatefulWidget {
  @override
  Register({key, this.isSignUp = false});
  final bool isSignUp;
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _checkboxValue = false;

  final double height = window.physicalSize.height;

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _pass = TextEditingController();
    final ButtonStyle regbt = TextButton.styleFrom(
      backgroundColor: HelpayrColors.info,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32.0),
      ),
    );
    return Scaffold(
        appBar: widget.isSignUp
            ? AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
              )
            : Navbar(
                transparent: true,
                title: "",
                reverseTextcolor: false,
              ),
        extendBodyBehindAppBar: true,
        extendBody: true,
        drawer: widget.isSignUp ? null : NowDrawer(currentPage: "Account"),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/imgs/onboarding-free.png"),
                      fit: BoxFit.cover)),
            ),
            SafeArea(
              child: ListView(children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 16, left: 16.0, right: 16.0, bottom: 16),
                  child: Card(
                      elevation: 5,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: SingleChildScrollView(
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.90,
                            color: HelpayrColors.bgColorScreen,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 24.0, bottom: 8),
                                      child: Center(
                                          child: Text("Register",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 30,
                                                  fontWeight:
                                                      FontWeight.w600))),
                                    ),
                                    FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              RawMaterialButton(
                                                onPressed: () {},
                                                elevation: 4.0,
                                                fillColor: HelpayrColors
                                                    .socialFacebook,
                                                child: Icon(
                                                    FontAwesomeIcons.facebook,
                                                    size: 16.0,
                                                    color: Colors.white),
                                                padding: EdgeInsets.all(15.0),
                                                shape: CircleBorder(),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: Text(
                                                  "Facebook",
                                                  style: TextStyle(
                                                      color: HelpayrColors
                                                          .socialFacebook,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              RawMaterialButton(
                                                onPressed: () {},
                                                elevation: 4.0,
                                                fillColor:
                                                    HelpayrColors.socialTwitter,
                                                child: Icon(
                                                    FontAwesomeIcons.twitter,
                                                    size: 16.0,
                                                    color: Colors.white),
                                                padding: EdgeInsets.all(15.0),
                                                shape: CircleBorder(),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: Text(
                                                  "Twitter",
                                                  style: TextStyle(
                                                      color: HelpayrColors
                                                          .socialTwitter,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              RawMaterialButton(
                                                onPressed: () {},
                                                elevation: 4.0,
                                                fillColor: HelpayrColors.black,
                                                child: Icon(
                                                    FontAwesomeIcons.tiktok,
                                                    size: 16.0,
                                                    color: Colors.white),
                                                padding: EdgeInsets.all(15.0),
                                                shape: CircleBorder(),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: Text(
                                                  "Tiktok",
                                                  style: TextStyle(
                                                      color:
                                                          HelpayrColors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              RawMaterialButton(
                                                onPressed: () {},
                                                elevation: 4.0,
                                                fillColor: Colors.orange,
                                                child: Icon(
                                                    FontAwesomeIcons.reddit,
                                                    size: 16.0,
                                                    color: Colors.white),
                                                padding: EdgeInsets.all(15.0),
                                                shape: CircleBorder(),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: Text(
                                                  "Reddit",
                                                  style: TextStyle(
                                                      color: Colors.orange,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 24.0, bottom: 24.0),
                                      child: Center(
                                        child: Text("or be classical",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                                fontSize: 16)),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Input(
                                            textInputaction:
                                                TextInputAction.next,
                                            placeholder: "First Name...",
                                            prefixIcon: Icon(Icons.person,
                                                size: 20, color: Colors.blue),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Input(
                                              textInputaction:
                                                  TextInputAction.next,
                                              placeholder: "Last Name...",
                                              prefixIcon: Icon(Icons.person,
                                                  size: 20,
                                                  color: Colors.blue)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0,
                                              left: 8.0,
                                              right: 8.0,
                                              bottom: 0),
                                          child: Input(
                                              textInputaction:
                                                  TextInputAction.next,
                                              obscureText: false,
                                              controller: _emailController,
                                              placeholder: "Your Email...",
                                              prefixIcon: Icon(
                                                Icons.email,
                                                size: 20,
                                                color: Colors.blue,
                                              )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0,
                                              left: 8.0,
                                              right: 8.0,
                                              bottom: 0),
                                          child: Input(
                                              textInputaction:
                                                  TextInputAction.next,
                                              obscureText: true,
                                              controller: _pass,
                                              placeholder: "Password...",
                                              prefixIcon: Icon(
                                                Icons.lock,
                                                size: 20,
                                                color: Colors.blue,
                                              )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0,
                                              left: 8.0,
                                              right: 8.0,
                                              bottom: 0),
                                          child: Input(
                                              textInputaction:
                                                  TextInputAction.done,
                                              obscureText: true,
                                              controller: _pass,
                                              placeholder:
                                                  "Confirm Password...",
                                              prefixIcon: Icon(
                                                Icons.lock,
                                                size: 20,
                                                color: Colors.blue,
                                              )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, top: 15, bottom: 16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Checkbox(
                                                  activeColor:
                                                      HelpayrColors.info,
                                                  onChanged: (bool newValue) =>
                                                      setState(() =>
                                                          _checkboxValue =
                                                              newValue),
                                                  value: _checkboxValue),
                                              Text(
                                                  "I agree with the terms and conditions",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w200)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Center(
                                        child: InkWell(
                                      onTap: () {
                                        FirebaseAuth.instance
                                            .createUserWithEmailAndPassword(
                                                email: _emailController.text,
                                                password: _pass.text);
                                      },
                                      splashColor: Colors.blueAccent,
                                      child: Container(
                                        child: Center(
                                            child: Text(
                                          "Get Started",
                                          style: TextStyle(
                                            color: HelpayrColors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                                        height: 40,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                            )),
                      )),
                ),
              ]),
            )
          ],
        ));
  }
}
