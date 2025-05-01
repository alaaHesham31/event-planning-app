import 'package:evently_app/providers/app_language_provider.dart';
import 'package:evently_app/providers/app_theme_provider.dart';
import 'package:evently_app/ui/tabs/profile_tab/language_bottom_sheet.dart';
import 'package:evently_app/ui/tabs/profile_tab/theme_bottom_sheet.dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_style.dart';
import 'package:evently_app/utils/app_theme.dart';
import 'package:evently_app/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var languageProvider = Provider.of<AppLanguageProvider>(context);
    var themeProvider = Provider.of<AppThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          "Event app",
          style: AppStyle.semi20White,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocalizations.of(context)!.language,
              style: AppStyle.bold20Black,
            ),
            SizedBox(
              height: height * .02,
            ),
            InkWell(
              onTap: () {
                showLanguageBottomSheet();
              },
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      languageProvider.appLanguage == 'en'
                          ? AppLocalizations.of(context)!.english
                          : AppLocalizations.of(context)!.arabic,
                      style: AppStyle.bold20Primary,
                    ),
                    Icon(
                      Icons.arrow_drop_down_rounded,
                      size: 35,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * .02,
            ),
            Text(
              AppLocalizations.of(context)!.theme,
              style: AppStyle.bold20Black,
            ),
            SizedBox(
              height: height * .02,
            ),
            InkWell(
              onTap: () {
                showThemeBottomSheet();
              },
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      themeProvider.appTheme == AppTheme.lightTheme
                          ? AppLocalizations.of(context)!.light
                          : AppLocalizations.of(context)!.dark,
                      style: AppStyle.bold20Primary,
                    ),
                    Icon(
                      Icons.arrow_drop_down_rounded,
                      size: 35,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: CustomElevatedButton(
                text: AppLocalizations.of(context)!.logout,
                textStyle: AppStyle.regular20White,
                backgroundColor: AppColors.redColor,
                icon: Icon(
                  Icons.logout,
                  color: AppColors.whiteColor,
                  size: 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showLanguageBottomSheet() {
    showModalBottomSheet(
        context: context, builder: (context) => LanguageBottomSheet());
  }

  void showThemeBottomSheet() {
    showModalBottomSheet(
        context: context, builder: (context) => ThemeBottomSheet());
  }
}
