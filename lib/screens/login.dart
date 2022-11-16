import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helpayr/constants/Theme.dart';
import 'package:helpayr/firebase/auth_login.dart';
import 'package:helpayr/screens/sign_up.dart';
import 'package:provider/provider.dart';

import '../firebase/authenticate.dart';
import '../firebase/googleSignIn.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailcontroller = TextEditingController();
  final _passWordController = TextEditingController();
  bool loading = false;
  Future signIn() async {
    if (_emailcontroller.text == "" || _passWordController == "") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: HelpayrColors.info,
          content: Text(
            "All fields are required!",
            style: TextStyle(color: Colors.white),
          )));
    } else {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _emailcontroller.text.trim(),
              password: _passWordController.text.trim())
          .then((value) => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AuthPageSign(
                      isSignup: false,
                    ),
                  ),
                ),
              });
    }
    setState(() {
      loading = true;
    });
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passWordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 2.4,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/login/background.png"),
                        fit: BoxFit.fill),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        height: 200,
                        width: 80,
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/login/light-1.png"),
                                fit: BoxFit.fill),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 140,
                        height: 160,
                        width: 80,
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/login/light-2.png"),
                                fit: BoxFit.fill),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 330,
                        bottom: 190,
                        height: 50,
                        width: 50,
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("assets/login/clock.png"),
                                fit: BoxFit.fill),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 110,
                  width: 290,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/helpayrblue.png"),
                        fit: BoxFit.fill),
                  ),
                ),
                Text(
                  "Or",
                  style: TextStyle(
                    color: HelpayrColors.white,
                    fontSize: 15,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Column(
                        children: [
                          RawMaterialButton(
                            constraints: BoxConstraints.tight(Size(38, 38)),
                            onPressed: () {},
                            elevation: 4.0,
                            fillColor: HelpayrColors.black,
                            child: Icon(
                              Icons.phone_android_rounded,
                              size: 25.0,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.grey,
                                  offset: Offset(2, 2),
                                  blurRadius: 1,
                                )
                              ],
                            ),
                            padding: EdgeInsets.all(0.0),
                            shape: CircleBorder(),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: RawMaterialButton(
                        constraints: BoxConstraints.tight(Size(38, 38)),
                        onPressed: () {
                          final provider = Provider.of<GoogleSignUpProvider>(
                              context,
                              listen: false);
                          provider.googleLoginUser().then((value) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePageGoogle(),
                              ),
                            );
                          });
                        },
                        elevation: 4.0,
                        fillColor: HelpayrColors.black,
                        child: Icon(
                          FontAwesomeIcons.google,
                          size: 25.0,
                          color: Colors.red,
                          shadows: [
                            Shadow(
                              color: Colors.red.withOpacity(0.6),
                              offset: Offset(2, 2),
                              blurRadius: 1,
                            )
                          ],
                        ),
                        padding: EdgeInsets.all(0.0),
                        shape: CircleBorder(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: RawMaterialButton(
                        constraints: BoxConstraints.tight(Size(38, 38)),
                        onPressed: () {},
                        elevation: 4.0,
                        fillColor: HelpayrColors.black,
                        child: Icon(
                          FontAwesomeIcons.facebook,
                          size: 25.0,
                          color: Colors.blue,
                          shadows: [
                            Shadow(
                              color: Colors.lightBlue.withOpacity(0.5),
                              offset: Offset(2, 2),
                              blurRadius: 2,
                            )
                          ],
                        ),
                        padding: EdgeInsets.all(0.0),
                        shape: CircleBorder(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: RawMaterialButton(
                        constraints: BoxConstraints.tight(Size(38, 38)),
                        onPressed: () {},
                        elevation: 4.0,
                        fillColor: HelpayrColors.black,
                        child: Icon(
                          FontAwesomeIcons.tiktok,
                          size: 25.0,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.grey,
                              offset: Offset(2, 2),
                              blurRadius: 1,
                            )
                          ],
                        ),
                        padding: EdgeInsets.all(0.0),
                        shape: CircleBorder(),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 40.0, left: 40.0, bottom: 20, top: 10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(143, 148, 251, .2),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            )
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey, width: 2),
                                ),
                              ),
                              child: TextField(
                                controller: _emailcontroller,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: const Icon(Icons.person),
                                  hintText: "Email Address",
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: TextField(
                                controller: _passWordController,
                                textInputAction: TextInputAction.done,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: const Icon(Icons.key),
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                loading
                    ? CircularProgressIndicator()
                    : Padding(
                        padding: const EdgeInsets.only(
                            left: 40, right: 40, bottom: 10, top: 0),
                        child: GestureDetector(
                          onTap: signIn,
                          child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: const LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 125, 199, 233),
                                      Color.fromARGB(255, 28, 108, 173),
                                      Color.fromARGB(255, 13, 110, 189),
                                    ],
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight),
                              ),
                              child: const Center(
                                child: Text(
                                  "Let's Go!",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              )),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => DraggableScrollableSheet(
                              initialChildSize: .50,
                              minChildSize: .2,
                              maxChildSize: 1,
                              builder: (context, myScroll) {
                                return signUpContext(
                                  controller: myScroll,
                                );
                              }));
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account?",
                        children: [
                          TextSpan(
                              text: " Sign Up Here!",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: HelpayrColors.info,
                                fontStyle: FontStyle.italic,
                              ))
                        ],
                        style: TextStyle(
                          color: HelpayrColors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> bottomSheetModal(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => DraggableScrollableSheet(
            initialChildSize: .50,
            minChildSize: .2,
            maxChildSize: 1,
            builder: (context, myScroll) {
              return signUpContext(
                controller: myScroll,
              );
            }));
  }
}
