import 'package:flutter/material.dart';
import 'package:helpayr/services/widgets/cardGrid.dart';

import '../../constants/services_tentative.dart';
import '../title.dart';

class Construction extends StatelessWidget {
  const Construction({key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleService(title: "Construction"),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: cardGrid(
            length_items: construction.length,
            cardbuilder: (context, index) => cardGridpng(
              index: index,
              title: construction[index],
              img: construction_img[index],
            ),
          ),
        ),
      ],
    );
  }
}
