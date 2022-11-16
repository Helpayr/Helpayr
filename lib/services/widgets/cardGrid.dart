import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/Theme.dart';
import '../../constants/services_tentative.dart';

class cardGrid extends StatelessWidget {
  const cardGrid({
    Key key,
    this.length_items,
    this.cardbuilder,
  }) : super(key: key);
  final int length_items;
  final Function cardbuilder;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: .75,
        crossAxisCount: 2,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemBuilder: cardbuilder,
      itemCount: length_items,
    );
  }
}

class cardGridsvg extends StatelessWidget {
  const cardGridsvg({
    Key key,
    @required this.index,
    this.title,
    this.img,
  }) : super(key: key);

  final int index;
  final String title;
  final String img;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colors[index],
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, top: 20),
              child: Text(
                title,
                style: TextStyle(
                  color: HelpayrColors.white,
                  letterSpacing: 1.5,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                img,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SeeMore()
        ],
      ),
    );
  }
}

class cardGridpng extends StatelessWidget {
  const cardGridpng({
    Key key,
    @required this.index,
    this.title,
    this.img,
  }) : super(key: key);

  final int index;
  final String title;
  final String img;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colors[index],
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, top: 20),
              child: Text(
                title,
                style: TextStyle(
                  color: HelpayrColors.white,
                  letterSpacing: 1.5,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage(
                      construction_img[index],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SeeMore()
        ],
      ),
    );
  }
}

class cardGridpngR extends StatelessWidget {
  const cardGridpngR({
    Key key,
    @required this.index,
    this.title,
    this.img,
  }) : super(key: key);

  final int index;
  final String title;
  final String img;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colors[index],
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, top: 20),
              child: Text(
                title,
                style: TextStyle(
                  color: HelpayrColors.white,
                  letterSpacing: 1.5,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage(
                      repair_img[index],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SeeMore()
        ],
      ),
    );
  }
}

class cardGridpngF extends StatelessWidget {
  const cardGridpngF({
    Key key,
    @required this.index,
    this.title,
    this.img,
  }) : super(key: key);

  final int index;
  final String title;
  final String img;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colors[index],
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, top: 20),
              child: Text(
                title,
                style: TextStyle(
                  color: HelpayrColors.white,
                  letterSpacing: 1.5,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: AssetImage(
                      food_img[index],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SeeMore()
        ],
      ),
    );
  }
}

class SeeMore extends StatelessWidget {
  const SeeMore({key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "See More",
            style: TextStyle(
                color: HelpayrColors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
