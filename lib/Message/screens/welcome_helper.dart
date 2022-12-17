import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpayr/screens/profile_maker.dart';
import 'package:helpayr/screens/select_service.dart';
import 'package:lottie/lottie.dart';

class Welcome_Helper extends StatefulWidget {
  const Welcome_Helper({key});

  @override
  State<Welcome_Helper> createState() => _Welcome_HelperState();
}

class _Welcome_HelperState extends State<Welcome_Helper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Color.fromARGB(255, 9, 103, 150),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text("Welcome Helper!",
                  style: GoogleFonts.oswald(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white)),
              Text("Register or Proceed to your Dashboard",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                      color: Colors.white)),
              SizedBox(
                height: 30,
              ),
              LottieBuilder.network(
                  "https://assets9.lottiefiles.com/packages/lf20_qo07xg45.json"),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileMaker(),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Register",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Service_ChooseFirst(),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Go to Dashboard",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.white),
                    ),
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
