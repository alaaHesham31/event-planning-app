import 'package:flutter/material.dart';

abstract class HomeNavigator {
  Future<bool?> showLocationDialog();
  void showSnackBar(String message, Color color);
}