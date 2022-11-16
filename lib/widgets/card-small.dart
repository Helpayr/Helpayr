import 'package:flutter/material.dart';
import 'package:helpayr/constants/Theme.dart';

class CardSmall extends StatefulWidget {
  CardSmall(
      {this.title = "Placeholder Title",
      this.cta = "See More",
      this.img = "https://via.placeholder.com/200",
      this.tap = defaultFunc,
      this.serviceType = ""});

  final String cta;
  final String img;
  final Function tap;
  final String title;
  final serviceType;

  static void defaultFunc() {
    print("the function works!");
  }

  @override
  State<CardSmall> createState() => _CardSmallState();
}

class _CardSmallState extends State<CardSmall> {
  bool isElevated = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      decoration: BoxDecoration(
        boxShadow: isElevated
            ? [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(1, 1),
                  blurRadius: 5,
                  spreadRadius: 3,
                ),
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(-1, -1),
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      height: 235,
      child: GestureDetector(
        onTap: () {
          setState(() {
            isElevated = !isElevated;
          });
        },
        child: Card(
            elevation: 3,
            shadowColor: HelpayrColors.muted.withOpacity(0.22),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    flex: 7,
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4.0),
                                topRight: Radius.circular(4.0)),
                            image: DecorationImage(
                              image: AssetImage(widget.img),
                              fit: BoxFit.cover,
                            )))),
                Flexible(
                    flex: 9,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, bottom: 16.0, left: 16.0, right: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.serviceType,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(widget.title,
                              style: TextStyle(
                                  color: HelpayrColors.text, fontSize: 12)),
                          GestureDetector(
                            onTap: widget.tap,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(widget.cta,
                                  style: TextStyle(
                                      color: HelpayrColors.info,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600)),
                            ),
                          )
                        ],
                      ),
                    ))
              ],
            )),
      ),
    );
  }
}
