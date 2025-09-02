
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationManager {
  static String? countryName;
  static String? cityName;



  static Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      var result = await Geolocator.openLocationSettings();

      return Future.error('Location services are disabled.');
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    var userLocation = await Geolocator.getCurrentPosition();
    List<Placemark> placemarks = await placemarkFromCoordinates(
        userLocation.latitude, userLocation.longitude);
    if (placemarks.isNotEmpty) {
      countryName = placemarks[0].country;
      cityName = placemarks[0].subAdministrativeArea;
      print(" ==== street :${placemarks[0].street.toString()}");
      print(" ==== street :${placemarks[0].country.toString()}");
      print(" ==== street :${placemarks[0].subLocality.toString()}");
      print(" ==== street :${placemarks[0].locality.toString()}");
      print(" ==== street :${placemarks[0].subAdministrativeArea.toString()}");
    }
    print(userLocation.toString());
    return userLocation;
  }

  trackUserLocation() {}
}
