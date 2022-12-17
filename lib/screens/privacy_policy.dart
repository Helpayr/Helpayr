import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpayr/widgets/drawer.dart';
import 'package:lottie/lottie.dart';

class Privacy extends StatefulWidget {
  const Privacy({key});

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 9, 103, 150),
      drawer: NowDrawer(
        currentPage: "Privacy Policy",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Privacy Policy",
                style: GoogleFonts.oswald(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
              LottieBuilder.network(
                  "https://assets4.lottiefiles.com/packages/lf20_msdmfngy.json"),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    Text(
                      "This Privacy Policy describes Our policies and procedures on the collection, use and disclosure of Your information when You use the Service and tells You about Your privacy rights and how the law protects You.",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.raleway(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "Interpretation and Definitions",
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.raleway(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Interpretation",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.raleway(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "The words of which the initial letter is capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural.",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.raleway(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Definitions",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.raleway(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "For the purposes of this Privacy Policy:",
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.raleway(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Bullets(
                        title: "Account",
                        sub:
                            " means a unique account created for You to access our Service or parts of our Service."),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Bullets extends StatelessWidget {
  const Bullets({
    Key key,
    this.title,
    this.sub,
  }) : super(key: key);
  final String title;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            text: title,
            style: GoogleFonts.raleway(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            children: [
          TextSpan(
            text: sub,
            style: GoogleFonts.raleway(
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
          ),
        ]));
  }
}
