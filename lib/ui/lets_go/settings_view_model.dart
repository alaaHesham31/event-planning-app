import 'package:evently_app/providers/app_language_provider.dart';
import 'package:evently_app/providers/app_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsViewModel extends ChangeNotifier {
  final AppLanguageProvider languageProvider;
  final AppThemeProvider themeProvider;

  SettingsViewModel({
    required this.languageProvider,
    required this.themeProvider,
  });

  /// Factory helper to build from context directly
  factory SettingsViewModel.of(BuildContext context) {
    return SettingsViewModel(
      languageProvider: context.read<AppLanguageProvider>(),
      themeProvider: context.read<AppThemeProvider>(),
    );
  }

  // Proxy getters
  String get currentLanguage => languageProvider.appLanguage;

  ThemeData get currentTheme => themeProvider.appTheme;

  // Proxy actions
  void changeLanguage(String newLang) {
    languageProvider.changeAppLanguage(newLang);
    notifyListeners();
  }

  void changeTheme(ThemeData newTheme) {
    themeProvider.changeAppTheme(newTheme);
    notifyListeners();
  }
}
