import 'package:geolocator/geolocator.dart';

class LocationUtils {
  static Future<Position> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return position;
  }

  static Future<bool> checkPermissions() async {
    // Check location permission
    LocationPermission locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
    }
    if (locationPermission == LocationPermission.denied ||
        locationPermission == LocationPermission.deniedForever) {
      return false;
    }
    if (!await Geolocator.isLocationServiceEnabled()) {
      return false;
    }
    return true;
  }
}
