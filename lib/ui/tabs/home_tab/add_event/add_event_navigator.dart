import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class AddEventNavigator {
  void showToastMsg(String message, Color color);

  Future<LatLng?> pickLocation(BuildContext context);

  void closeScreen();
}
