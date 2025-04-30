import 'package:evently_app/home/home_screen.dart';
import 'package:evently_app/home/lets_go_screen.dart';
import 'package:evently_app/home/onboarding_screen.dart';
import 'package:evently_app/splash_screen.dart';
import 'package:evently_app/utils/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        LetsGoScreen.routeName: (context) => LetsGoScreen(),
        OnboardingScreen.routeName: (context) => OnboardingScreen(),
        HomeScreen.routeName: (context) => HomeScreen()
      },
      theme: AppTheme.lightTheme,
    );
  }
}
