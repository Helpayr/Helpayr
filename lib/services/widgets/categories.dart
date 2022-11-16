import 'package:flutter/material.dart';
import 'package:helpayr/constants/Theme.dart';
import 'package:helpayr/services/construction/home.dart';

import '../../Message/helpers.dart';
import '../../widgets/card-horizontal.dart';
import '../../widgets/card-small.dart';

final List<String> freelance = [
  "Top Posts",
  "Trending",
  "Available",
  "For You",
  "Others"
];

class CategoriesDrag extends StatefulWidget {
  const CategoriesDrag({key, this.title = "", this.lists});
  final String title;
  final Widget lists;
  @override
  State<CategoriesDrag> createState() => _CategoriesDragState();
}

class _CategoriesDragState extends State<CategoriesDrag> {
  PageController _pagectrl = PageController(initialPage: 0);
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 5,
          width: 150,
          color: HelpayrColors.black,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0, right: 3),
              child: Center(
                  child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              )),
            ),
            Text(
              "123",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: SizedBox(
            height: 30,
            child: ListView.builder(
              itemBuilder: ((context, index) => category(index)),
              scrollDirection: Axis.horizontal,
              itemCount: freelance.length,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Divider(
            thickness: 2.5,
            height: 2,
            color: Colors.grey.withOpacity(.2),
          ),
        ),
        Expanded(
          child: PageView(
              physics: NeverScrollableScrollPhysics(),
              allowImplicitScrolling: true,
              controller: _pagectrl,
              children: <Widget>[
                widget.lists,
                Trending(),
                Available(),
                ForYou(),
                Others()
              ]),
        ),
      ],
    );
  }

  Widget category(int index) => GestureDetector(
        onTap: () {
          setState(() {
            selected = index;
          });
          _pagectrl.animateToPage(index,
              duration: Duration(milliseconds: 600), curve: Curves.easeInCirc);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GestureDetector(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  freelance[index],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: selected == index ? 18 : null,
                    color: selected == index
                        ? HelpayrColors.black
                        : HelpayrColors.text.withOpacity(.5),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.only(top: 1),
                  height: 2,
                  width: 20,
                  color: selected == index
                      ? HelpayrColors.black
                      : Colors.transparent,
                )
              ],
            ),
          ),
        ),
      );
}

class Trending extends StatelessWidget {
  const Trending({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            freelance[1],
            style: TextStyle(fontSize: 30),
          ),
        ),
        Row(
          children: [
            CardSmall(
              img: Helpers.randomPictureUrl(),
            ),
            CardSmall(
              img: Helpers.randomPictureUrl(),
            ),
          ],
        ),
      ],
    );
  }
}

class TopPosts extends StatelessWidget {
  const TopPosts({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(freelance[0],
                style: TextStyle(
                  fontSize: 30,
                )),
          ),
          Construction(),
          CardHorizontal(
            img: Helpers.randomPictureUrl(),
          )
        ],
      ),
    );
  }
}

class Available extends StatelessWidget {
  const Available({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            freelance[2],
            style: TextStyle(fontSize: 30),
          ),
        ),
        Row(
          children: [
            CardSmall(
              img: Helpers.randomPictureUrl(),
            ),
            CardSmall(
              img: Helpers.randomPictureUrl(),
            )
          ],
        ),
        CardHorizontal(
          img: Helpers.randomPictureUrl(),
        )
      ],
    );
  }
}

class ForYou extends StatelessWidget {
  const ForYou({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            freelance[3],
            style: TextStyle(fontSize: 30),
          ),
        ),
        Row(
          children: [
            CardSmall(
              img: Helpers.randomPictureUrl(),
            ),
            CardSmall(
              img: Helpers.randomPictureUrl(),
            )
          ],
        ),
        CardHorizontal(
          img: Helpers.randomPictureUrl(),
        )
      ],
    );
  }
}

class Others extends StatelessWidget {
  const Others({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            freelance[4],
            style: TextStyle(fontSize: 30),
          ),
        ),
        Row(
          children: [
            CardSmall(
              img: Helpers.randomPictureUrl(),
            ),
            CardSmall(
              img: Helpers.randomPictureUrl(),
            )
          ],
        ),
        CardHorizontal(
          img: Helpers.randomPictureUrl(),
        )
      ],
    );
  }
}
