import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_style.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  Color? backgroundColor;
  Color? borderSide;

  TextStyle textStyle;
  String text;
  Widget? icon;
  VoidCallback? onClick;

  CustomElevatedButton(
      {super.key,
      this.backgroundColor,
      required this.textStyle,
      required this.text,
        this.borderSide,
        this.onClick,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onClick,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: borderSide ?? AppColors.transparentColor,
          ),
          borderRadius: BorderRadius.circular(16),

        ),

        backgroundColor: backgroundColor ?? AppColors.primaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ?? SizedBox(),
            SizedBox(
              width: 8,
            ),
            Text(text, style: textStyle),
          ],
        ),
      ),
    );
  }
}
