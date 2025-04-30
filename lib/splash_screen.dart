import 'dart:async';

import 'package:evently_app/utils/app_colors.dart';
import 'package:flutter/material.dart';

import 'utils/app_image.dart';

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
      Navigator.pushReplacementNamed(context, 'letsGoScreen');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.nodeWhiteColor,
      body: Center(
        child: Image.asset(AppImage.eventlyLogo),
      ),
    );
  }
}
