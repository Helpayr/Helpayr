import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpayr/constants/Theme.dart';

class CardHorizontal extends StatefulWidget {
  CardHorizontal({
    this.title = "Placeholder Title",
    this.cta = "See More",
    this.img = "https://via.placeholder.com/200",
    this.tap = defaultFunc,
    this.serviceType = "",
    this.isSvg = false,
    this.color,
  });

  final String cta;
  final String img;
  final Function tap;
  final String title;
  final String serviceType;
  final bool isSvg;
  final Color color;
  static void defaultFunc() {
    print("the function works!");
  }

  @override
  State<CardHorizontal> createState() => _CardHorizontalState();
}

class _CardHorizontalState extends State<CardHorizontal> {
  bool isElevated = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 5, 49, 124),
              Color.fromARGB(255, 20, 73, 165),
              Color.fromARGB(255, 33, 98, 209),
              Colors.blueAccent,
              Colors.blue,
              Colors.blue,
            ],
            begin: isElevated ? Alignment.topLeft : Alignment.bottomRight,
            end: isElevated ? Alignment.bottomRight : Alignment.topLeft,
          ),
          boxShadow: isElevated
              ? [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(4, 1),
                    blurRadius: 5,
                    spreadRadius: 3,
                  ),
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(-4, -4),
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        duration: Duration(milliseconds: 500),
        curve: Curves.easeIn,
        height: 130,
        child: GestureDetector(
          onTap: () {
            widget.tap();
            setState(() {
              isElevated = !isElevated;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: widget.isSvg
                      ? SvgPicture.network(
                          widget.img,
                          fit: BoxFit.contain,
                        )
                      : Image.asset(
                          widget.img,
                          fit: BoxFit.cover,
                        ),
                ),
                SizedBox(
                  width: 30,
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  height: isElevated ? 100 : 60,
                  width: isElevated ? 3 : 2,
                  color: Colors.white,
                ),
                Flexible(
                    flex: isElevated ? 8 : 2,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: isElevated
                                ? MainAxisAlignment.center
                                : MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  widget.serviceType,
                                  style: GoogleFonts.raleway(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(widget.title,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: HelpayrColors.white,
                                fontSize: isElevated ? 13 : 8,
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(widget.cta,
                                  style: TextStyle(
                                      color: HelpayrColors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600)),
                            ],
                          )
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ));
  }
}
