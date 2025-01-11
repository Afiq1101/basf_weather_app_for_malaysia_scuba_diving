import 'dart:io';
import 'dart:ui';
import 'package:basf_weather_app_for_malaysia_scuba_diving/services/CurrentLocationService.dart';
import 'package:basf_weather_app_for_malaysia_scuba_diving/services/JsonStoreService.dart';
import 'package:basf_weather_app_for_malaysia_scuba_diving/services/ScubaSpotService.dart';
import 'package:basf_weather_app_for_malaysia_scuba_diving/services/WeatherService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:location/location.dart';
import 'package:uuid/uuid.dart';
import 'package:basf_weather_app_for_malaysia_scuba_diving/models/ScubaSpotModel.dart';
import 'package:basf_weather_app_for_malaysia_scuba_diving/models/WeatherModel.dart';
import 'package:flutter/material.dart';

class ScubaSpotViewModel extends ChangeNotifier{

  ScubaSpotViewModel(){
    resetScubaSpots();
  }

  @override
  void dispose() {
    scrollController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  final GlobalKey headerSliverKey = GlobalKey();
  final GlobalKey titleSliverKey = GlobalKey();
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  double headerOpacity = 0;
  double titleOpacity = 0;

  final JsonStoreService jsonStoreService = JsonStoreService();
  List<ScubaSpotModel> filteredSpots = [];
  bool isLoading = false;

  RenderSliver? keyToSliver(GlobalKey key) => key.currentContext?.findAncestorRenderObjectOfType<RenderSliver>();


  //change opacity on scroll
  bool handleScrollNotification(ScrollNotification notification) {
    final RenderSliver? headerSliver = keyToSliver(headerSliverKey);
    final RenderSliver? titleSliver = keyToSliver(titleSliverKey);

    if (notification is ScrollUpdateNotification) {
      final double opacity = notification.metrics.pixels > 50 ? 1 : 0;
      if (opacity != titleOpacity) {
          titleOpacity = opacity;
          notifyListeners();
      }
    }

    if (headerSliver != null &&
        titleSliver != null &&
        titleSliver.geometry != null) {
      final double opacity = headerSliver.constraints.scrollOffset >
          titleSliver.geometry!.scrollExtent
          ? 1
          : 0;
      if (opacity != headerOpacity) {
          headerOpacity = opacity;
          notifyListeners();
      }
    }
    return false;
  }


  //filter to the spots by spotLabel
  void searchScubaSpots(String query) {
    filteredSpots = [];

    if(query.trim().isEmpty){
      filteredSpots = ScubaSpotService.scubaSpots;
    }else{
      for(ScubaSpotModel spot in ScubaSpotService.scubaSpots){
        if( spot.scubaSpotLabel.toLowerCase().startsWith(query.toLowerCase())){
          filteredSpots.add(spot);
        }
      }
    }

    notifyListeners();
  }

  //set scuba spots back to default
  Future<void> resetScubaSpots() async {
    print(filteredSpots.length);
    isLoading = true;
    notifyListeners();

    filteredSpots = [];
    filteredSpots = ScubaSpotService.scubaSpots;

    List<ScubaSpotModel> storedScubaSpots = await jsonStoreService.getStoredScubaSpots();

    for(ScubaSpotModel spotModel in storedScubaSpots){
      filteredSpots.add(spotModel);
    }

    filteredSpots.sort((a, b) => b.priorityIndex.compareTo(a.priorityIndex));

    isLoading = false;
    notifyListeners();
    print(filteredSpots.length);
  }


  //delete custom scuba spots to .json file
  Future<void> deleteLocation(ScubaSpotModel scubaSpot) async {
    filteredSpots.remove(scubaSpot);
    notifyListeners();
    await jsonStoreService.deleteScubaSpot(scubaSpot.id);

  }

  //set the currentLocation as the Scuba spot
  Future<void> addCurrentLocationToScubaSpot() async {
    isLoading = true;
    notifyListeners();
    LocationData? position = await CurrentLocationService().getCurrentLocation();

    if (position == null || position.latitude == null || position.longitude == null) {
      return;
    }

    Map<String, dynamic>? map = await WeatherService().fetchMarineWeatherGenezio(
      long: position.longitude!,
      lat: position.latitude!,
      days: "1",
    );

    WeatherModel weatherModel = WeatherModel.fromJson(map);

    List<ScubaSpotModel> storedScubaSpots = await jsonStoreService.getStoredScubaSpots();

    bool duplicateFound = false;
    for(ScubaSpotModel storedScubaSpotModel in  storedScubaSpots){
      if(storedScubaSpotModel.long == weatherModel.location.lon && storedScubaSpotModel.lat == weatherModel.location.lat){
        duplicateFound = true;
        break;
      }
    }

    if(duplicateFound){
      print("duplicateFound");
    }else{
      ScubaSpotModel newScubaSpot = ScubaSpotModel(
        id: Uuid().v4(),
        scubaSpotLabel: weatherModel.location.name,
        lat: weatherModel.location.lat,
        long: weatherModel.location.lon,
        priorityIndex: 10,
        regionLabel: weatherModel.location.region,
        countryLabel: weatherModel.location.country,
        saveType: "json_file",
      );

      await jsonStoreService.storeScubaSpot(newScubaSpot);
      await resetScubaSpots();
    }

    isLoading = false;
    notifyListeners();
  }

}

