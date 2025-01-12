import 'package:basf_weather_app_for_malaysia_scuba_diving/utils/CustomTheme.dart';
import 'package:basf_weather_app_for_malaysia_scuba_diving/views/WeatherView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// void main()  {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//   ]).then((_) {
//     runApp(MyApp());
//   });
// }

import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
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