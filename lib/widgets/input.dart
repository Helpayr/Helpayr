import 'package:flutter/material.dart';
import 'package:helpayr/constants/Theme.dart';

class Input extends StatelessWidget {
  final String placeholder;
  final Widget suffixIcon;
  final Widget prefixIcon;
  final Function onTap;
  final Function(String) onChanged;
  final TextEditingController controller;
  final bool autofocus;
  final Color borderColor;
  final bool obscureText;
  final TextInputAction textInputaction;

  Input(
      {this.placeholder,
      this.suffixIcon,
      this.prefixIcon,
      this.onTap,
      this.onChanged,
      this.autofocus = false,
      this.borderColor = HelpayrColors.border,
      this.controller,
      this.obscureText = false,
      this.textInputaction});

  @override
  Widget build(BuildContext context) {
    return TextField(
        textInputAction: textInputaction,
        obscureText: obscureText,
        cursorColor: HelpayrColors.muted,
        onTap: onTap,
        onChanged: onChanged,
        controller: controller,
        autofocus: autofocus,
        style:
            TextStyle(height: 0.55, fontSize: 13.0, color: HelpayrColors.time),
        textAlignVertical: TextAlignVertical(y: 0.6),
        decoration: InputDecoration(
            filled: true,
            fillColor: HelpayrColors.white,
            hintStyle: TextStyle(
              color: HelpayrColors.time,
            ),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0),
                borderSide: BorderSide(
                    color: borderColor, width: 1.0, style: BorderStyle.solid)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0),
                borderSide: BorderSide(
                    color: borderColor, width: 1.0, style: BorderStyle.solid)),
            hintText: placeholder));
  }
}
