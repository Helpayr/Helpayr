import 'package:flutter/material.dart';
import 'package:helpayr/constants/services_tentative.dart';

import '../firebase/List_data_page.dart';
import '../widgets/card-horizontal.dart';

class BikeShop extends StatelessWidget {
  const BikeShop({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: CardHorizontal(
          serviceType: "BikeStore",
          img: repair_img[1],
          title: "Repairs bicycles specifically.",
          cta: "See More",
          tap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ListData(
                  isService: false,
                  userType: "Helpers",
                  service: "Store",
                  type: "BikeStore",
                ),
              ),
            );
          }),
    );
  }
}
