

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:basf_weather_app_for_malaysia_scuba_diving/models/ScubaSpotModel.dart';

class JsonStoreService {
  static const String storedScubaSpotsFileName = 'scuba_spots.json';

  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$storedScubaSpotsFileName';
  }

  // get stored scuba spots from scuba_spots.json
  Future<List<ScubaSpotModel>> getStoredScubaSpots() async {
    try {
      final path = await _getFilePath();
      final file = File(path);

      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList.map((jsonItem) => ScubaSpotModel.fromJson(jsonItem)).toList();
      }

      return [];
    } catch (e) {
      print("Error reading stored scuba spots: $e");
      return [];
    }
  }

  // store scuba spot into scuba_spots.json
  Future<void> storeScubaSpot(ScubaSpotModel scubaSpot) async {
    try {
      final path = await _getFilePath();
      final file = File(path);

      List<ScubaSpotModel> storedScubaSpots = await getStoredScubaSpots();
      storedScubaSpots.add(scubaSpot);

      final updatedJsonString = jsonEncode(storedScubaSpots.map((spot) => spot.toJson()).toList());
      await file.writeAsString(updatedJsonString);
    } catch (e) {
      print("Error storing scuba spot: $e");
    }
  }

  // delete scuba spot from scuba_spots.json
  Future<void> deleteScubaSpot(String id) async {
    try {
      final path = await _getFilePath();
      final file = File(path);

      List<ScubaSpotModel> storedScubaSpots = await getStoredScubaSpots();
      storedScubaSpots.removeWhere((spot) => spot.id == id);

      final updatedJsonString = jsonEncode(storedScubaSpots.map((spot) => spot.toJson()).toList());
      await file.writeAsString(updatedJsonString);
    } catch (e) {
      print("Error deleting scuba spot: $e");
    }
  }
}
