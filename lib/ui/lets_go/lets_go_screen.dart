import 'package:evently_app/ui/Onboarding/onboarding_screen.dart';
import 'package:evently_app/ui/lets_go/settings_toggles.dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_image.dart';
import 'package:evently_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LetsGoScreen extends StatelessWidget {
  static const String routeName = 'letsGoScreen';

  const LetsGoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Image(image: AssetImage(AppImage.eventlyHeader)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(AppImage.letsGoImage),
              SizedBox(height: 30),
              Text(
                AppLocalizations.of(context)!.personalizeExperience,
                style: AppStyle.bold20Primary,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                AppLocalizations.of(context)!.onboardingDescription,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              const SettingsToggles(),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, OnboardingScreen.routeName);
                },
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: AppColors.primaryColor),
                child: Text(
                  AppLocalizations.of(context)!.letsStart,
                  style: AppStyle.semi20White,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
