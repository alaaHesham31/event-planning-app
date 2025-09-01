import 'package:evently_app/model/user_model.dart';
import 'package:evently_app/ui/auth/register/register_navigator.dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/firebase_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class RegisterScreenViewModel extends ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();

  late RegisterNavigator navigator;

  void register() async {
    if (!formKey.currentState!.validate()) return;

      isLoading = true;
    notifyListeners();


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
      navigator.showMsg('Account created successfully',  AppColors.greenColor);
      // Optionally navigate or reset form
      navigator.navigateToHome();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        navigator.showMsg('The password provided is too weak.',  AppColors.greyColor);
      } else if (e.code == 'email-already-in-use') {
        navigator.showMsg('The account already exists for that email.',  AppColors.redColor);
      } else if (e.code == 'invalid-email') {
        navigator.showMsg('The email address is not valid.',  AppColors.redColor);
      } else {
        navigator.showMsg('FirebaseAuth error: ${e.message}',  AppColors.redColor);
      }
    } catch (e) {
      navigator.showMsg('Unexpected error: $e',  AppColors.redColor);
    } finally {
        isLoading = false;
        notifyListeners();

    }
  }
}
