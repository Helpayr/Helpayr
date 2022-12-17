import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpayr/screens/privacy_policy.dart';
import 'package:lottie/lottie.dart';

class Terms extends StatefulWidget {
  const Terms({key});

  @override
  State<Terms> createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 9, 103, 150),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              LottieBuilder.network(
                  "https://assets4.lottiefiles.com/packages/lf20_3adn32pc.json"),
              Text(
                "Terms and Conditions",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  children: [
                    Text(
                      "These terms and conditions ${("User Terms")} apply to your visit to and your use of our application (the ${"Application"}), the Service and the Application (as defined below), as well as to all information and/or services provided to you on or through the Application.",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.raleway(color: Colors.white),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "PLEASE READ THESE TERMS OF SERVICE CAREFULLY. BY ACCESSING OR USING THE HELPAYR APPLICATION, YOU AGREE TO BE BOUND BY THESE TERMS OF SERVICE. IF YOU DO NOT AGREE TO ALL OF THESE TERMS AND CONDITIONS, DO NOT ACCESS OR USE THE HELPAYR APPLICATION.",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.raleway(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "I. The Team",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.raleway(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "We are a 4-person group of Information Technology students from Aklan State University - CIT Campus who started development for Helpayr (“HELPAYR”) in the year 2022.",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.raleway(
                          color: Colors.white, fontWeight: FontWeight.normal),
                    ),
                    Text(
                      "II. Definition of Terms",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.raleway(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Bullets(
                      title: "Account",
                      sub:
                          " means the HELPAYR Account that you will need to register for on the Application in the event that you would book a helper's service on the Application.",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Bullets(
                      title: "Available Time",
                      sub:
                          " means any individual who are getting started on the Application before their corresponding role is selected.",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Bullets(
                      title: "User",
                      sub:
                          " means a determined date and time on which the services and stores, collectively referred to as helpers, are open for service.",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Bullets(
                      title: "Includes",
                      sub:
                          " or including or like words or expressions shall mean without limitation.",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Bullets(
                      title: "Booking",
                      sub:
                          " means the service booking requested by you to the Application.",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Bullets(
                      title: "Products",
                      sub:
                          " refer to any of the goods being sold on the Site or App.",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Bullets(
                      title: "Application",
                      sub: " means the Helpayr application itself.",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Bullets(
                      title: "We or Us",
                      sub: " refers to the Helpayr developers.",
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Bullets(
                      title: "You",
                      sub: " means the User who is using the Application.",
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "III. Legal Requirement",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.raleway(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "To place an Order with HELPAYR, you must be over sixteen (16) years of age. If you are under sixteen (16), you may book a helper's service strictly with the involvement of a parent or guardian.",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.raleway(
                          color: Colors.white, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "IV. Prohibitions",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.raleway(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "You must not misuse this Applcation by committing or encouraging a criminal offense, by transmitting or distributing a virus including but not limited to Trojan horse, worm, and similar viruses or by posting any other material on the Application which is malicious, technologically harmful, in breach of confidence or in any way offensive or obscene; or by hacking into any aspect of the service; by corrupting data; by causing annoyance to other users; by infringing upon the rights of any other person’s propriety rights; by sending any unsolicited advertising or promotional material; or by attempting to affect the performance or functionality of any computer facilities of or accessed throughout the Application.",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.raleway(
                          color: Colors.white, fontWeight: FontWeight.normal),
                    ),
                    Text(
                      "V. Terms of the Service",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.raleway(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "To request a Booking, you must register with us by creating an Account on the Application. You must only submit to us information which is accurate and true.You shall not misuse the Application, especially with multiple user accounts.A name and password may be selected for the privacy and security of your account. We recommend you not to share your user credentials with anyone. ",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.raleway(
                          color: Colors.white, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "VI. Personal data protection",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.raleway(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Privacy(),
                          ),
                        );
                      },
                      child: Text(
                        "Please see our Privacy Policy. ",
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.raleway(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "VII. Cooperation",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.raleway(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "7.1 HELPAYR shall perform its obligations under these Terms and Conditions with reasonable skills and care.",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.raleway(
                          color: Colors.white, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "7.2 You may contact us at any time through helpayr@gmail.com. We will attempt to address your relevant questions and concerns as soon as possible.",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.raleway(
                          color: Colors.white, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "7.3 In rare cases your emails may be caught up in our spam filters or not reach us, or correspondence that we send to you may otherwise not have reached you.",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.raleway(
                          color: Colors.white, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "VIII. Notices",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.raleway(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "We reserve the right to amend these Terms and Conditions at any time. Continued use of the Application will be deemed to constitute acceptance of the new Terms and Conditions.",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.raleway(
                          color: Colors.white, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "IX. Relationship",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.raleway(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Nothing in these Terms and Conditions shall create or be deemed to create a partnership, an agency or a relationship between you and HELPAYR.",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.raleway(
                          color: Colors.white, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "X. Interpretation",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.raleway(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Headings are for ease of reference only and shall not affect the interpretation or construction of the Terms and Conditions;",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.raleway(
                          color: Colors.white, fontWeight: FontWeight.normal),
                    ),
                    Text(
                      "Words imparting the singular shall include the plural and vice versa. Words imparting a gender shall include every gender and references to persons shall include an individual, company, corporation, firm or partnership.",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.raleway(
                          color: Colors.white, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "XI. Final provision",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.raleway(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "The English text of these User Terms constitutes the sole authentic text, thus guaranteed to prevail.",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.raleway(
                          color: Colors.white, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
