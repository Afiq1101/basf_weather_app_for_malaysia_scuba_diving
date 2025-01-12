
//more info https://www.weatherapi.com/docs/#apis-marine
import 'package:intl/intl.dart';

class WeatherModel {
  final Location location;
  final List<ForecastDay> forecastDays;

  WeatherModel({required this.location, required this.forecastDays});

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      location: Location.fromJson(json['location']),
      forecastDays: (json['forecast']['forecastday'] as List).map((day) => ForecastDay.fromJson(day)).toList(),
    );
  }
}

class Location {
  final String name;
  final String region;
  final String country;
  final double lat;
  final double lon;
  final String tzId;
  final String localtime;

  Location({
    required this.name,
    required this.region,
    required this.country,
    required this.lat,
    required this.lon,
    required this.tzId,
    required this.localtime,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      region: json['region'],
      country: json['country'],
      lat: json['lat'].toDouble(),
      lon: json['lon'].toDouble(),
      tzId: json['tz_id'],
      localtime: json['localtime'],
    );
  }
}

class ForecastDay {
  final String date;
  final int dateEpoch;
  final Day day;
  final Astro astro;
  final List<Hour> hours;

  ForecastDay({
    required this.date,
    required this.dateEpoch,
    required this.day,
    required this.astro,
    required this.hours,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      date: json['date'],
      dateEpoch: json['date_epoch'],
      day: Day.fromJson(json['day']),
      astro: Astro.fromJson(json['astro']),
      hours: (json['hour'] as List).map((hour) => Hour.fromJson(hour)).toList(),
    );
  }

  String getDayOfWeekFromEpoch() {
    // convert the epoch time to DateTime
    DateTime date = DateTime.fromMillisecondsSinceEpoch(dateEpoch * 1000);

    //return "Today" if its today...lol
    DateTime today = DateTime.now();
    if (date.year == today.year && date.month == today.month && date.day == today.day) {
      return "Today";
    }
    List<String> daysOfWeek = ["SUN","MON", "TUE", "WED", "THU", "FRI", "SAT", ];

    // return the day of the week
    return daysOfWeek[date.weekday % 7];
  }

  List<Hour> getCurrentAndFutureHours() {
    final now = DateTime.now();
    final currentHour = now.hour;
    return hours.where((hour) {
      final hourTime = DateTime.parse(hour.time);
      final hourOfDay = hourTime.hour;
      return hourOfDay >= currentHour;
    }).toList();
  }


}

class Day {
  final double maxTempC;
  final double maxTempF;
  final double minTempC;
  final double minTempF;
  final double avgTempC;
  final double avgTempF;
  final double maxWindKph;
  final double totalPrecipMm;
  final double totalPrecipIn;
  final double uv;
  final Condition condition;
  final List<Tide> tides;
  final double avgVisKm;
  final double avgVisMiles;
  final double avgHumidity;

  Day({
    required this.maxTempC,
    required this.maxTempF,
    required this.minTempC,
    required this.minTempF,
    required this.avgTempC,
    required this.avgTempF,
    required this.maxWindKph,
    required this.totalPrecipMm,
    required this.totalPrecipIn,
    required this.uv,
    required this.condition,
    required this.tides,
    required this.avgVisKm,
    required this.avgVisMiles,
    required this.avgHumidity,
  });

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      maxTempC: json['maxtemp_c'].toDouble(),
      maxTempF: json['maxtemp_f'].toDouble(),
      minTempC: json['mintemp_c'].toDouble(),
      minTempF: json['mintemp_f'].toDouble(),
      avgTempC: json['avgtemp_c'].toDouble(),
      avgTempF: json['avgtemp_f'].toDouble(),
      maxWindKph: json['maxwind_kph'].toDouble(),
      totalPrecipMm: json['totalprecip_mm'].toDouble(),
      totalPrecipIn:json['totalprecip_in'].toDouble(),
      uv: json['uv'].toDouble(),
      condition: Condition.fromJson(json['condition']),
      tides: (json['tides'] as List)
          .expand((tideGroup) => (tideGroup['tide'] as List))
          .map((tide) => Tide.fromJson(tide))
          .toList(),
      avgVisKm: json['avgvis_km'].toDouble(),
      avgVisMiles: json['avgvis_miles'].toDouble(),
      avgHumidity: json['avghumidity'].toDouble(),
    );
  }

  double getMaxTempDouble(bool isImperial) => isImperial ? maxTempF : maxTempC;
  double getMinTempDouble(bool isImperial) => isImperial ? minTempF : minTempC;

  String getMaxTempString(bool isImperial) => isImperial ? maxTempF.ceil().toString() : maxTempC.ceil().toString();
  String getMinTempString(bool isImperial) => isImperial ? minTempF.ceil().toString() : minTempC.ceil().toString();
  String getAvgTemp(bool isImperial) => isImperial ? avgTempF.toString() : avgTempC.toString();
  String getTotalPrecip(bool isImperial) => isImperial ? "${totalPrecipIn.ceil()} in" : "${totalPrecipMm.ceil()} mm";

  String getAvgVisibility(bool isImperial) => isImperial ? "${avgVisKm}km" : "${avgVisMiles}mi";


}

class Tide {
  final String tideTime;
  final String tideHeightMt;
  final String tideType;

  Tide({
    required this.tideTime,
    required this.tideHeightMt,
    required this.tideType,
  });

  factory Tide.fromJson(Map<String, dynamic> json) {
    return Tide(
      tideTime: json['tide_time'],
      tideHeightMt: json['tide_height_mt'],
      tideType: json['tide_type'],
    );
  }

  String extractTideTime() {
    // get only HH:mm
    return tideTime.substring(11);
  }

  bool isHighTide()=> tideType == "HIGH" ? true : false;

  String getTideHeight(bool isImperial) {
    double heightInMeters = double.parse(tideHeightMt);
    if (isImperial) {
      // change to feet and return
      double heightInFeet = heightInMeters * 3.28084;
      return "${heightInFeet.ceil()}ft";
    } else {
      // return meters
      return "${heightInMeters.ceil()}m";
    }
  }
}

class Condition {
  final String text;
  final String icon;
  final int code;

  Condition({required this.text, required this.icon, required this.code});

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(
      text: json['text'],
      icon: json['icon'],
      code: json['code'],
    );
  }
}

class Astro {
  final String sunrise;
  final String sunset;
  final String moonPhase;

  Astro({
    required this.sunrise,
    required this.sunset,
    required this.moonPhase,
  });

  factory Astro.fromJson(Map<String, dynamic> json) {
    return Astro(
      sunrise: json['sunrise'],
      sunset: json['sunset'],
      moonPhase: json['moon_phase'],
    );
  }

  String getSunRise() => _convertToHHmm(sunrise).toString();
  String getSunSet() => _convertToHHmm(sunset).toString();


  static String _convertToHHmm(String time12h) {
    final inputFormat = DateFormat("hh:mm a"); // 12 hour initial format
    final outputFormat = DateFormat("HH:mm");  // output fomat
    final dateTime = inputFormat.parse(time12h);
    return outputFormat.format(dateTime);
  }

  bool isSunUp() {
    DateTime now = DateTime.now();

    // parse the sunrise and sunset times
    DateFormat timeFormat = DateFormat("hh:mm a");

    // convert sunrise and sunset to DateTime
    DateTime sunriseTime = timeFormat.parse(sunrise).add(Duration(days: now.day - 1));
    DateTime sunsetTime = timeFormat.parse(sunset).add(Duration(days: now.day - 1));

    // check current time in between sunrise and sunset times
    return now.isAfter(sunriseTime) && now.isBefore(sunsetTime);
  }
}

class Hour {
  final String time;
  final double tempC;
  final double tempF;
  final int humidity;
  final Condition condition;
  final double dewpointC;
  final double dewpointF;
  final double windMph;
  final double windKph;
  final int windDegree;
  final String windDir;
  final double gustMph;
  final double gustKph;
  final double pressureMb;
  final double pressureIn;
  final double visKm;
  final double visMiles;
  final double feelsLikeC;
  final double feelsLikeF;
  final double uv;


  Hour({
    required this.time,
    required this.tempC,
    required this.tempF,
    required this.humidity,
    required this.condition,
    required this.dewpointC,
    required this.dewpointF,
    required this.windMph,
    required this.windKph,
    required this.windDegree,
    required this.windDir,
    required this.gustMph,
    required this.gustKph,
    required this.pressureMb,
    required this.pressureIn,
    required this.visKm,
    required this.visMiles,
    required this.feelsLikeC,
    required this.feelsLikeF,
    required this.uv,
  });

  factory Hour.fromJson(Map<String, dynamic> json) {
    return Hour(
      time: json['time'],
      tempC: json['temp_c'].toDouble(),
      tempF: json['temp_f'].toDouble(),
      humidity: json['humidity'],
      condition: Condition.fromJson(json['condition']),
      dewpointC: json['dewpoint_c'].toDouble(),
      dewpointF: json['dewpoint_f'].toDouble(),
      windMph: json['wind_mph'].toDouble(),
      windKph: json['wind_kph'].toDouble(),
      windDegree: json['wind_degree'],
      windDir: json['wind_dir'],
      gustMph: json['gust_mph'].toDouble(),
      gustKph: json['gust_kph'].toDouble(),
      pressureMb: json['pressure_mb'].toDouble(),
      pressureIn: json['pressure_in'].toDouble(),
      visKm: json['vis_km'].toDouble(),
      visMiles: json['vis_miles'].toDouble(),
      feelsLikeC: json['feelslike_c'].toDouble(),
      feelsLikeF: json['feelslike_f'].toDouble(),
      uv: json['uv'].toDouble(),
    );
  }

  String getTemp(bool isImperial) => isImperial ? tempF.ceil().toString() : tempC.ceil().toString();
  String getHumidity() => humidity.toString();
  String getDewPoint(bool isImperial) => isImperial ? dewpointF.ceil().toString() : dewpointC.ceil().toString();
  String getWindSpeed(bool isImperial) => isImperial ? windMph.ceil().toString() : windKph.ceil().toString();
  String getGustSpeed(bool isImperial) => isImperial ? gustMph.ceil().toString() : gustKph.ceil().toString();
  String getVisibility(bool isImperial) => isImperial ? "${visMiles.ceil()} mi" : "${visKm.ceil()} km";
  String getFeelsLike(bool isImperial) => isImperial ? feelsLikeF.toString() : feelsLikeC.toString();

  String getHourHHmm() {
    // get "HH:mm" from the time string
    String hourMinute = time.substring(11);

    // set current hour in "HH:mm"
    String currentHourMinute = DateFormat('HH:mm').format(DateTime.now());

    // compare current time
    if (hourMinute == currentHourMinute) {
      return "now";
    } else {
      return hourMinute;
    }
  }

  String getHourHH() {
    DateTime hourDateTime = DateTime.parse(time);
    int hour = hourDateTime.hour;
    int currentHour = DateTime.now().hour;

    // compare the hour
    if (hour == currentHour) {
      return "Now";
    } else {
      return hour.toString(); // format as "HH"
    }
  }


  double getPressureInPercentage() {
    const double minPressure = 980.0; // min pressure in mb
    const double maxPressure = 1050.0; //max pressure in mb
    double percentage = ((pressureMb - minPressure) / (maxPressure - minPressure)) * 100;

    // prevnet the percentage from exceeding between 0% and 100%
    percentage = percentage.clamp(0.0, 100.0);

    return percentage;
  }

  String describeVisibility() {
    if (visKm >= 10) {
      return "Perfectly clear view.";
    } else if (visKm >= 5) {
      return "Good visibility with a clear view.";
    } else if (visKm >= 2) {
      return "Moderate visibility, conditions slightly hazy.";
    } else if (visKm >= 1) {
      return "Poor visibility, significant haze or obstruction.";
    } else {
      return "Very poor visibility, barely able to see.";
    }
  }

  String getUVLevel() {
    if (uv <= 2) {
      return "Low";
    } else if (uv <= 5) {
      return "Moderate";
    } else if (uv <= 7) {
      return "High";
    } else if (uv <= 10) {
      return "Very High";
    } else {
      return "Extreme";
    }
  }

  String getUVRecommendation() {
    if (uv <= 2) {
      return "Minimal risk of harm from unprotected sun exposure.";
    } else if (uv <= 5) {
      return "Moderate risk of harm. Protection is advised.";
    } else if (uv <= 7) {
      return "High risk of harm. Precautions are necessary.";
    } else if (uv <= 10) {
      return "Very high risk of harm. Take extra precautions.";
    } else {
      return "Extreme risk of harm. Avoid sun exposure.";
    }
  }


}
