import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpayr/constants/Theme.dart';
import 'package:helpayr/screens/onboarding/onboarding.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SlideOnboarding extends StatefulWidget {
  const SlideOnboarding({Key key});

  @override
  State<SlideOnboarding> createState() => _SlideOnboardingState();
}

class _SlideOnboardingState extends State<SlideOnboarding> {
  int currentPage = 0;
  bool isFinal = false;
  PageController _ctrl = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: (index) {
          setState(() {
            isFinal = index == 2;
          });
        },
        controller: _ctrl,
        children: [Helpers(), Users(), Onboarding()],
      ),
      bottomSheet: isFinal
          ? null
          : Container(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          return _ctrl.animateToPage(2,
                              duration: Duration(milliseconds: 200),
                              curve: Curves.easeIn);
                        },
                        child: Text(
                          "Skip",
                          style: TextStyle(
                            color: HelpayrColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    SmoothPageIndicator(
                      effect: const SwapEffect(
                          spacing: 16,
                          dotColor: Colors.white,
                          activeDotColor: Colors.blue,
                          dotHeight: 4,
                          dotWidth: 15),
                      controller: _ctrl,
                      count: 3,
                      onDotClicked: ((index) => _ctrl.animateToPage(index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut)),
                    ),
                    TextButton(
                        onPressed: () => _ctrl.nextPage(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.easeIn),
                        child: Text(
                          "Next",
                          style: TextStyle(
                            color: HelpayrColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ],
                ),
              ),
            ),
    );
  }
}

class Helpers extends StatelessWidget {
  const Helpers({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned(
              left: 130,
              child: Container(
                width: MediaQuery.of(context).size.width / 1.3,
                height: MediaQuery.of(context).size.height / 1.35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage("assets/onboarding new/laundry.png")),
                  border: Border.all(
                      width: 5, color: Color.fromARGB(255, 54, 76, 94)),
                ),
              ),
            ),
            Positioned(
              child: Container(
                width: MediaQuery.of(context).size.width / 1.1,
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(
                          "assets/onboarding new/helpayr onboard circle6.png")),
                  border: Border.all(
                      width: 5, color: Color.fromARGB(255, 54, 76, 94)),
                ),
              ),
            ),
            Positioned(
              left: 170,
              child: Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: MediaQuery.of(context).size.height / 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage("assets/onboarding new/manicure.png")),
                  border: Border.all(
                      width: 5, color: Color.fromARGB(255, 54, 76, 94)),
                ),
              ),
            ),
            Positioned(
              left: 10,
              top: 440,
              child: Column(
                children: [
                  Text(
                    "HELPERS",
                    style: GoogleFonts.raleway(
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(2, 3),
                          blurRadius: 3,
                        )
                      ],
                      letterSpacing: 1.5,
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                            color: Colors.white, style: BorderStyle.solid),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.thumbsUp,
                                  color: Colors.white,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Apply for your service of choice",
                                    style: GoogleFonts.raleway(
                                        fontSize: 40,
                                        shadows: [
                                          Shadow(
                                              color: Colors.blue,
                                              offset: Offset(2, 2))
                                        ],
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.thumbsUp,
                                  color: Colors.white,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Receive ratings from the Users",
                                    style: GoogleFonts.raleway(
                                        fontSize: 40,
                                        shadows: [
                                          Shadow(
                                              color: Colors.blue,
                                              offset: Offset(2, 2))
                                        ],
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
              scale: 2,
              image: AssetImage("assets/onboarding new/bg_wavy.png"),
              fit: BoxFit.fill),
        ),
      ),
    );
  }
}

class Users extends StatelessWidget {
  const Users({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Positioned(
              right: 130,
              child: Container(
                width: MediaQuery.of(context).size.width / 1.3,
                height: MediaQuery.of(context).size.height / 1.35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage(
                          "assets/onboarding new/helpayr onboard circle5.png")),
                  border: Border.all(
                      width: 5, color: Color.fromARGB(255, 54, 76, 94)),
                ),
              ),
            ),
            Positioned(
              left: 25,
              child: Container(
                width: MediaQuery.of(context).size.width / 1,
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("assets/onboarding new/grocery.png")),
                  border: Border.all(
                      width: 5, color: Color.fromARGB(255, 54, 76, 94)),
                ),
              ),
            ),
            Positioned(
              right: 170,
              child: Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: MediaQuery.of(context).size.height / 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage("assets/onboarding new/freelamce.png")),
                  border: Border.all(
                      width: 5, color: Color.fromARGB(255, 54, 76, 94)),
                ),
              ),
            ),
            Positioned(
              right: 10,
              top: 440,
              child: Column(
                children: [
                  Text(
                    "USERS",
                    style: GoogleFonts.raleway(
                      shadows: [
                        Shadow(
                          color: Colors.black,
                          offset: Offset(2, 3),
                          blurRadius: 3,
                        )
                      ],
                      letterSpacing: 1.5,
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                            color: Colors.white, style: BorderStyle.solid),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.thumbsUp,
                                  color: Colors.white,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Reach out different services",
                                    style: GoogleFonts.raleway(
                                        fontSize: 40,
                                        shadows: [
                                          Shadow(
                                              color: Colors.blue,
                                              offset: Offset(2, 2))
                                        ],
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  FontAwesomeIcons.thumbsUp,
                                  color: Colors.white,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Rate the Helpers",
                                    style: GoogleFonts.raleway(
                                        fontSize: 40,
                                        shadows: [
                                          Shadow(
                                              color: Colors.blue,
                                              offset: Offset(2, 2))
                                        ],
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
              scale: 2,
              image: AssetImage("assets/onboarding new/bg_wavy_users.png"),
              fit: BoxFit.fill),
        ),
      ),
    );
  }
}
