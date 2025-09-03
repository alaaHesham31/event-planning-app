import 'package:evently_app/providers/event_list_providers.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/ui/auth/login/login_navigator.dart';
import 'package:evently_app/ui/auth/login/login_screen_view_model.dart';
import 'package:evently_app/ui/auth/register/register_screen.dart';
import 'package:evently_app/ui/home_screen.dart';
import 'package:evently_app/ui/widgets/custom_elevated_button.dart';
import 'package:evently_app/ui/widgets/custom_text_field.dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_image.dart';
import 'package:evently_app/utils/app_style.dart';
import 'package:evently_app/utils/toast_msg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:evently_app/providers/auth_provider.dart' as myAuth;

class LoginScreen extends StatefulWidget {
  static const String routeName = 'loginScreen';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> implements LoginNavigator {
  LoginScreenViewModel viewModel = LoginScreenViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.navigator = this;
  }

  @override
  void dispose() {
    viewModel.emailController.dispose();
    viewModel.passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final authProvider = Provider.of<myAuth.AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.nodeWhiteColor,
      body: Padding(
        padding: EdgeInsets.only(
            top: height * 0.1, right: width * 0.04, left: width * 0.04),
        child: SingleChildScrollView(
          child: Column(
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
                        controller: viewModel.emailController,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return AppLocalizations.of(context)!.pleaseEnterEmail;
                          }
                          return null;
                        },
                        textStyle: AppStyle.semi16Grey,
                        hintText: AppLocalizations.of(context)!.email,
                        hintTextStyle: AppStyle.semi16Grey,
                        prefixIcon: Image.asset(AppImage.emailIcon),
                        borderColor: AppColors.greyColor),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    CustomTextField(
                      controller: viewModel.passwordController,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return AppLocalizations.of(context)!.pleaseEnterPassword;
                        }
                        return null;
                      },
                      obscureText: true,
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        AppLocalizations.of(context)!.forgotPassword,
                        style: AppStyle.boldItalic16Primary.copyWith(
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primaryColor),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    CustomElevatedButton(
                      onClick: authProvider.isLoading
                          ? null
                          : () => viewModel.login(
                                authProvider: Provider.of<myAuth.AuthProvider>(
                                    context,
                                    listen: false),
                                userProvider: Provider.of<UserProvider>(context,
                                    listen: false),
                                eventListProvider:
                                    Provider.of<EventListProvider>(context,
                                        listen: false),
                              ),
                      isLoading: authProvider.isLoading,
                      textStyle: AppStyle.semi20White,
                      text: AppLocalizations.of(context)!.login,
                      // isLoading: loginProvider.isLoading,
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
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
                onClick: () {
                  viewModel.loginWithGoogle(context);
                },
                textStyle: AppStyle.semi20Primary,
                text: AppLocalizations.of(context)!.loginWithGoogle,
                backgroundColor: AppColors.nodeWhiteColor,
                borderSide: AppColors.primaryColor,
                icon: Image.asset(AppImage.googleIcon),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  navigateToHome() {
    Navigator.pushReplacementNamed(context, HomeScreen.routeName);
  }

  @override
  showMsg(String message, Color color) {
    ToastMessage.toastMsg(message, color);
  }

  @override
  showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: color,
    ));
  }
}
