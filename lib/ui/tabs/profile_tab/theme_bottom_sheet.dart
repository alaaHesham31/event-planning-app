import 'package:evently_app/providers/app_theme_provider.dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_style.dart';
import 'package:evently_app/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ThemeBottomSheet extends StatefulWidget {
  const ThemeBottomSheet({super.key});

  @override
  State<ThemeBottomSheet> createState() => _ThemeBottomSheet();
}

class _ThemeBottomSheet extends State<ThemeBottomSheet> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var themeProvider = Provider.of<AppThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: height * 0.15,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
                onTap: () {
                  themeProvider.changeAppTheme(AppTheme.darkTheme);
                },
                child: themeProvider.appTheme == AppTheme.darkTheme
                    ? getSelectedItemWidget(
                        AppLocalizations.of(context)!.dark)
                    : getUnSelectedItemWidget(
                        AppLocalizations.of(context)!.dark)),
            SizedBox(
              height: height * .02,
            ),
            InkWell(
              onTap: () {
                themeProvider.changeAppTheme(AppTheme.lightTheme);
              },
              child: themeProvider.appTheme == AppTheme.lightTheme
                  ? getSelectedItemWidget(AppLocalizations.of(context)!.light)
                  : getUnSelectedItemWidget(
                      AppLocalizations.of(context)!.light),
            ),
          ],
        ),
      ),
    );
  }

  Widget getSelectedItemWidget(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: AppStyle.bold20Primary,
        ),
        Icon(
          Icons.check,
          color: AppColors.primaryColor,
        )
      ],
    );
  }

  Widget getUnSelectedItemWidget(String text) {
    return Text(
      text,
      style: AppStyle.bold20Black,
    );
  }
}
