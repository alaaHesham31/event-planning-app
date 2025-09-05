import 'package:evently_app/manager/location_manager.dart';
import 'package:evently_app/model/event_model.dart';
import 'package:evently_app/providers/event_list_providers.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTabViewModel extends ChangeNotifier {
  GoogleMapController? _mapController;
  String? _selectedEventId;

  String? get selectedEventId => _selectedEventId;

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
  }

  void loadEvents(EventListProvider eventListProvider, UserProvider userProvider, BuildContext context) {
    if (eventListProvider.allEventsList.isEmpty) {
      eventListProvider.loadEventCategories(context);
      eventListProvider.loadAllEvents(userProvider.currentUser!.id);
    }
  }

  void onEventSelected(EventModel event) {
    _selectedEventId = event.id;
    notifyListeners();

    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(event.location.latitude, event.location.longitude),
          zoom: 16,
        ),
      ),
    );
  }

  Future<void> moveToUserLocation() async {
    final location = await LocationManager.getCurrentLocation();
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(location.latitude, location.longitude),
          zoom: 16,
        ),
      ),
    );
  }
}
