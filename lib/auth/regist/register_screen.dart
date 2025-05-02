import 'package:evently_app/ui/widgets/custom_elevated_button.dart';
import 'package:evently_app/ui/widgets/custom_text_field.dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_image.dart';
import 'package:evently_app/utils/app_style.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterScreen extends StatelessWidget {
  static const String routeName = 'registerScreen';

  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.nodeWhiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.nodeWhiteColor,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.register,
          style: AppStyle.semi16Black,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        child: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(AppImage.eventlyLogo),
              SizedBox(
                height: height * 0.02,
              ),
              CustomTextField(
                textStyle: AppStyle.semi16Grey,
                hintText: AppLocalizations.of(context)!.name,
                hintTextStyle: AppStyle.semi16Grey,
                prefixIcon: Image.asset(AppImage.emailIcon),
                borderColor: AppColors.greyColor,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              CustomTextField(
                  textStyle: AppStyle.semi16Grey,
                  hintText: AppLocalizations.of(context)!.email,
                  hintTextStyle: AppStyle.semi16Grey,
                  prefixIcon: Image.asset(AppImage.emailIcon),
                  borderColor: AppColors.greyColor),
              SizedBox(
                height: height * 0.02,
              ),
              CustomTextField(
                textStyle: AppStyle.semi16Grey,
                hintText: AppLocalizations.of(context)!.password,
                hintTextStyle: AppStyle.semi16Grey,
                borderColor: AppColors.greyColor,
                prefixIcon: Image.asset(AppImage.passwordIcon),
                suffixIcon: Image.asset(
                  AppImage.viewIcon,
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              CustomTextField(
                textStyle: AppStyle.semi16Grey,
                hintText: AppLocalizations.of(context)!.rePassword,
                hintTextStyle: AppStyle.semi16Grey,
                borderColor: AppColors.greyColor,
                prefixIcon: Image.asset(AppImage.passwordIcon),
                suffixIcon: Image.asset(AppImage.viewIcon),
              ),
          
              SizedBox(
                height: height * 0.02,
              ),
              CustomElevatedButton(
                  textStyle: AppStyle.semi20White,
                  text: AppLocalizations.of(context)!.createAccount),
              SizedBox(
                height: height * 0.02,
              ),
              InkWell(
                onTap: () {},
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: AppLocalizations.of(context)!.alreadyHaveAccount,
                        style: AppStyle.bold16Black,
                      ),
                      TextSpan(
                        text: AppLocalizations.of(context)!.login,
                        style: AppStyle.boldItalic16Primary.copyWith(
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primaryColor),
                      ),
                    ],
                  ),
                ),
              ),
          
            ],
          ),
        ),
      ),
    );
  }
}
