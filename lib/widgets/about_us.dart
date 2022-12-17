import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpayr/widgets/drawer.dart';
import 'package:lottie/lottie.dart';

class About_Us extends StatefulWidget {
  const About_Us({key});

  @override
  State<About_Us> createState() => _About_UsState();
}

class _About_UsState extends State<About_Us> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 9, 103, 150),
      drawer: NowDrawer(
        currentPage: "About Us",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                Text(
                  "About Us!",
                  style: GoogleFonts.oswald(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
                LottieBuilder.network(
                  "https://assets9.lottiefiles.com/packages/lf20_ljotbiif.json",
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome to ",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Container(
                      height: 20,
                      width: 60,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage("assets/helpayrblue.png"))),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "A mobile personal helper system that aims to build a platform for small businesses and helpers in Aklan. Helpayr offers chat functionality and booking options as well as displays featured stores and available helpers. Developed in the year 2022 by a group of Information Technology students from Aklan State University - CIT Campus.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.raleway(color: Colors.white),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 20,
                      width: 60,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage("assets/helpayrblue.png"))),
                    ),
                    Text(
                      " is a product of a Capstone Project",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.raleway(color: Colors.white),
                    ),
                  ],
                ),
                Text(
                  "The aim of this app is to support the growth of our fellow Aklanons' services and small businesses. As a result, users can quickly search for and contact the helpers they are looking for, and the helpers themselves may swiftly draw in customers thanks to their basic information, prices, and services and works provided.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.raleway(color: Colors.white),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "We hope to provide the expected convenience Helpayr can offer to our fellow Aklanon users and helpers.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.raleway(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
