import 'package:evently_app/utils/app_colors.dart';

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  String? hintText;
  TextStyle? hintTextStyle;
  TextStyle? textStyle;

  Image? iconName;
  Color borderColor;

  CustomTextField(
      {super.key,
      required this.textStyle,
      required this.hintText,
      required this.hintTextStyle,
      this.iconName,
      required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: textStyle,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintTextStyle,
        prefixIcon: iconName,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.redColor, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
