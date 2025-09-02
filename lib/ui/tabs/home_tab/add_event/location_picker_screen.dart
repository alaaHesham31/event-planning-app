import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Pick Event Location", style: AppStyle.semi20White,),
          centerTitle: true,
          backgroundColor: AppColors.primaryColor,
          iconTheme: IconThemeData(
            color: AppColors.whiteColor
          ),
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
              myLocationEnabled: false, // show user's location
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
                    backgroundColor: AppColors.primaryColor,
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
