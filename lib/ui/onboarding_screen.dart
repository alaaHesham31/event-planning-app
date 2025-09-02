import 'package:evently_app/ui/auth/login/login_screen.dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_image.dart';
import 'package:evently_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class OnboardingScreen extends StatelessWidget {
  static const String routeName = 'onboardingScreen';

  OnboardingScreen({super.key});



  @override
  Widget build(BuildContext context) {
    List<PageViewModel> listPagesViewModel = [
      PageViewModel(
        title: AppLocalizations.of(context)!.onboardingTitle1,
        body: AppLocalizations.of(context)!.onboardingBody1,
        image: Center(child: Image.asset(AppImage.onBoarding1)),
        decoration: PageDecoration(
          titleTextStyle: AppStyle.bold20Primary,
          bodyTextStyle: AppStyle.semi16Black,
        ),
      ),
      PageViewModel(
        title: AppLocalizations.of(context)!.onboardingTitle2,
        body: AppLocalizations.of(context)!.onboardingBody2,
        image: Center(child: Image.asset(AppImage.onBoarding2)),
        decoration: PageDecoration(
          titleTextStyle: AppStyle.bold20Primary,
          bodyTextStyle: AppStyle.semi16Black,
        ),
      ),
      PageViewModel(
        title: AppLocalizations.of(context)!.onboardingTitle3,
        body: AppLocalizations.of(context)!.onboardingBody3,
        image: Center(child: Image.asset(AppImage.onBoarding3)),
        decoration: PageDecoration(
          titleTextStyle: AppStyle.bold20Primary,
          bodyTextStyle: AppStyle.semi16Black,
        ),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.nodeWhiteColor,
        centerTitle: true,
        title: Image(image: AssetImage(AppImage.eventlyHeader)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: IntroductionScreen(
                pages: listPagesViewModel,
                showSkipButton: false,
                showBackButton: true,
                back: builtArrowContainer(Icons.arrow_back),
                next: builtArrowContainer(Icons.arrow_forward),
                done: builtArrowContainer(Icons.arrow_forward),
                onDone: () {
                  Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                },
                dotsDecorator: DotsDecorator(
                  size: const Size.square(10.0),
                  activeSize: const Size(30.0, 10.0),
                  activeColor: AppColors.primaryColor,
                  color: AppColors.blackColor,
                  spacing: const EdgeInsets.symmetric(horizontal: 2.0),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget builtArrowContainer(IconData iconName) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.primaryColor),
      ),
      child: Icon(
        iconName,
        color: AppColors.primaryColor,
        size: 28,
      ),
    );
  }
}
