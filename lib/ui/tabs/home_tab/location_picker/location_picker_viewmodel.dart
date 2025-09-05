import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerViewModel extends ChangeNotifier {
  LatLng? selectedLocation;
  GoogleMapController? mapController;

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void selectLocation(LatLng pos) {
    selectedLocation = pos;
    notifyListeners();
  }

  bool get hasLocationSelected => selectedLocation != null;
}
