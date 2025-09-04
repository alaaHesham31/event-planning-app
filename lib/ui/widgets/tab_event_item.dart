import 'package:evently_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

class TabEventItem extends StatelessWidget {
  bool isSelected;
  String eventName;
  String eventIconPath;
  Color backgroundSelectedColor;
  Color borderUnSelectedColor;
  Color selectedIconColor;
  Color unSelectedIconColor;
  TextStyle selectedTextStyle;
  TextStyle unSelectedTextStyle;




  TabEventItem(
      {super.key,
      required this.isSelected,
      required this.eventName,
      required this.eventIconPath,
      required this.backgroundSelectedColor,
      required this.borderUnSelectedColor,
      required this.selectedIconColor,
      required this.selectedTextStyle,
      required this.unSelectedTextStyle,
      required this.unSelectedIconColor});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.03,
        vertical: height * 0.005,
      ),
      margin: EdgeInsets.only(right: width * 0.03),
      decoration: BoxDecoration(
        color: isSelected ? backgroundSelectedColor : AppColors.transparentColor,
        borderRadius: BorderRadius.circular(46),
        border: Border.all(color: borderUnSelectedColor, width: 1),
      ),
      child: Row(
        children: [
          Image.asset(
            eventIconPath,
            height: 20,
            color: isSelected ? selectedIconColor : unSelectedIconColor,
          ),
          SizedBox(
            width: width * 0.02,
          ),
          Text(
            eventName,
            style: isSelected ? selectedTextStyle : unSelectedTextStyle,
          ),
        ],
      ),
    );
  }
}
