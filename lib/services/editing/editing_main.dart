import 'package:flutter/material.dart';
import 'package:helpayr/constants/services_tentative.dart';
import 'package:helpayr/services/title.dart';
// ignore: unused_import
import 'package:flutter_svg/svg.dart';
import '../widgets/cardGrid.dart';

class Editing extends StatefulWidget {
  const Editing({key});

  @override
  State<Editing> createState() => _EditingState();
}

class _EditingState extends State<Editing> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleService(title: "Editing"),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: cardGrid(
            length_items: editor.length,
            cardbuilder: (context, index) => cardGridsvg(
              index: index,
              title: editor[index],
              img: editor_img[index],
            ),
          ),
        ),
      ],
    );
  }
}
