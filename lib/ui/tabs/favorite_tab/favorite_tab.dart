import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_image.dart';
import 'package:evently_app/utils/app_style.dart';
import 'package:evently_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class FavoriteTab extends StatelessWidget {
  const FavoriteTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              textStyle: AppStyle.bold14Primary,
              hintText: AppLocalizations.of(context)!.searchForEvent,
              hintTextStyle: AppStyle.bold14Primary,
              borderColor: AppColors.primaryColor,
              iconName: Image.asset(
                AppImage.searchIcon,
                color: null,
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
