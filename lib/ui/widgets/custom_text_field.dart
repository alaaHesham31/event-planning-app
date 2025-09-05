import 'package:evently_app/utils/app_colors.dart';

import 'package:flutter/material.dart';

typedef MyValidator = String? Function(String?)?;

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final TextStyle? hintTextStyle;
  final TextStyle? textStyle;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color borderColor;
  final int? maxLines;
  final bool? obscureText;
  final MyValidator validator;
  final TextEditingController? controller;
  final Color? prefixIconColor;
  final Color? suffixIconColor;

  const  CustomTextField(
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
      required this.borderColor,
      this.prefixIconColor,
      this.suffixIconColor});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: textStyle,
      maxLines: maxLines ?? 1,
      validator: validator,
      obscureText: obscureText ?? false,
      obscuringCharacter: '*',
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: hintTextStyle,
        prefixIcon: prefixIcon,
        prefixIconColor: prefixIconColor,
        suffixIcon: suffixIcon,
        suffixIconColor: suffixIconColor,
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
