import 'package:evently_app/ui/lets_go/settings_view_model.dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SettingsToggles extends StatelessWidget {
  const SettingsToggles({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = Provider.of<SettingsViewModel>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Language Toggle
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.language,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            ToggleButtons(
              borderRadius: BorderRadius.circular(16),
              isSelected: [
                viewModel.currentLanguage == 'en',
                viewModel.currentLanguage == 'ar',
              ],
              onPressed: (index) {
                viewModel.changeLanguage(index == 0 ? 'en' : 'ar');
              },
              fillColor: AppColors.primaryColor,
              selectedColor: AppColors.whiteColor,
              color: AppColors.primaryColor,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text("EN", style: TextStyle(fontSize: 16)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text("AR", style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Theme Toggle
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.theme,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            ToggleButtons(
              borderRadius: BorderRadius.circular(16),
              isSelected: [
                viewModel.currentTheme == AppTheme.lightTheme,
                viewModel.currentTheme == AppTheme.darkTheme,
              ],
              onPressed: (index) {
                viewModel.changeTheme(
                    index == 0 ? AppTheme.lightTheme : AppTheme.darkTheme);
              },
              fillColor: AppColors.primaryColor,
              selectedColor: AppColors.whiteColor,
              color: AppColors.primaryColor,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(Icons.wb_sunny_outlined),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(Icons.nights_stay_outlined),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
