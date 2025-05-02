import 'dart:math';

import 'package:evently_app/utils/app_colors.dart';

import 'package:flutter/material.dart';
typedef MyValidator = String? Function(String?)?;

class CustomTextField extends StatelessWidget {
  String? hintText;
  TextStyle? hintTextStyle;
  TextStyle? textStyle;
  Image? suffixIcon;
  Image? prefixIcon;
  Color borderColor;
  int? maxLines;
  bool? obscureText;
  MyValidator validator;
  TextEditingController? controller;

  CustomTextField(
      {super.key,
      required this.textStyle,
      required this.hintText,
      required this.hintTextStyle,
      this.prefixIcon,
      this.suffixIcon,
      this.maxLines,
      this.obscureText,
        this.validator,
        this.controller,
      required this.borderColor});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller:  controller,
      style: textStyle,
      maxLines: maxLines,
      validator: validator,
      obscureText: obscureText ?? false,
      obscuringCharacter: '*',
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintTextStyle,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
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
