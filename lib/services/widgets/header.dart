import 'package:flutter/material.dart';
import 'package:helpayr/constants/Theme.dart';
import 'package:helpayr/services/widgets/seemorebubble.dart';

class IntroductoryPage extends StatefulWidget {
  const IntroductoryPage(
      {key,
      this.bgPhoto,
      this.title,
      this.onTap,
      this.pageTitle,
      this.bubble = false,
      this.isPage1 = false});
  final String bgPhoto;
  final String title;
  final Function onTap;
  final Widget pageTitle;
  final bool bubble;
  final bool isPage1;

  @override
  State<IntroductoryPage> createState() => _IntroductoryPageState();
}

class _IntroductoryPageState extends State<IntroductoryPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: widget.isPage1 ? Alignment.topLeft : Alignment.centerLeft,
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(widget.bgPhoto),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: HelpayrColors.info.withOpacity(.1),
            ),
          ),
          Positioned(
            bottom: widget.isPage1 ? null : 150,
            child: widget.pageTitle,
          ),
          if (widget.bubble) BubbleSeeMore(widget: widget)
        ]);
  }
}
