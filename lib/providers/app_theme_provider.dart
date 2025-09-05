import 'package:evently_app/utils/app_theme.dart';
import 'package:flutter/material.dart';

class AppThemeProvider extends ChangeNotifier {
  ThemeData appTheme = AppTheme.lightTheme;

  void changeAppTheme(ThemeData newTheme) {
    if (appTheme == newTheme) return;
    appTheme = newTheme;
    notifyListeners();
  }

  bool isLightTheme() {
    return appTheme == AppTheme.lightTheme;
  }
}
