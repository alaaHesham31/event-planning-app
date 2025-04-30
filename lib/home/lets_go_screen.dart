import 'package:evently_app/home/onboarding_screen.dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_image.dart';
import 'package:evently_app/utils/app_style.dart';
import 'package:flutter/material.dart';

class LetsGoScreen extends StatelessWidget {
  static const String routeName = 'letsGoScreen';

  const LetsGoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.nodeWhiteColor,
        centerTitle: true,
        title: Image(image: AssetImage(AppImage.eventlyHeader)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(AppImage.letsGoImage),
            SizedBox(height: 30),
            Text(
              'Personalize Your Experience',
              style: AppStyle.bold20Primary,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              'Choose your preferred theme and language to get started with a comfortable, tailored experience that suits your style.',
              style: AppStyle.semi16Black,
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, OnboardingScreen.routeName);
                },
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: AppColors.primaryColor),
                child: Text(
                  'Let\'s Start',
                  style: AppStyle.semi20White,
                ))
          ],
        ),
      ),
    );
  }
}
