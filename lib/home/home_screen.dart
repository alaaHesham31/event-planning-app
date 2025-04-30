import 'package:evently_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'homeScreen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(AppLocalizations.of(context)!.language, style: AppStyle.semi20White,),
      ),
    );
  }
}
