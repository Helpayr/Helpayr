import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpayr/screens/login.dart';
import 'package:helpayr/screens/profile_maker.dart';
import 'package:helpayr/screens/sign_up.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import '../constants/Theme.dart';
import '../firebase/authenticate.dart';
import '../firebase/googleSignIn.dart';
import 'package:provider/provider.dart';

class ChooseLogin extends StatefulWidget {
  const ChooseLogin({Key key});

  @override
  State<ChooseLogin> createState() => _ChooseLoginState();
}

class _ChooseLoginState extends State<ChooseLogin> {
  bool isElevated = false;
  bool isElevatedgoogle = false;
  bool isUserSelected = false;
  bool isHelperSelected = false;
  bool isFirst = false;
  PageController _pagectrl = PageController(initialPage: 0);

  var Lottie;

  Future<dynamic> bottomSheetModal(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => DraggableScrollableSheet(
            initialChildSize: .30,
            minChildSize: .2,
            maxChildSize: 1,
            builder: (context, myScroll) {
              return signUpContext(
                controller: myScroll,
              );
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Stack(alignment: Alignment.topCenter, children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/imgs/bluescreen.png"),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black.withOpacity(.8),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 140),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/helpayrblue.png",
                  width: MediaQuery.of(context).size.width / 1.3,
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 1.0),
                    child: DefaultTextStyle(
                      child: AnimatedTextKit(
                        repeatForever: true,
                        animatedTexts: [
                          TypewriterAnimatedText(
                              ' "Lending Hands In A Few Taps"',
                              speed: Duration(milliseconds: 100))
                        ],
                      ),
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
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width / 2,
                  child: LottieBuilder.network(
                    "https://assets6.lottiefiles.com/packages/lf20_3vbOcw.json",
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isUserSelected = true;
                            isHelperSelected = false;
                          });
                          return _pagectrl.animateToPage(1,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          width: 90,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isUserSelected
                                ? Colors.blueAccent
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 2,
                                color: isUserSelected
                                    ? Colors.transparent
                                    : Colors.white),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedContainer(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                                width: isUserSelected ? 10 : 5,
                                height: isUserSelected ? 10 : 5,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: .1, color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "User",
                                style: GoogleFonts.raleway(
                                    color: Colors.white,
                                    fontWeight: isUserSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isHelperSelected = true;
                            isUserSelected = false;
                          });
                          return _pagectrl.animateToPage(2,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          width: 90,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isHelperSelected
                                ? Colors.blue
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 2,
                                color: isHelperSelected
                                    ? Colors.transparent
                                    : Colors.white),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedContainer(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                                width: isHelperSelected ? 10 : 5,
                                height: isHelperSelected ? 10 : 5,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: .1, color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Helper",
                                style: GoogleFonts.raleway(
                                    color: Colors.white,
                                    fontWeight: isHelperSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  height: MediaQuery.of(context).size.height / 3,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: PageView(
                        onPageChanged: ((value) {
                          setState(() {
                            isFirst = value == 0;
                          });
                        }),
                        physics: NeverScrollableScrollPhysics(),
                        controller: _pagectrl,
                        children: [
                          Container(
                            child: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    "Welcome! ",
                                    style: GoogleFonts.robotoCondensed(
                                      shadows: [
                                        Shadow(
                                          color: Colors.grey.withOpacity(.5),
                                          offset: Offset(2, 2),
                                        )
                                      ],
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                      fontSize: 45,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Please choose your Role!",
                                  style:
                                      GoogleFonts.raleway(color: Colors.white),
                                ),
                              ],
                            )),
                          ),
                          Container(
                            child: Column(children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: welcome(
                                  isUserWelcome: true,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isElevated = !isElevated;
                                    bottomSheetModal(context);
                                  });
                                },
                                splashColor: Colors.lightBlue,
                                child: AnimatedContainer(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.email,
                                        color: isElevated
                                            ? HelpayrColors.info
                                            : Colors.white,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                            text: "Sign Up with",
                                            style: GoogleFonts.robotoCondensed(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: isElevated
                                                    ? Colors.blueAccent
                                                    : Colors.white),
                                            children: [
                                              TextSpan(
                                                text: " Email",
                                                style:
                                                    GoogleFonts.robotoCondensed(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ]),
                                      )
                                    ],
                                  ),
                                  curve: Curves.easeInOut,
                                  duration: Duration(milliseconds: 500),
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: isElevated
                                        ? Colors.white
                                        : Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: isElevated
                                        ? [
                                            BoxShadow(
                                              color: Colors.blueAccent,
                                              offset: Offset(4, 4),
                                              blurRadius: 15,
                                            ),
                                          ]
                                        : null,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isElevatedgoogle = !isElevatedgoogle;
                                  });
                                  final provider =
                                      Provider.of<GoogleSignUpProvider>(context,
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
                                child: AnimatedContainer(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.google,
                                        color: isElevatedgoogle
                                            ? HelpayrColors.white
                                            : Colors.blueAccent,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                            text: "Sign Up with",
                                            style: GoogleFonts.robotoCondensed(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: isElevatedgoogle
                                                    ? HelpayrColors.white
                                                    : Colors.black),
                                            children: [
                                              TextSpan(
                                                text: " Google",
                                                style:
                                                    GoogleFonts.robotoCondensed(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: isElevatedgoogle
                                                            ? HelpayrColors
                                                                .white
                                                            : Colors
                                                                .blueAccent),
                                              )
                                            ]),
                                      )
                                    ],
                                  ),
                                  curve: Curves.easeInOut,
                                  duration: Duration(milliseconds: 400),
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: isElevatedgoogle
                                        ? Colors.blueAccent
                                        : HelpayrColors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                          Container(
                            child: Column(children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: welcome(),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isElevated = !isElevated;
                                    bottomSheetModal(context);
                                  });
                                },
                                splashColor: Colors.lightBlue,
                                child: AnimatedContainer(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.email,
                                        color: isElevated
                                            ? HelpayrColors.info
                                            : Colors.white,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                            text: "Sign Up with",
                                            style: GoogleFonts.robotoCondensed(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: isElevated
                                                    ? Colors.blue
                                                    : Colors.white),
                                            children: [
                                              TextSpan(
                                                text: " Email",
                                                style:
                                                    GoogleFonts.robotoCondensed(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ]),
                                      )
                                    ],
                                  ),
                                  curve: Curves.easeInOut,
                                  duration: Duration(milliseconds: 500),
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: isElevated
                                        ? Colors.white
                                        : HelpayrColors.info,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: isElevated
                                        ? [
                                            BoxShadow(
                                              color: Colors.blue,
                                              offset: Offset(4, 4),
                                              blurRadius: 15,
                                            ),
                                          ]
                                        : null,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isElevatedgoogle = !isElevatedgoogle;
                                  });
                                  final provider =
                                      Provider.of<GoogleSignUpProvider>(context,
                                          listen: false);
                                  provider.googleLoginHelper().then((value) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfileMaker(),
                                      ),
                                    );
                                  });
                                },
                                child: AnimatedContainer(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.google,
                                        color: isElevatedgoogle
                                            ? HelpayrColors.white
                                            : Colors.blue,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                            text: "Sign Up with",
                                            style: GoogleFonts.robotoCondensed(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: isElevatedgoogle
                                                    ? HelpayrColors.white
                                                    : Colors.black),
                                            children: [
                                              TextSpan(
                                                text: " Google",
                                                style:
                                                    GoogleFonts.robotoCondensed(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: isElevatedgoogle
                                                            ? HelpayrColors
                                                                .white
                                                            : Colors.blue),
                                              )
                                            ]),
                                      )
                                    ],
                                  ),
                                  curve: Curves.easeInOut,
                                  duration: Duration(milliseconds: 400),
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    boxShadow: isElevatedgoogle
                                        ? [
                                            BoxShadow(
                                              color: Colors.blue,
                                              offset: Offset(4, 4),
                                              blurRadius: 15,
                                            ),
                                          ]
                                        : null,
                                    color: isElevatedgoogle
                                        ? HelpayrColors.info
                                        : HelpayrColors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ]),
                  ),
                ),
                isFirst
                    ? null
                    : GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                                child: LoginPage(),
                                type: PageTransitionType.leftToRight,
                                childCurrent: ChooseLogin()),
                          );
                        },
                        child: RichText(
                          text: TextSpan(
                            text: "Already have an account? ",
                            style: GoogleFonts.robotoCondensed(
                                fontWeight: FontWeight.normal),
                            children: [
                              TextSpan(
                                text: "Log In",
                                style: GoogleFonts.robotoCondensed(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              ),
                            ],
                          ),
                        ),
                      )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

class welcome extends StatelessWidget {
  const welcome({
    Key key,
    this.isUserWelcome = false,
  }) : super(key: key);
  final bool isUserWelcome;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
                text: TextSpan(
                    text: isUserWelcome ? "Hey User," : "Hey Helper,",
                    style: GoogleFonts.robotoCondensed(
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ))),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                  text: "Welcome ",
                  style: GoogleFonts.robotoCondensed(
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                    fontSize: 15,
                  ),
                  children: [TextSpan(text: "Back!")]),
            ),
          ],
        ),
      ],
    );
  }
}
