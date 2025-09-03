import 'package:evently_app/manager/location_manager.dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTab extends StatefulWidget {
  const MapTab({super.key});

  @override
  State<MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  final CameraPosition _initialPosition = const CameraPosition(
    zoom: 10,
    target: LatLng(30.02, 31.14),
  );

  GoogleMapController? _mapController;

  Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId("initial"),
      position: LatLng(30.02, 31.14),
    )
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: FloatingActionButton(
          onPressed: () async {
            var location = await LocationManager.getCurrentLocation();
            _listenOnLocationChanged();

            // Update marker to current location
            setState(() {
              _markers = {
                Marker(
                  markerId: const MarkerId("current"),
                  position: LatLng(location.latitude, location.longitude),
                )
              };
            });

            if (_mapController != null) {
              _mapController!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(location.latitude, location.longitude),
                    zoom: 16,
                  ),
                ),
              );
            }
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          backgroundColor: AppColors.primaryColor,
          child: const Icon(
            Icons.my_location,
            color: AppColors.whiteColor,
            size: 32,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: GoogleMap(
        myLocationButtonEnabled: false,
        myLocationEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition: _initialPosition,
        markers: _markers,
        onMapCreated: (controller) {
          _mapController = controller;
        },
      ),
    );
  }

  _listenOnLocationChanged() {
    var stream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
      )
    );
    stream.listen((Position newLocation) {
      print('new location $newLocation');

      var newLatLng = LatLng(newLocation.latitude, newLocation.longitude);

      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: newLatLng,
            zoom: 16
          ),
        ),
      );
      _markers = {
        Marker(
          markerId: const MarkerId("current"),
          position: newLatLng,
        )
      };
      setState(() {});
    });
  }
}
