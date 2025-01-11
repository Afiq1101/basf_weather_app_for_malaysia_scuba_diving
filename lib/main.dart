import 'package:basf_weather_app_for_malaysia_scuba_diving/models/WeatherModel.dart';
import 'package:basf_weather_app_for_malaysia_scuba_diving/services/CurrentLocationService.dart';
import 'package:basf_weather_app_for_malaysia_scuba_diving/services/WeatherService.dart';
import 'package:basf_weather_app_for_malaysia_scuba_diving/utils/CustomTheme.dart';
import 'package:basf_weather_app_for_malaysia_scuba_diving/views/ScubaSpotView.dart';
import 'package:basf_weather_app_for_malaysia_scuba_diving/views/WeatherView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

void main()  {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tide Scuba',
      theme: CustomTheme.lightTheme,
      home: WeatherView(),
    );
  }
}