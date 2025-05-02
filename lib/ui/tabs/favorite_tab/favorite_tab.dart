import 'package:evently_app/ui/widgets/custom_text_field.dart';
import 'package:evently_app/ui/widgets/event_item_widget.dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_image.dart';
import 'package:evently_app/utils/app_style.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class FavoriteTab extends StatelessWidget {
  const FavoriteTab({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
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
              prefixIcon: Image.asset(
                AppImage.searchIcon,
                color: null,
              ),
            ),
            SizedBox(height: height * 0.02,),
            Expanded(
                child: ListView.separated(
                    itemCount: 10,
                    separatorBuilder: (context, index){
                      return   SizedBox(
                        height: height * 0.02,
                      );
                    },
                    itemBuilder: (context, index) {
                      return EventItemWidget();
                    })),

          ],
        ),
      ),
    );
  }
}
