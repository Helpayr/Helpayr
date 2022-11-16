import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:helpayr/constants/Theme.dart';
import 'package:helpayr/constants/services_tentative.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import '../freelance/freelance.dart';
import '../title.dart';

class Designing extends StatefulWidget {
  const Designing({key});

  @override
  State<Designing> createState() => _DesigningState();
}

class _DesigningState extends State<Designing> {
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
            title: "Designing",
          ),
        ),
        Container(
          child: ScrollSnapList(
            curve: Curves.easeInCubic,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return designing_list(index);
            },
            scrollDirection: Axis.horizontal,
            itemCount: design_img.length,
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
        isPng: false,
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
    this.isPng = false,
    this.img,
  }) : super(key: key);

  final int selected;
  final bool isElevated;
  final int index;
  final bool isPng;
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
                design[index],
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
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          desc_design[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: isPng
                        ? Image.asset(
                            img[index],
                            fit: BoxFit.contain,
                          )
                        : SvgPicture.asset(
                            design_img[index],
                            allowDrawingOutsideViewBox: true,
                            fit: BoxFit.contain,
                          ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: selected == index
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FreeLanceHome(),
                            ),
                          );
                        }
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "See More",
                      style: TextStyle(
                          color: HelpayrColors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
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
