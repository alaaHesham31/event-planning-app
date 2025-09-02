import 'dart:async';
import 'package:evently_app/ui/lets_go_screen.dart';
import 'package:flutter/material.dart';

import '../utils/app_image.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName ='/';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, LetsGoScreen.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(AppImage.eventlyLogo),
      ),
    );
  }
}
