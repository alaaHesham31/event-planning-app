import 'package:evently_app/firebase_utils.dart';
import 'package:evently_app/model/user_model.dart';
import 'package:evently_app/ui/widgets/custom_elevated_button.dart';
import 'package:evently_app/ui/widgets/custom_text_field.dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_image.dart';
import 'package:evently_app/utils/app_style.dart';
import 'package:evently_app/utils/toast_msg.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'registerScreen';

  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    super.dispose();
  }

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
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: nameController,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please Enter Your name';
                        }
                        return null;
                      },
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
                        controller: emailController,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return 'Please enter your email';
                          }
                          // Basic email format check
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(text)) {
                            return 'Enter a valid email';
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
                      controller: passwordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
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
                      controller: rePasswordController,
                      obscureText: true,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Please Enter Your Password';
                        }
                        if (passwordController.text !=
                            rePasswordController.text) {
                          return 'the two passwords  doesn\'t match';
                        }
                        return null;
                      },
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
                      onClick: register, // Disable while loading
                      textStyle: AppStyle.semi20White,
                      text: AppLocalizations.of(context)!.createAccount,
                      isLoading: isLoading,
                    ),
                  ],
                ),
              ),
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

  bool isLoading = false;

  void register() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      MyUser user = MyUser(
          id: credential.user?.uid ?? '',
          name: nameController.text,
          email: emailController.text);

      await FirebaseUtils.addUserToFireStore(user);

      ToastMessage.toastMsg('Account created successfully');
      // Optionally navigate or reset form
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ToastMessage.toastMsg('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        ToastMessage.toastMsg('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        ToastMessage.toastMsg('The email address is not valid.');
      } else {
        ToastMessage.toastMsg('FirebaseAuth error: ${e.message}');
      }
    } catch (e) {
      ToastMessage.toastMsg('Unexpected error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
