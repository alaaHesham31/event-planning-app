import 'package:flutter/material.dart';

abstract class LoginNavigator {
  showMsg(String message, Color color);

  showSnackBar(String message, Color color);

  navigateToHome();
}
