import 'package:evently_app/providers/app_theme_provider.dart';
import 'package:evently_app/ui/Onboarding/onboarding_view_model.dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_image.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatelessWidget {
  static const String routeName = 'onboardingScreen';

  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<AppThemeProvider>(context, listen: false);
    final viewModel = OnboardingViewModel(themeProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Image(image: AssetImage(AppImage.eventlyHeader)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: IntroductionScreen(
            pages: viewModel.getPages(context),
            showSkipButton: false,
            showBackButton: true,
            back: _buildArrowContainer(Icons.arrow_back),
            next: _buildArrowContainer(Icons.arrow_forward),
            done: _buildArrowContainer(Icons.arrow_forward),
            onDone: () => viewModel.onDone(context),
            dotsDecorator: viewModel.getDotsDecorator(),
          ),
        ),
      ),
    );
  }

  Widget _buildArrowContainer(IconData iconName) {
    return Container(
      padding: const EdgeInsets.all(8),
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
