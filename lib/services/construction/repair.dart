import 'package:flutter/material.dart';
import 'package:helpayr/constants/services_tentative.dart';

import '../title.dart';
import '../widgets/cardGrid.dart';

class Repair extends StatelessWidget {
  const Repair({key});

  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleService(title: "Repair"),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: cardGrid(
            length_items: repair.length,
            cardbuilder: (context, index) => cardGridpngR(
              index: index,
              title: repair[index],
              img: repair_img[index],
            ),
          ),
        ),
      ],
    );
  }
}
