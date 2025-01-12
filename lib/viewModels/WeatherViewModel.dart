import 'dart:developer';
import 'package:basf_weather_app_for_malaysia_scuba_diving/models/ScubaSpotModel.dart';
import 'package:basf_weather_app_for_malaysia_scuba_diving/models/WeatherModel.dart';
import 'package:basf_weather_app_for_malaysia_scuba_diving/services/ScubaSpotService.dart';
import 'package:basf_weather_app_for_malaysia_scuba_diving/services/SharedPreferencesService.dart';
import 'package:basf_weather_app_for_malaysia_scuba_diving/services/WeatherService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherViewModel extends ChangeNotifier {

  WeatherViewModel() {
    initialSetScubaSpotAndWeather();
  }


  WeatherModel? weatherModel;
  bool isLoading = false;
  late ScubaSpotModel scubaSpotModel;
  int days = 5;
  final ScrollController scrollController = ScrollController();
  double headerOpacity = 0;
  double temperatureOpacity = 0;
  double largeTemperatureOpacity = 1;
  double titleOpacity = 1;
  final GlobalKey headerSliverKey = GlobalKey();


  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  //change opacity on scroll
  bool handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final double opacity = notification.metrics.pixels > 120 ? 1 : 0;
      if (opacity != headerOpacity) {
        headerOpacity = opacity;
        notifyListeners();
      }
    }

    if (notification is ScrollUpdateNotification) {
      final double opacity = notification.metrics.pixels > 180 ? 1 : 0;
      if (opacity != temperatureOpacity) {
          temperatureOpacity = opacity;
          notifyListeners();
        }
    }

    if (notification is ScrollUpdateNotification) {
      final double opacity = notification.metrics.pixels > 120 ? 0 : 1;
      if (opacity != titleOpacity) {
          titleOpacity = opacity;
          notifyListeners();
        }
    }

    if (notification is ScrollUpdateNotification) {
      final double opacity = notification.metrics.pixels > 250 ? 0 : 1;
      if (opacity != largeTemperatureOpacity) {
          largeTemperatureOpacity = opacity;
          notifyListeners();
      }
    }
    return false;
  }

  // Helper for managing loading state
  Future<void> _withLoadingState(Future<void> Function() action) async {
    isLoading = true;
    notifyListeners();
    await action();
    isLoading = false;
    notifyListeners();
  }

  // Set the initial scuba spot and fetch its weather
  Future<void> initialSetScubaSpotAndWeather() async {
    await _withLoadingState(() async {
      await getUnitSystem();
      await getRecentScubaSpot();
      await getWeather(latitude: scubaSpotModel.lat, longitude: scubaSpotModel.long);
    });
  }


  // Fetch and parse weather data into WeatherModel
  Future<void> getWeather({required double longitude, required double latitude}) async {
    try {
      Map<String, dynamic> map = await WeatherService().fetchMarineWeatherGenezio(
        long: longitude,
        lat: latitude,
        days: "$days",
      );
      weatherModel = WeatherModel.fromJson(map);
      log(map.toString());
      _setInitialWeatherValues();
    } catch (e) {
      print("Error fetching weather: $e");
      weatherModel = null;
    }
  }

  // Fetch the most recent scuba spot or use the first scuba spot in list as a default
  Future<void> getRecentScubaSpot() async {
    try {
      scubaSpotModel = (await sharedPreferencesService.getRecentScubaSpot()) ?? ScubaSpotService.scubaSpots.first;
    } catch (e) {
      print("Error fetching recent scuba spot: $e");
      throw Exception("Failed to initialize scuba spot");
    }
  }

  // Update scuba spot and fetch new weather data
  Future<void> changeScubaSpotAndWeather(ScubaSpotModel newScubaSpotModel) async {
    await _withLoadingState(() async {
      scubaSpotModel = newScubaSpotModel;
      try {
        await sharedPreferencesService.storeRecentScubaSpot(scubaSpotModel);
      } catch (e) {
        print("Error saving new scuba spot: $e");
      }
      await getWeather(latitude: scubaSpotModel.lat, longitude: scubaSpotModel.long);
    });
  }


  //----------
  String avgTemp = "N/A";
  String maxTemp = "N/A";
  String minTemp = "N/A";
  String averageVisibility = "N/A";
  String averageHumidity = "N/A";

  String hourTemp = "--";
  String weatherCondition = "N/A";
  String weatherSummary = "No hourly forecast available.";


  String totalPrecip = "N/A";
  String nextDayTotalPrecip = "N/A";

  String humidity = "N/A";
  String dewPoint = "N/A";

   String windSpeedUnit = "N/A";
   String windSpeed = "N/A";
   String gustSpeed = "N/A";
   String windDirection = "N/A";
   String windDegree = "N/A";

   List<Hour> hours = [];
   List<ForecastDay> forecastDays = [];
   List<Tide> tides = [];

   bool isSunUp = true;

   double currentHourPressureMb = 0;

   String visibility = "N/A";
  String visibilityDescription = "N/A";
  String feelsLike = "N/A";

  late Astro astro;

   String uvIndex = "N/A";
   String uvLevel = "N/A";
   String uvRecommendation = "N/A";

   String scubaSpotLabel = "N/A";

   String sunSet = "N/A";
  String sunRise = "N/A";

  String dayOfTheWek = "N/A";

  late ForecastDay forecastDay;
  late ForecastDay? nextForecastDay;

  void _setInitialWeatherValues(){
    WeatherModel? weatherModelHere = weatherModel;

    ScubaSpotModel scubaSpotModelHere = scubaSpotModel;
    if(scubaSpotModelHere != null){
      scubaSpotLabel = scubaSpotModelHere.scubaSpotLabel;
    }

    if (weatherModelHere?.forecastDays != null && weatherModelHere!.forecastDays.isNotEmpty) {
      forecastDays = weatherModelHere.forecastDays;

      forecastDay  = weatherModelHere.forecastDays.first;

      ForecastDay? nextDay;
      if(forecastDays.length > 1){
        nextDay = getNextDay(forecastDays, 0);
        nextForecastDay = nextDay;
      }

      _setWeatherToSelectedDay(forecastDay, nextDay );

    }
  }

  String generateConditionSummary(List<Hour> hours) {
    if (hours.isEmpty || hours.length == 1) {
      return "No hourly forecast available.";
    }

    int currentConditionCode = hours.first.condition.code;
    String currentConditionText = hours.first.condition.text;
    String startTime = hours.first.time;

    for (int i = 1; i < hours.length; i++) {
      // check if the condition code changes
      if (hours[i].condition.code != currentConditionCode) {
        return "$currentConditionText conditions from ${formatTime(startTime)}-${formatTime(hours[i].time)}.";
      }
    }

    // If no condition change is found, summarize the entire range
    return "$currentConditionText conditions from ${formatTime(startTime)}-${formatTime(hours.last.time)}.";
  }

  String formatTime(String time) {
    DateTime dateTime = DateTime.parse(time);
    return DateFormat('HH:mm').format(dateTime);
  }


  void _setWeatherToSelectedDay(ForecastDay forecastDay, ForecastDay? nextDay){
    dayOfTheWek = getDayLabel(forecastDay.date);
    bool isImperial = unitSystem == SharedPreferencesService.IMPERIAL;
    print("isImperial $isImperial");

    maxTemp = forecastDay.day.getMaxTempString(isImperial);
    minTemp = forecastDay.day.getMinTempString(isImperial);
    avgTemp =  forecastDay.day.getAvgTemp(isImperial);

    averageHumidity =  forecastDay.day.avgHumidity.toString();
    averageVisibility =  forecastDay.day.getAvgVisibility(isImperial);

    totalPrecip = forecastDay.day.getTotalPrecip(isImperial);

    if(forecastDay.hours.isNotEmpty){
      hourTemp = forecastDay.hours.first.getTemp(isImperial);
      weatherCondition = forecastDay.hours.first.condition.text;



      print(weatherSummary);


      humidity = forecastDay.hours.first.getHumidity();
      dewPoint = forecastDay.hours.first.getDewPoint(isImperial);
      windSpeedUnit = isImperial ? "MP/H" : "KM/H";
      windSpeed = forecastDay.hours.first.getWindSpeed(isImperial);
      gustSpeed = forecastDay.hours.first.getGustSpeed(isImperial);
      windDirection = forecastDay.hours.first.windDir;
      windDegree = forecastDay.hours.first.windDegree.toString();

      //if its today show only whats left else show all of it
      if(dayOfTheWek == "Today"){
        hours = forecastDay.getCurrentAndFutureHours();
      }else{
        hours = forecastDay.hours;
      }

      weatherSummary = generateConditionSummary(hours);

      tides = forecastDay.day.tides;


      isSunUp = forecastDay.astro.isSunUp();

      currentHourPressureMb = forecastDay.hours.first.pressureMb;

      visibility = forecastDay.hours.first.getVisibility(isImperial);
      visibilityDescription = forecastDay.hours.first.describeVisibility();

      feelsLike = forecastDay.hours.first.getFeelsLike(isImperial);

      uvIndex = forecastDay.hours.first.uv.ceil().toString();
      uvLevel = forecastDay.hours.first.getUVLevel();
      uvRecommendation = forecastDay.hours.first.getUVRecommendation();
    }
    astro = forecastDay.astro;

    Astro? astroHere = forecastDay.astro;
    if(astroHere != null){
      sunRise = astroHere.getSunRise();
      sunSet = astroHere.getSunSet();
    }

    if(nextDay != null){
      nextDayTotalPrecip = nextDay.day.getTotalPrecip(isImperial);
    }else{
      nextDayTotalPrecip = "N/A";
    }
  }

  String getDayLabel(String date) {
    DateTime parsedDate = DateTime.parse(date);
    DateTime today = DateTime.now();

    // check the parsed date with today's date
    if (parsedDate.year == today.year &&
        parsedDate.month == today.month &&
        parsedDate.day == today.day) {
      return "Today";
    } else {
      return DateFormat('EEEE').format(parsedDate); // return full day label
    }
  }

  Future<void> changeForecastDay(ForecastDay forecastDayParsed,index  ) async {
    isLoading = true;
    notifyListeners();

      WeatherModel? weatherModelHere = weatherModel;

        scubaSpotLabel = scubaSpotModel.scubaSpotLabel;


      if (weatherModelHere?.forecastDays != null && weatherModelHere!.forecastDays.isNotEmpty) {
        forecastDays = weatherModelHere.forecastDays;
        forecastDay = forecastDayParsed;
        ForecastDay? nextDay;
        if(forecastDays.length > 1){
          nextDay = getNextDay(forecastDays, index);
          nextForecastDay = nextDay;
        }

        _setWeatherToSelectedDay(forecastDayParsed, nextDay );
      }
    await Future.delayed(Duration(seconds: 2));
    isLoading = false;
    notifyListeners();
  }

  ForecastDay? getNextDay(List<ForecastDay> forecastDays, int currentIndex) {
    // check index is within bounds
    if (currentIndex >= 0 && currentIndex + 1 < forecastDays.length) {
      return forecastDays[currentIndex + 1]; // Return next day
    }
    return null; // return null if out of bounds
  }


  final SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
  String unitSystem = SharedPreferencesService.METRIC; // Default to METRIC


  //set the preferred unit system
  Future<void> setUnitSystem() async {
    if(unitSystem == SharedPreferencesService.IMPERIAL){
      unitSystem = SharedPreferencesService.METRIC;
    }else{
      unitSystem = SharedPreferencesService.IMPERIAL;
    }
    _setWeatherToSelectedDay(forecastDay, nextForecastDay);
    notifyListeners();
    await sharedPreferencesService.storeUnitSystem(unitSystem);
  }

  //get the preferred unit system
  Future<void> getUnitSystem() async {
    unitSystem = await sharedPreferencesService.getUnitSystem();
    notifyListeners();
  }

}


