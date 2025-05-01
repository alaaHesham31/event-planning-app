import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_image.dart';
import 'package:evently_app/utils/app_style.dart';
import 'package:flutter/material.dart';

class EventItemWidget extends StatelessWidget {
  const EventItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryColor, width: 1),
        image: DecorationImage(
          image: AssetImage(AppImage.birthdayImage),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: height * 0.004, horizontal: width* 0.01),
            margin: EdgeInsets.symmetric(vertical: height * 0.01, horizontal: width* 0.02),
            decoration: BoxDecoration(
              color: AppColors.nodeWhiteColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  '21',
                  style: AppStyle.bold20Primary,
                ),
                Text(
                  'Nov',
                  style: AppStyle.bold20Primary,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: height * 0.01, horizontal: width* 0.02),
            margin: EdgeInsets.symmetric(vertical: height * 0.01, horizontal: width* 0.02),
            decoration: BoxDecoration(
              color: AppColors.nodeWhiteColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'This is a Birthday Party',
                  style: AppStyle.bold16Black,
                ),
                Icon(
                  Icons.favorite_border_rounded,
                  color: AppColors.primaryColor,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
