import 'package:evently_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  Color? backgroundColor;
  Color? borderSide;


  TextStyle textStyle;
  String text;
  Widget? icon;
  VoidCallback? onClick;
  final bool isLoading;

  CustomElevatedButton(
      {super.key,
      this.backgroundColor,
      required this.textStyle,
      required this.text,
      this.borderSide,
      this.onClick,
      this.icon,
      this.isLoading = false,
     });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onClick,
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
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Padding(
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
