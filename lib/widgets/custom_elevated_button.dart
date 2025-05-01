import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_style.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  Color backgroundColor;
  TextStyle textStyle;
  String text;
  Widget? icon;

  CustomElevatedButton(
      {super.key,
      required this.backgroundColor,
      required this.textStyle,
      required this.text,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: backgroundColor,
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
