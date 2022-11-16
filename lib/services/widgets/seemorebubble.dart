import 'package:flutter/material.dart';

import '../../constants/Theme.dart';
import 'header.dart';

class BubbleSeeMore extends StatelessWidget {
  const BubbleSeeMore({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final IntroductoryPage widget;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      width: MediaQuery.of(context).size.width / 4,
      left: MediaQuery.of(context).size.width / 2.3,
      bottom: MediaQuery.of(context).size.height / 5,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Stack(
          children: [
            Container(
              width: 70,
              height: 70,
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "See More",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: HelpayrColors.info,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: HelpayrColors.white.withOpacity(.2),
                    offset: Offset(-4, 2),
                  )
                ],
                shape: BoxShape.circle,
                color: HelpayrColors.white,
              ),
            ),
            Positioned(
              left: 3,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(width: 1.5, color: HelpayrColors.info)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
