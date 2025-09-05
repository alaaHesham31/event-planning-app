import 'package:evently_app/providers/app_theme_provider.dart';
import 'package:evently_app/ui/auth/login/login_screen.dart';
import 'package:evently_app/ui/auth/register/register_navigator.dart';
import 'package:evently_app/ui/auth/register/register_screen_view_model.dart';
import 'package:evently_app/ui/widgets/custom_elevated_button.dart';
import 'package:evently_app/ui/widgets/custom_text_field.dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_image.dart';
import 'package:evently_app/utils/app_style.dart';
import 'package:evently_app/utils/toast_msg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'registerScreen';

  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    implements RegisterNavigator {
  RegisterScreenViewModel viewModel = RegisterScreenViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.navigator = this;
  }

  @override
  void dispose() {
    viewModel.nameController.dispose();
    viewModel.emailController.dispose();
    viewModel.passwordController.dispose();
    viewModel.rePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final appThemeProvider =
        Provider.of<AppThemeProvider>(context, listen: false);

    return ChangeNotifierProvider(
      create: (context) => viewModel,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.register,
            style: Theme.of(context).textTheme.bodyMedium,
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
                Form(
                  key: viewModel.formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: viewModel.nameController,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Please Enter Your name';
                          }
                          return null;
                        },
                        textStyle: appThemeProvider.isLightTheme()
                            ? AppStyle.semi16Grey
                            : AppStyle.semi16White,
                        hintText: AppLocalizations.of(context)!.name,
                        hintTextStyle: appThemeProvider.isLightTheme()
                            ? AppStyle.semi16Grey
                            : AppStyle.semi16White,
                        prefixIcon: Icon(Icons.person),
                        prefixIconColor: appThemeProvider.isLightTheme()
                            ? AppColors.greyColor
                            : AppColors.whiteColor,
                        borderColor: appThemeProvider.isLightTheme()
                            ? AppColors.greyColor
                            : AppColors.whiteColor,
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      CustomTextField(
                        controller: viewModel.emailController,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return AppLocalizations.of(context)!
                                .pleaseEnterEmail;
                          }
                          // Basic email format check
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(text)) {
                            return AppLocalizations.of(context)!.invalidEmail;
                          }
                          return null;
                        },
                        textStyle: appThemeProvider.isLightTheme()
                            ? AppStyle.semi16Grey
                            : AppStyle.semi16White,
                        hintText: AppLocalizations.of(context)!.email,
                        hintTextStyle: appThemeProvider.isLightTheme()
                            ? AppStyle.semi16Grey
                            : AppStyle.semi16White,
                        prefixIcon: Icon(Icons.email_rounded),
                        prefixIconColor: appThemeProvider.isLightTheme()
                            ? AppColors.greyColor
                            : AppColors.whiteColor,
                        borderColor: appThemeProvider.isLightTheme()
                            ? AppColors.greyColor
                            : AppColors.whiteColor,
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      CustomTextField(
                        controller: viewModel.passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .pleaseEnterPassword;
                          }
                          if (value.length < 6) {
                            return AppLocalizations.of(context)!
                                .passwordTooShort;
                          }
                          return null;
                        },
                        textStyle: appThemeProvider.isLightTheme()
                            ? AppStyle.semi16Grey
                            : AppStyle.semi16White,
                        hintText: AppLocalizations.of(context)!.password,
                        hintTextStyle: appThemeProvider.isLightTheme()
                            ? AppStyle.semi16Grey
                            : AppStyle.semi16White,
                        borderColor: appThemeProvider.isLightTheme()
                            ? AppColors.greyColor
                            : AppColors.whiteColor,
                        prefixIcon: Icon(Icons.lock_rounded),
                        prefixIconColor: appThemeProvider.isLightTheme()
                            ? AppColors.greyColor
                            : AppColors.whiteColor,
                        suffixIcon: Icon(Icons.visibility_off_rounded),
                        suffixIconColor: appThemeProvider.isLightTheme()
                            ? AppColors.greyColor
                            : AppColors.whiteColor,
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      CustomTextField(
                        controller: viewModel.rePasswordController,
                        obscureText: true,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return AppLocalizations.of(context)!
                                .pleaseEnterPassword;
                          }
                          if (viewModel.passwordController.text !=
                              viewModel.rePasswordController.text) {
                            return AppLocalizations.of(context)!
                                .passwordsDoNotMatch;
                          }
                          return null;
                        },
                        textStyle: appThemeProvider.isLightTheme()
                            ? AppStyle.semi16Grey
                            : AppStyle.semi16White,
                        hintText: AppLocalizations.of(context)!.rePassword,
                        hintTextStyle: appThemeProvider.isLightTheme()
                            ? AppStyle.semi16Grey
                            : AppStyle.semi16White,
                        borderColor: appThemeProvider.isLightTheme()
                            ? AppColors.greyColor
                            : AppColors.whiteColor,
                        prefixIcon: Icon(Icons.lock_rounded),
                        prefixIconColor: appThemeProvider.isLightTheme()
                            ? AppColors.greyColor
                            : AppColors.whiteColor,
                        suffixIcon: Icon(Icons.visibility_off_rounded),
                        suffixIconColor: appThemeProvider.isLightTheme()
                            ? AppColors.greyColor
                            : AppColors.whiteColor,
                      ),
                      SizedBox(
                        height: height * 0.08,
                      ),
                      CustomElevatedButton(
                        onClick: viewModel.register, // Disable while loading
                        textStyle: AppStyle.semi20White,
                        text: AppLocalizations.of(context)!.createAccount,
                        isLoading: viewModel.isLoading,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, LoginScreen.routeName);
                  },
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text:
                              AppLocalizations.of(context)!.alreadyHaveAccount,
                          style: Theme.of(context).textTheme.bodyMedium,
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
      ),
    );
  }

  @override
  navigateToHome() {
    Navigator.pop(context);
  }

  @override
  showMsg(String message, Color color) {
    ToastMessage.toastMsg(message, color);
  }
}
