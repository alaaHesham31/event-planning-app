import 'package:evently_app/manager/location_manager.dart';
import 'package:evently_app/model/event_model.dart';
import 'package:evently_app/providers/event_list_providers.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/ui/tabs/home_tab/event_details_screen.dart';
import 'package:evently_app/utils/app_colors.dart';
import 'package:evently_app/utils/app_image.dart';
import 'package:evently_app/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

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
    var eventListProvider = Provider.of<EventListProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);

    if (eventListProvider.allEventsList.isEmpty) {
      eventListProvider.loadEventCategories(context);
      eventListProvider.loadAllEvents(userProvider.currentUser!.id);
    }

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            myLocationEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: _initialPosition,
            markers: _buildMarkers(eventListProvider),
            onMapCreated: (controller) {
              _mapController = controller;
            },
          ),
          Positioned(
            bottom: 32,
            left: 24,
            right: 0,
            child: SizedBox(
              height: 110,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: eventListProvider.allEventsList.length,
                separatorBuilder: (context, index) => SizedBox(
                  width: 12,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          EventDetailsScreen.routeName,
                          arguments: eventListProvider.allEventsList[index]);
                    },
                    child: _buildEventItem(
                        event: eventListProvider.allEventsList[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
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
    );
  }

  _listenOnLocationChanged() {
    var stream =
        Geolocator.getPositionStream(locationSettings: LocationSettings());
    stream.listen((Position newLocation) {
      print('new location $newLocation');

      var newLatLng = LatLng(newLocation.latitude, newLocation.longitude);

      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: newLatLng, zoom: 16),
        ),
      );
      _markers = {
        Marker(
          markerId: const MarkerId("current"),
          position: newLatLng,
        ),
      };
      setState(() {});
    });
  }

  Set<Marker> _buildMarkers(EventListProvider eventListProvider) {
    final eventMarkers = eventListProvider.allEventsList.map((event) {
      return Marker(
        markerId: MarkerId("event${event.id}"),
        position: LatLng(
          event.location.latitude,
          event.location.longitude,
        ),
        infoWindow: InfoWindow(
          title: event.title,
          snippet: "${event.city}, ${event.country}",
          onTap: () {
            Navigator.of(context).pushNamed(
              EventDetailsScreen.routeName,
              arguments: event,
            );
          },
        ),
      );
    }).toSet();

    LatLng _currentLocation = LatLng(30.02, 31.14);
    // Add current location marker if available
    if (_currentLocation != null) {
      eventMarkers.add(
        Marker(
          markerId: const MarkerId("current"),
          position: _currentLocation!,
        ),
      );
    }

    return eventMarkers;
  }


  _buildEventItem({required EventModel event}) {

    return Container(
      height: 100,
      width: 300,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.nodeWhiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryColor, width: 2),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image(
              image: AssetImage(event.image),
            ),
          ),
          SizedBox(
            width: 4,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: AppStyle.bold16Primary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Image.asset(
                      AppImage.mapIcon,
                      color: AppColors.blackColor,
                      height: 20,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: Text(
                        '${event.city} , ${event.country}',
                        style: AppStyle.semi14Black,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
