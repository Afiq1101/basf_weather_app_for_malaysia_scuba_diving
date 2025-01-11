
import 'dart:convert';

import 'package:basf_weather_app_for_malaysia_scuba_diving/models/ScubaSpotModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static const String recentScubaSpotKey = 'recent_scuba_spot';

  // Retrieve recent scuba spot
  Future<ScubaSpotModel?> getRecentScubaSpot() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? jsonString = prefs.getString(recentScubaSpotKey);
      if (jsonString != null) {
        Map<String, dynamic> json = jsonDecode(jsonString);
        return ScubaSpotModel.fromJson(json);
      }
      return null; // Return null if no data found
    } catch (e) {
      print("Error retrieving recent scuba spot: $e");
      return null; // Return null on error
    }
  }

  // Store scuba spot to SharedPreferences
  Future<void> storeRecentScubaSpot(ScubaSpotModel scubaSpot) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String jsonString = jsonEncode(scubaSpot.toJson());
      await prefs.setString(recentScubaSpotKey, jsonString);
    } catch (e) {
      print("Error storing recent scuba spot: $e");
    }
  }



  static String METRIC = 'METRIC';
  static String IMPERIAL = 'IMPERIAL';

  static String providerUnitSystemKey = 'unit_system';

  //store the preferred unit system
  Future<void> storeUnitSystem(String unitSystem) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(providerUnitSystemKey, unitSystem);
    } catch (e) {
      print("Error setting unit system: $e");
    }
  }

  //get the preferred unit system
  Future<String> getUnitSystem() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(providerUnitSystemKey) ?? METRIC;
    } catch (e) {
      print("Error retrieving unit system: $e");
      return METRIC;
    }
  }



}
