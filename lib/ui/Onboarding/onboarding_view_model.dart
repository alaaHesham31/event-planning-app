import 'package:evently_app/providers/app_theme_provider.dart';
import 'package:evently_app/ui/auth/login/login_screen.dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_image.dart';
import 'package:evently_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingViewModel {
  final AppThemeProvider themeProvider;

  OnboardingViewModel(this.themeProvider);

  List<PageViewModel> getPages(BuildContext context) {
    return [
      PageViewModel(
        titleWidget: Text(
          AppLocalizations.of(context)!.onboardingTitle1,
          style: AppStyle.bold20Primary,
          textAlign: TextAlign.start,
        ),
        bodyWidget: Text(
          AppLocalizations.of(context)!.onboardingBody1,
          style: Theme.of(context).textTheme.bodyMedium!,
          textAlign: TextAlign.start,
        ),
        image: Center(child: Image.asset(AppImage.onBoarding1)),
      ),
      PageViewModel(
        titleWidget: Text(
          AppLocalizations.of(context)!.onboardingTitle2,
          style: AppStyle.bold20Primary,
          textAlign: TextAlign.start,
        ),
        bodyWidget: Text(
          AppLocalizations.of(context)!.onboardingBody2,
          style: Theme.of(context).textTheme.bodyMedium!,
          textAlign: TextAlign.start,
        ),
        image: Center(child: Image.asset(AppImage.onBoarding2)),
      ),
      PageViewModel(
        titleWidget: Text(
          AppLocalizations.of(context)!.onboardingTitle3,
          style: AppStyle.bold20Primary,
          textAlign: TextAlign.start,
        ),
        bodyWidget: Text(
          AppLocalizations.of(context)!.onboardingBody3,
          style: Theme.of(context).textTheme.bodyMedium!,
          textAlign: TextAlign.start,
        ),
        image: Center(child: Image.asset(AppImage.onBoarding3)),
      ),
    ];
  }

  DotsDecorator getDotsDecorator() {
    return DotsDecorator(
      size: const Size.square(10.0),
      activeSize: const Size(30.0, 10.0),
      activeColor: AppColors.primaryColor,
      color: themeProvider.isLightTheme()
          ? AppColors.blackColor
          : AppColors.whiteColor,
      spacing: const EdgeInsets.symmetric(horizontal: 2.0),
      activeShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    );
  }

  void onDone(BuildContext context) {
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }
}
