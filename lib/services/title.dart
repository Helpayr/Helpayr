import 'package:flutter/material.dart';
import 'package:helpayr/constants/Theme.dart';

class TitleService extends StatelessWidget {
  const TitleService({
    key,
    this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                letterSpacing: 1.5,
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
          Container(
            width: 70,
            height: 30,
            child: Center(
              child: Text(
                "View All",
                style: TextStyle(
                    color: HelpayrColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
          )
        ],
      ),
    );
  }
}
