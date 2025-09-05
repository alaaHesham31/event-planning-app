import 'package:evently_app/providers/app_language_provider.dart';
import 'package:evently_app/providers/app_theme_provider.dart';
import 'package:evently_app/providers/event_list_providers.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/ui/auth/login/login_screen.dart';
import 'package:evently_app/ui/tabs/profile_tab/language_bottom_sheet.dart';
import 'package:evently_app/ui/tabs/profile_tab/theme_bottom_sheet.dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_style.dart';
import 'package:evently_app/utils/app_theme.dart';
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
    var userProvider = Provider.of<UserProvider>(context);
    var eventListProvider = Provider.of<EventListProvider>(context);
    var height = MediaQuery.of(context).size.height;
    var languageProvider = Provider.of<AppLanguageProvider>(context);
    var themeProvider = Provider.of<AppThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        toolbarHeight: height * 0.2,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(64))),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            // crossAxisAlignment:
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userProvider.currentUser!.name,
                    style: AppStyle.bold24White,
                  ),
                  Text(
                    userProvider.currentUser!.email,
                    style: AppStyle.semi16White,
                    overflow: TextOverflow.visible,
                    softWrap: true,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocalizations.of(context)!.language,
              style: Theme.of(context).textTheme.bodyMedium,
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
              style: Theme.of(context).textTheme.bodyMedium,
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
              child: ElevatedButton(
                onPressed: () {
                  // Clear all event-related data first
                  eventListProvider.clearCache();

                  Navigator.pushReplacementNamed(
                      context, LoginScreen.routeName);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: AppColors.redColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout,
                        color: AppColors.whiteColor,
                        size: 25,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(AppLocalizations.of(context)!.logout,
                          style: AppStyle.regular20White),
                    ],
                  ),
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
