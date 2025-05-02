import 'package:evently_app/auth/regist/register_screen.dart';
import 'package:evently_app/ui/widgets/custom_elevated_button.dart';
import 'package:evently_app/ui/widgets/custom_text_field.dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_image.dart';
import 'package:evently_app/utils/app_style.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = 'loginScreen';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.nodeWhiteColor,
      body: Padding(
        padding: EdgeInsets.only(
            top: height * 0.05, right: width * 0.04, left: width * 0.04),
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
                suffixIcon: Image.asset(AppImage.viewIcon),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Text(
                AppLocalizations.of(context)!.forgotPassword,
                textAlign: TextAlign.end,
                style: AppStyle.boldItalic16Primary.copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primaryColor),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              CustomElevatedButton(
                  textStyle: AppStyle.semi20White,
                  text: AppLocalizations.of(context)!.login),
              SizedBox(
                height: height * 0.02,
              ),
              InkWell(
                onTap: (){
                  Navigator.pushNamed(context, RegisterScreen.routeName);
                },
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: AppLocalizations.of(context)!.doNotHaveAcc,
                        style: AppStyle.bold16Black,
                      ),
                      TextSpan(
                        text: AppLocalizations.of(context)!.createAccount,
                        style: AppStyle.boldItalic16Primary.copyWith(
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primaryColor),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      indent: 10,
                      endIndent: 20,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.or,
                    style: AppStyle.bold20Primary,
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      indent: 20,
                      endIndent: 10,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              CustomElevatedButton(
                  textStyle: AppStyle.semi20Primary,
                  text: AppLocalizations.of(context)!.loginWithGoogle,
                backgroundColor: AppColors.nodeWhiteColor,
                borderSide: AppColors.primaryColor,
                icon: Image.asset(AppImage.googleIcon),
              )
            ],
          ),
        ),
      ),
    );
  }
}
