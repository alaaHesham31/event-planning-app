import 'package:evently_app/model/user_model.dart';
import 'package:evently_app/providers/event_list_providers.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/ui/auth/login/login_navigator.dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/firebase_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:evently_app/providers/auth_provider.dart' as myAuth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class LoginScreenViewModel extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late UserProvider userProvider;
  late EventListProvider eventListProvider;
  late LoginNavigator navigator;

  void login({
    required myAuth.AuthProvider authProvider,
    required UserProvider userProvider,
    required EventListProvider eventListProvider,
  }) async {
    if (!formKey.currentState!.validate()) return;

    authProvider.setLoading(true);

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final uid = credential.user?.uid;

      if (uid == null || uid.isEmpty) {
        navigator.showMsg('Login failed: Invalid user ID.', AppColors.redColor);
        return;
      }

      final user = await FirebaseUtils.getUserById(uid);

      if (user == null) {
        navigator.showMsg(
            'No Firestore profile found for this user.', AppColors.redColor);
        return;
      }

      userProvider.updateUser(user);
      navigator.showMsg('Login successful', AppColors.greenColor);
      // final token = await NotificationManager.getDeviceToken();
      // if (token != null) {
      //   print("=======$token");
      //   await FirebaseUtils.saveDeviceToken(userProvider.currentUser!.id, token);
      // }

      navigator.navigateToHome();

      // Update selected index after login success
      eventListProvider.changeSelectedIndex(0, userProvider.currentUser!.id);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        navigator.showMsg('No user found for that email.', AppColors.redColor);
      } else if (e.code == 'wrong-password') {
        navigator.showMsg('Wrong password provided.', AppColors.redColor);
      } else {
        navigator.showMsg(
            'FirebaseAuth error: ${e.message}', AppColors.redColor);
        print('FirebaseAuth error: ${e.message}');
      }
    } catch (e) {
      navigator.showMsg('Unexpected error: $e', AppColors.redColor);
      print('Unexpected error: $e');
    } finally {
      authProvider.setLoading(false);
    }
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    try {
      await _googleSignIn.signOut();
      // Start the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in
        navigator.showSnackBar(
          "Google sign-in cancelled",
          AppColors.redColor,
        );
        return;
      }

      // Get Google authentication tokens
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final user = userCredential.user;

      if (user == null) {
        navigator.showSnackBar(
          "Google sign-in failed",
          AppColors.redColor,
        );

        return;
      }

      //  Check if user exists in Firestore
      final existingUser = await FirebaseUtils.getUserById(user.uid);

      if (existingUser == null) {
        // Create new Firestore user
        final myUser = MyUser(
          id: user.uid,
          name: user.displayName ?? "No Name",
          email: user.email ?? "",
        );

        await FirebaseUtils.addUser(myUser);
      }

      // 👤 Update provider (if you’re using it)
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final myUserFromDb = await FirebaseUtils.getUserById(user.uid);
      if (myUserFromDb != null) {
        userProvider.updateUser(myUserFromDb);
      }
      navigator.navigateToHome();
    } catch (e) {
      print("Google Sign-In error: $e");
      navigator.showSnackBar(
        "Error during Google Sign-In: $e",
        AppColors.redColor,
      );
    }
  }
}
