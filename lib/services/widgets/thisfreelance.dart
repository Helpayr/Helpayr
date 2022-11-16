import 'dart:async';

import 'package:flutter/material.dart';
import 'package:helpayr/constants/Theme.dart';
import 'package:helpayr/services/widgets/categories.dart';

class ThisFreelance extends StatefulWidget {
  const ThisFreelance({key, this.first_pic, this.sec_pic, this.title = ""});
  final String first_pic;
  final String sec_pic;

  final String title;

  @override
  State<ThisFreelance> createState() => _ThisFreelanceState();
}

class _ThisFreelanceState extends State<ThisFreelance> {
  PageController _pageController = PageController(initialPage: 0);
  Timer _timer;
  int currentPage = 0;
  bool isFinal = false;
  final Color layerBlue = HelpayrColors.info.withOpacity(.8);
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (currentPage < 2) {
        currentPage++;
      } else {
        currentPage = 0;
      }

      _pageController.animateToPage(
        currentPage,
        duration: Duration(milliseconds: 150),
        curve: Curves.easeIn,
      );
    });
  }

  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView(
            allowImplicitScrolling: true,
            onPageChanged: (index) {
              setState(() {
                isFinal = index == 1;
              });
            },
            controller: _pageController,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: layerBlue,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.first_pic),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: layerBlue,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.sec_pic),
                  ),
                ),
              ),
            ]),
        DraggableBotSheet(
          title: widget.title,
        ),
      ],
    );
  }
}

class DraggableBotSheet extends StatelessWidget {
  const DraggableBotSheet({
    Key key,
    this.title = "",
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: .2,
        minChildSize: .1,
        expand: true,
        snap: false,
        builder: (BuildContext context, ScrollController myController) {
          return SingleChildScrollView(
            controller: myController,
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: HelpayrColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: CategoriesDrag(
                title: title,
              ),
            ),
          );
        });
  }
}
