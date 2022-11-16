import 'package:flutter/material.dart';

import '../../constants/Theme.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleWidget1 extends StatefulWidget {
  const TitleWidget1({
    Key key,
    this.isFirst = false,
    this.service_title,
  }) : super(key: key);
  final bool isFirst;
  final String service_title;

  @override
  State<TitleWidget1> createState() => _TitleWidget1State();
}

class _TitleWidget1State extends State<TitleWidget1> {
  @override
  Widget build(BuildContext context) {
    return widget.isFirst
        ? Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0, top: 50),
                      child: Text(
                        "LIFE",
                        style: TextStyle(
                          fontSize: 70,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "BEGINS",
                          style: TextStyle(
                            color: HelpayrColors.white,
                            fontSize: 50,
                          ),
                        ),
                        Text(
                          "AT THE END",
                          style: TextStyle(
                            color: HelpayrColors.info,
                            fontSize: 30,
                            shadows: [
                              Shadow(
                                  color: HelpayrColors.white,
                                  blurRadius: 1.1,
                                  offset: Offset(2, 3))
                            ],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Image.asset(
                  "assets/pngs/arrow.png",
                  height: 120,
                  color: HelpayrColors.white,
                ),
              ],
            ),
          )
        : Stack(
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 20),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: 80,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: RichText(
                        text: TextSpan(
                          text: widget.service_title,
                          style: GoogleFonts.radioCanada(
                            letterSpacing: 3,
                            color: HelpayrColors.info,
                            fontSize: 55,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )),
              Positioned(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 7),
                  child: Image(
                    width: 300,
                    color: Colors.white,
                    image: AssetImage("assets/pngs/underline.png"),
                  ),
                ),
              ),
              Positioned(
                child: Padding(
                  padding: const EdgeInsets.only(left: 50.0, top: 60),
                  child: Image(
                    width: 120,
                    color: Colors.white,
                    image: AssetImage("assets/pngs/arrow.png"),
                  ),
                ),
              ),
            ],
          );
  }
}
