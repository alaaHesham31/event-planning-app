import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_style.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.nodeWhiteColor,
    appBarTheme: AppBarTheme(
        backgroundColor: AppColors.nodeWhiteColor,
      iconTheme: IconThemeData(
          color: AppColors.whiteColor
      ),
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black, // Light theme color
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.primaryColor,
      showUnselectedLabels: true,
      selectedLabelStyle: AppStyle.bold14White,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryColor,
      shape: StadiumBorder(
        side: BorderSide(color: AppColors.whiteColor, width: 4),
      ),
    ),
  );


  static final ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.navyColor,
    scaffoldBackgroundColor: AppColors.navyColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.navyColor,
      iconTheme: IconThemeData(
        color: AppColors.primaryColor
      ),
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white, // Dark theme color
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.navyColor,
      showUnselectedLabels: true,
      selectedLabelStyle: AppStyle.bold14White,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.navyColor,
      shape: StadiumBorder(
        side: BorderSide(color: AppColors.whiteColor, width: 4),
      ),
    ),
  );
}
