import 'package:location/location.dart' as loc;

class CurrentLocationService {

  Future<loc.LocationData?> getCurrentLocation() async {
    try{
    loc.Location location = loc.Location();

    // check if location service is enabled
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null; // location services denied
      }
    }

    // check & get location permissions
    loc.PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return null; // didn't get permissions
      }
    }

    // Return Current Location
    return await location.getLocation();
    }catch(e){
      print("Error: [CurrentLocationService.getCurrentLocation] Failed to get current location");
      return null;
    }
  }

}
