import 'package:evently_app/manager/location_manager.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/ui/tabs/home_tab/home_navigator.dart';
import 'package:evently_app/utils/firebase_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HomeTabViewModel {
  late HomeNavigator navigator;


  Future<void> onLocationClicked(BuildContext context) async {
    final result = await navigator.showLocationDialog();

    if (result == true) {
      try {
        // Ask for permission + get location
        await LocationManager.getCurrentLocation();

        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final currentUser = userProvider.currentUser;

        if (currentUser != null) {
          // Update in Firestore
          await FirebaseUtils.updateUserLocation(
            currentUser.id,
            LocationManager.countryName ?? '',
            LocationManager.cityName ?? '',
          );

          // Update provider
          final updatedUser = currentUser.copyWith(
            country: LocationManager.countryName ?? '',
            city: LocationManager.cityName ?? '',
          );
          userProvider.updateUser(updatedUser);
        }
      } catch (e) {
        navigator.showSnackBar("Failed to get location: $e", Colors.red);
      }
    }
  }
}
