import 'package:location/location.dart' as loc;

class CurrentLocationService {

  Future<loc.LocationData?> getCurrentLocation() async {
    loc.Location location = loc.Location();

    // Checking if location service is enabled
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null; // Location services denied
      }
    }

    // Check & Get location permissions
    loc.PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return null; // Didn't get permissions
      }
    }

    // Return Current Location
    return await location.getLocation();
  }




}
