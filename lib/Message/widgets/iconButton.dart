import 'package:flutter/material.dart';
import 'package:helpayr/constants/Theme.dart';

import '../theme.dart';

class IconBackground extends StatelessWidget {
  const IconBackground({
    Key key,
    this.icon,
    this.onTap,
    this.size,
  }) : super(key: key);

  final IconData icon;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.withOpacity(.1),
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        splashColor: AppColors.secondary,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(
            icon,
            color: Colors.black,
            size: size,
          ),
        ),
      ),
    );
  }
}

class IconBorder extends StatelessWidget {
  const IconBorder({
    Key key,
    this.icon,
    this.onTap,
    this.size,
  }) : super(key: key);

  final IconData icon;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      splashColor: AppColors.secondary,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            width: 2,
            color: Colors.black.withOpacity(.2),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            icon,
            size: size,
            color: HelpayrColors.black.withOpacity(.5),
          ),
        ),
      ),
    );
  }
}
