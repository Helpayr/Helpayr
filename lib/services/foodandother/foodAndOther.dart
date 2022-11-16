import 'package:flutter/material.dart';
import 'package:helpayr/constants/services_tentative.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import '../../constants/Theme.dart';
import '../title.dart';
import '../widgets/cardGrid.dart';

class Food extends StatelessWidget {
  const Food({key});

  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleService(title: "Food"),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: cardGrid(
            length_items: food.length,
            cardbuilder: (context, index) => cardGridpngF(
              index: index,
              title: food[index],
              img: food_img[index],
            ),
          ),
        ),
      ],
    );
  }
}

class Others extends StatefulWidget {
  const Others({key});

  @override
  State<Others> createState() => _DesigningState();
}

class _DesigningState extends State<Others> {
  bool isElevated = false;
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5.0, right: 5),
          child: TitleService(
            title: "Others",
          ),
        ),
        Container(
          child: ScrollSnapList(
            curve: Curves.easeInOut,
            shrinkWrap: true,
            itemBuilder: (context, index) => designing_list(index),
            scrollDirection: Axis.horizontal,
            itemCount: others.length,
            itemSize: 330,
            onItemFocus: (int) => designing_list(int),
            dynamicItemSize: true,
            duration: 100,
          ),
          height: 210,
        ),
      ],
    );
  }

  GestureDetector designing_list(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isElevated = !isElevated;
          selected = index;
        });
      },
      child: theCard(
        selected: selected,
        isElevated: isElevated,
        index: index,
      ),
    );
  }
}

class theCard extends StatelessWidget {
  const theCard({
    Key key,
    @required this.selected,
    @required this.isElevated,
    @required this.index,
    this.img,
  }) : super(key: key);

  final int selected;
  final bool isElevated;
  final int index;

  final String img;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      width: 330,
      height: 210,
      child: Card(
        shadowColor: colors[index],
        color: colors[index],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: selected == index
            ? isElevated
                ? 15
                : 2
            : 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Text(
                others[index],
                style: TextStyle(
                    letterSpacing: 1.5,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.white),
              ),
            ),
            Divider(
              height: 9,
              thickness: 2,
              color: Colors.white.withOpacity(.6),
            ),
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    flex: 1,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          lorem,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Image.asset(
                        other_img[index],
                        fit: BoxFit.contain,
                      )),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    "See More",
                    style: TextStyle(
                        color: HelpayrColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
