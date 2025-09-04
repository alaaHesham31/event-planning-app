import 'package:evently_app/providers/app_theme_provider.dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class LocationPickerScreen extends StatefulWidget {
  static const String routeName = 'location-picker-screen';

  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  LatLng? selectedLocation;
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<AppThemeProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Pick Event Location",
            style: themeProvider.isLightTheme()
                ? AppStyle.semi20White
                : AppStyle.semi20Primary,
          ),
          backgroundColor: themeProvider.isLightTheme()
              ? AppColors.primaryColor
              : AppColors.navyColor,
          centerTitle: true,
        ),
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: LatLng(30.12, 31.2), zoom: 10),
              onMapCreated: (controller) => mapController = controller,
              markers: selectedLocation == null
                  ? {}
                  : {
                      Marker(
                        markerId: MarkerId("selected"),
                        position: selectedLocation!,
                      ),
                    },
              onTap: (LatLng pos) {
                setState(() {
                  selectedLocation = pos;
                });
              },
              myLocationEnabled: false,
              // show user's location
              myLocationButtonEnabled: false,
            ),

            // Confirm button (bottom)
            if (selectedLocation != null)
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeProvider.isLightTheme()
                        ? AppColors.primaryColor
                        : AppColors.navyColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pop(context, selectedLocation);
                  },
                  child: Text(
                    "Confirm Location",
                    style: AppStyle.semi20White,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
