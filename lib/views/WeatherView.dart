import 'dart:ui';
import 'package:basf_weather_app_for_malaysia_scuba_diving/models/WeatherModel.dart';
import 'package:basf_weather_app_for_malaysia_scuba_diving/services/SharedPreferencesService.dart';
import 'package:basf_weather_app_for_malaysia_scuba_diving/viewModels/WeatherViewModel.dart';
import 'package:basf_weather_app_for_malaysia_scuba_diving/views/ScubaSpotView.dart';
import 'package:basf_weather_app_for_malaysia_scuba_diving/widget/InkWellButton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:gauge_indicator/gauge_indicator.dart';

class WeatherView extends StatelessWidget {
  const WeatherView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (_) => WeatherViewModel(),
      child: Consumer<WeatherViewModel>(
          builder: (context, weatherViewModel, _) {
              return Scaffold(
                extendBodyBehindAppBar: true,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(75.0),
                  child: AppBar(
                    automaticallyImplyLeading: true,
                    backgroundColor: Colors.transparent,
                    flexibleSpace:AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: weatherViewModel.headerOpacity,
                      child: Container(
                        color: Colors.blueGrey,
                        child: Column(
                          children: [
                            SizedBox(height: 50,),
                            AnimatedOpacity(
                              opacity: weatherViewModel.headerOpacity,
                              duration: const Duration(milliseconds: 200),
                              child: Text(
                                weatherViewModel.scubaSpotLabel,
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    fontSize: 35,letterSpacing:-1.2,shadows: <Shadow>[Shadow(offset: Offset(0, 1), blurRadius: 19.0,
                                  color:Colors.black.withValues(alpha: 0.3),),],
                                    color: Theme.of(context).primaryColorDark.withValues(alpha: 1)
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),
                            AnimatedOpacity(
                                opacity: weatherViewModel.temperatureOpacity,
                                duration: const Duration(milliseconds: 200),
                                child: RichText(
                                  text: TextSpan(
                                    text: weatherViewModel.hourTemp,
                                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                        fontSize: 19,letterSpacing:-1.2,shadows: <Shadow>[Shadow(offset: Offset(0, 1), blurRadius: 19.0,
                                      color:Colors.black.withValues(alpha: 0.3),),],
                                        color: Theme.of(context).primaryColorDark.withValues(alpha: 1)
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '   |   ',
                                      ),
                                      TextSpan(
                                        text: weatherViewModel.weatherCondition,
                                      ),
                                    ],
                                  ),
                                )

                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                backgroundColor: Colors.blueGrey,
                body: NotificationListener<ScrollNotification>(
                  onNotification: weatherViewModel.handleScrollNotification,
                  child: Stack(
                    children: [
                      weatherViewModel.isLoading ? WeatherViewLoadingWidget() :   CustomScrollView(
                        physics: const BouncingScrollPhysics(),
                        controller: weatherViewModel.scrollController,
                        slivers: <Widget>[
                          SliverAppBar(
                            automaticallyImplyLeading: false,
                            backgroundColor: Colors.transparent,
                            expandedHeight: 250.0,
                            floating: false,
                            pinned: false,
                            stretch: true,

                            flexibleSpace: FlexibleSpaceBar(
                              stretchModes: const [StretchMode.zoomBackground],
                              background: Container(
                                color: Colors.transparent,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 30.0),
                                  child: SizedBox(
                                    height: 200,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [

                                        Text(
                                          weatherViewModel.dayOfTheWek,
                                          style: Theme.of(context)
                                              .textTheme.displaySmall?.copyWith(
                                              fontSize: 20,letterSpacing:0,shadows: <Shadow>[Shadow(offset: Offset(0, 1), blurRadius: 19.0,
                                            color:Colors.black.withValues(alpha: 0.3),),],
                                              color: Theme.of(context).primaryColorDark.withValues(alpha: 1)),
                                        ),
                                        SizedBox(height: 10,),

                                        AnimatedOpacity(
                                          opacity: weatherViewModel.titleOpacity,
                                          duration: const Duration(milliseconds: 200),
                                          child: Text(
                                            weatherViewModel.scubaSpotLabel,
                                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                fontSize: 35,letterSpacing:-1.2,
                                                shadows: <Shadow>[Shadow(offset: Offset(0, 1), blurRadius: 19.0,
                                                  color:Colors.black.withValues(alpha: 0.3),),],
                                                color: Theme.of(context).primaryColorDark.withValues(alpha: 1)),),
                                        ),

                                        SizedBox(height: 16,),
                                        AnimatedOpacity(
                                          opacity: weatherViewModel.largeTemperatureOpacity,
                                          duration: const Duration(milliseconds: 200),
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 30.0),
                                            child: Text(
                                              "${weatherViewModel.hourTemp}°",
                                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                  fontSize: 96,letterSpacing:0,fontFamily: "PBSTH",shadows: <Shadow>[Shadow(offset: Offset(0, 1), blurRadius: 19.0,
                                                color:Colors.black.withValues(alpha: 0.3),),],
                                                  color: Theme.of(context).primaryColorDark.withValues(alpha: 1)),
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 16,),

                                        Text(
                                          weatherViewModel.weatherCondition,
                                          style: Theme.of(context)
                                              .textTheme.displaySmall?.copyWith(
                                              fontSize: 20,letterSpacing:0,shadows: <Shadow>[Shadow(offset: Offset(0, 1), blurRadius: 19.0,
                                            color:Colors.black.withValues(alpha: 0.3),),],
                                              color: Theme.of(context).primaryColorDark.withValues(alpha: 1)),
                                        ),
                                        SizedBox(height: 10,),
                                        Text(
                                          "H:${weatherViewModel.maxTemp}°  L:${weatherViewModel.minTemp}°",
                                          style: Theme.of(context)
                                              .textTheme.displaySmall?.copyWith(
                                              fontSize: 20,letterSpacing:0,shadows: <Shadow>[Shadow(offset: Offset(0, 1), blurRadius: 19.0,
                                            color:Colors.black.withValues(alpha: 0.3),),],
                                              color: Theme.of(context).primaryColorDark.withValues(alpha: 1)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(top:0.0),
                              child: ForecastWidget(isImperial: weatherViewModel.unitSystem == SharedPreferencesService.IMPERIAL, forecastDays: weatherViewModel.forecastDays, forecastDaysCount: weatherViewModel.days, changeForecastDay: weatherViewModel.changeForecastDay,),
                            ),
                          ),

                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(top:10.0),
                              child: TidesWidget(isSunUp: weatherViewModel.isSunUp, tides: weatherViewModel.tides, isImperial: weatherViewModel.unitSystem == SharedPreferencesService.IMPERIAL),
                            ),
                          ),


                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(top:10.0),
                              child: TodaysForecastWidget(hours: weatherViewModel.hours, weatherSummary: weatherViewModel.weatherSummary, isImperial: weatherViewModel.unitSystem == SharedPreferencesService.IMPERIAL),
                            ),
                          ),

                          SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.only(top:10.0),
                                child: WindWidget(windSpeedUnit: weatherViewModel.windSpeedUnit, windSpeed: weatherViewModel.windSpeed, gustSpeed: weatherViewModel.gustSpeed, windDirection: weatherViewModel.windDirection, windDegree: weatherViewModel.windDegree
                                ),
                              )
                          ),


                          SliverToBoxAdapter(
                            child:    Padding(
                              padding: const EdgeInsets.only(top:10.0),
                              child: Row(
                                  children: [
                                    PrecipitationWidget(totalPrecip: weatherViewModel.totalPrecip, nextDayTotalPrecip: weatherViewModel.nextDayTotalPrecip),
                                    SizedBox(height: 10,),
                                    HumidityWidget(humidity: weatherViewModel.humidity, dewPoint: weatherViewModel.dewPoint),
                                  ]
                              ),
                            ),
                          ),

                          SliverToBoxAdapter(
                            child:    Padding(
                              padding: const EdgeInsets.only(top:10.0),
                              child: Row(
                                  children: [
                                    PressureWidget(pressureMb: weatherViewModel.currentHourPressureMb),
                                    SizedBox(height: 10,),
                                    VisibilityWidget(visibility: weatherViewModel.visibility, visibilityDescription: weatherViewModel.visibilityDescription)
                                  ]
                              ),
                            ),
                          ),


                          SliverToBoxAdapter(
                            child:    Padding(
                              padding: const EdgeInsets.only(top:10.0),
                              child: Row(
                                  children: [
                                    AverageWidget(averageTemp: weatherViewModel.avgTemp, averageVisibility: weatherViewModel.averageVisibility, averageHumidity: weatherViewModel.averageHumidity),
                                    SizedBox(height: 10,),
                                    FeelsLikeWidget(feelsLike: weatherViewModel.feelsLike,)
                                  ]
                              ),
                            ),
                          ),


                          SliverToBoxAdapter(
                            child:    Padding(
                              padding: const EdgeInsets.only(top:10.0),
                              child: Row(
                                  children: [
                                    SunSetWidget(sunSet: weatherViewModel.sunSet, sunRise: weatherViewModel.sunRise, isSunUp: weatherViewModel.isSunUp),
                                    SizedBox(height: 10,),
                                    UvWidget(uvIndex: weatherViewModel.uvIndex, uvLevel: weatherViewModel.uvLevel, uvRecommendation: weatherViewModel.uvRecommendation)
                                  ]
                              ),
                            ),
                          ),

                          SliverToBoxAdapter(
                              child: SizedBox(height: 100,),
                          ),


                        ],
                      ),

                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                            child: Container(
                              height: 80,
                              width: size.width,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.03),
                                borderRadius: const BorderRadius.all( Radius.circular(0.0)),
                                border: Border.all(color: Theme.of(context).primaryColorDark.withValues(alpha: 0.3), width: 0.3,),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0,10,0,0),
                                      child: SizedBox(
                                        height: 50,
                                        child: Stack(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 0.0,left: 4,top: 5),
                                              child: SizedBox(
                                                height: 20,
                                                child: SvgPicture.asset(
                                                  "assets/svg/sw_logo_2.svg",
                                                  colorFilter: ColorFilter.mode(Theme.of(context).primaryColorDark.withValues(alpha: 0.7), BlendMode.srcIn),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 5,
                                              right: 8,
                                              child: Padding(
                                              padding: const EdgeInsets.only(top: 3.0,left: 0),
                                              child: Text(weatherViewModel.unitSystem == SharedPreferencesService.IMPERIAL  ? "F" : "C",
                                                  style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 20,letterSpacing:-0.1,color: Theme.of(context).primaryColorDark.withValues(alpha: 0.7))),
                                            ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(15,0,0,20),
                                              child: SizedBox(
                                                height: 50,
                                                width: 50,
                                                child: InkWellButton(onTap: () async {
                                                  await weatherViewModel.setUnitSystem();
                                                }, buttonHeight: 50,),
                                              ),
                                            )
                                              ],
                                        ),
                                      ),
                                    ),

                                    Spacer(),
                                    SizedBox(
                                      height: 44,
                                      width: 44,
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(0,10,0,0),
                                            child: SizedBox(
                                              height: 22,
                                              child: SvgPicture.asset(
                                                "assets/svg/sw_map.svg",
                                                colorFilter: ColorFilter.mode(Theme.of(context).primaryColorDark.withValues(alpha: 0.7), BlendMode.srcIn),

                                              ),
                                            ),
                                          ),
                                          InkWellButton(onTap: (){
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ScubaSpotView(changeLocation: weatherViewModel.changeScubaSpotAndWeather,)));

                                          }, buttonHeight: 44,)
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10,)
                                  ],
                                ),
                              ),
                          ),

                                                    ),
                        ),
                     ),
                    ],
                  ),
                ),
              );
          }
      ),
    );
  }
}



class SunSetWidget extends StatelessWidget {
  final bool isSunUp;
  final String sunSet;
  final String sunRise;

  const SunSetWidget({super.key, required this.sunSet, required this.sunRise, required this.isSunUp});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return    Padding(
      padding: const EdgeInsets.fromLTRB(20,0,5,0),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 13.0, sigmaY: 13.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFD7D1D1).withValues(alpha: 0.18),
              borderRadius: const BorderRadius.all( Radius.circular(16.0)),
              border: Border.all(color: Theme.of(context).primaryColorDark.withValues(alpha: 0.3), width: 0.3,),
            ),
            height: size.width/2-25,
            width: size.width/2-25,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Spacer(flex: 1,),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Padding(
                        padding:  EdgeInsets.fromLTRB(14,0,7,0),
                        child: SizedBox(
                          height: 14,
                          width: 15,
                          child: SvgPicture.asset(
                             isSunUp ?   "assets/svg/sw_sunset.svg": "assets/svg/sw_sun.svg",
                            colorFilter: ColorFilter.mode(Theme.of(context).primaryColorDark.withValues(alpha: 0.7), BlendMode.srcIn),
                            
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Text(isSunUp ? "SUNSET" : "SUNRISE",
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 13,letterSpacing:-0.1,color: Theme.of(context).primaryColorDark.withValues(alpha: 0.7))),
                      ),
                    ],
                  ),
                ),
                Spacer(flex: 1,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.fromLTRB(15,10,0,0),
                      child: SizedBox(
                        width: size.width/2-50,
                        child: Text(isSunUp ? sunSet: sunRise,overflow: TextOverflow.ellipsis,maxLines: 1,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 38,color: Theme.of(context).primaryColorDark.withValues(alpha: 1) )),
                      ),
                    ),
                  ],
                ),
                Spacer(flex: 10,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.fromLTRB(15,0,0,0),
                      child: SizedBox(
                        width: size.width/2-50,
                        child: Text(isSunUp ?  "Sunrise: $sunRise" :  "Sunset: $sunSet",overflow: TextOverflow.ellipsis,maxLines: 1,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 15,height:1.2,color: Theme.of(context).primaryColorDark.withValues(alpha: 1))),
                      ),
                    ),
                  ],
                ),
                Spacer(flex: 3,),
              ],
            ),

          ),
        ),
      ),
    );
  }
}

class PrecipitationWidget extends StatelessWidget {
  final String totalPrecip;
  final String nextDayTotalPrecip;
  const PrecipitationWidget({
    super.key,
    required this.totalPrecip,
    required this.nextDayTotalPrecip
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return   Padding(
      padding: const EdgeInsets.fromLTRB(20,0,5,0),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 13.0, sigmaY: 13.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFD7D1D1).withValues(alpha: 0.18),
              borderRadius: const BorderRadius.all( Radius.circular(16.0)),
              border: Border.all(color: Theme.of(context).primaryColorDark.withValues(alpha: 0.3), width: 0.3,),
            ),
            height: size.width/2-25,
            width: size.width/2-25,

            child: Column(
              children: [
                Spacer(flex: 1,),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Padding(
                        padding: const EdgeInsets.fromLTRB(14,0,7,0),
                        child: SizedBox(
                          height: 14,
                          width: 15,
                          child: SvgPicture.asset(
                            "assets/svg/sw_water.svg",
                            colorFilter: ColorFilter.mode(Theme.of(context).primaryColorDark.withValues(alpha: 0.7), BlendMode.srcIn),

                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Text("PRECIPITATION",
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 13,letterSpacing:-0.1,color: Theme.of(context).primaryColorDark.withValues(alpha: 0.7))),
                      ),
                    ],
                  ),
                ),

                Spacer(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.fromLTRB(15,10,0,0),
                      child: SizedBox(
                        width: size.width/2-50,
                        child: Text(totalPrecip,overflow: TextOverflow.ellipsis,maxLines: 1,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 37,color: Theme.of(context).primaryColorDark.withValues(alpha: 1) )),
                      ),
                    ),
                  ],
                ),

                Spacer(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.fromLTRB(15,0,0,0),
                      child: SizedBox(
                        width: size.width/2-50,
                        child: Text("in last 24h",overflow: TextOverflow.ellipsis,maxLines: 1,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 20,letterSpacing:-0.1,color: Theme.of(context).primaryColorDark.withValues(alpha: 1))),
                      ),
                    ),
                  ],
                ),

                Spacer(flex: 3,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.fromLTRB(15,0,0,0),
                      child: SizedBox(
                        width: size.width/2-50,
                        child: Text("$nextDayTotalPrecip expected in next 24h.",overflow: TextOverflow.ellipsis,maxLines: 2,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 15,height:1.2,color: Theme.of(context).primaryColorDark.withValues(alpha: 1))),
                      ),
                    ),
                  ],
                ),
                Spacer(flex: 3,),
              ],
            ),

          ),
        ),
      ),
    );
  }
}

class PressureWidget extends StatelessWidget {
  final double pressureMb;
  const PressureWidget({
    super.key,
    required this.pressureMb
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Padding(
      padding: const EdgeInsets.fromLTRB(20,0,5,0),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 13.0, sigmaY: 13.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFD7D1D1).withValues(alpha: 0.18),
              borderRadius: const BorderRadius.all( Radius.circular(16.0)),
              border: Border.all(color: Theme.of(context).primaryColorDark.withValues(alpha: 0.3), width: 0.3,),
            ),
            height: size.width/2-25,
            width: size.width/2-25,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Spacer(flex: 1,),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Padding(
                        padding: const EdgeInsets.fromLTRB(14,0,7,0),
                        child: SizedBox(
                          height: 14,
                          width: 15,
                          child: SvgPicture.asset(
                            "assets/svg/sw_pressure.svg",
                            colorFilter: ColorFilter.mode(Theme.of(context).primaryColorDark.withValues(alpha: 0.7), BlendMode.srcIn),

                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Text("PRESSURE",
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 13,letterSpacing:-0.1,color: Theme.of(context).primaryColorDark.withValues(alpha: 0.7))),
                      ),
                    ],
                  ),
                ),
                Spacer(flex: 2,),
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0,10,0,0),
                            child: Text("$pressureMb\nmb",overflow: TextOverflow.ellipsis,maxLines: 2,textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 16,color: Theme.of(context).primaryColorDark.withValues(alpha: 1) )),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                          height: 100,
                          width: 100,
                          child: Center(
                            child: AnimatedRadialGauge(
                              duration: Duration.zero,
                              curve: Curves.linear,
                              radius: 45,
                              value: pressureMb,
                              axis: GaugeAxis(
                                min: 980,
                                max: 1050,
                                degrees: 270,
                                style: GaugeAxisStyle(
                                  thickness: 6,
                                  background: Colors.white.withValues(alpha: 0.3),
                                ),
                                pointer: GaugePointer.needle(
                                  borderRadius: 16,
                                  width: 10, height: 50, color: Colors.transparent,
                                ),
                                progressBar: const GaugeProgressBar.rounded(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                        child: SizedBox(
                          width: size.width/2-25,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 8,),
                              Text("Low",overflow: TextOverflow.ellipsis,maxLines: 1,
                                  style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 14,height:1.2,color: Theme.of(context).primaryColorDark.withValues(alpha: 1))),
                              Spacer(),
                              Text("High",overflow: TextOverflow.ellipsis,maxLines: 1,
                                  style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 14,height:1.2,color: Theme.of(context).primaryColorDark.withValues(alpha: 1))),
                              SizedBox(width: 8,),
                            ],
                          ),
                        ),
                    ),
                  ],
                ),
                Spacer(flex: 3,),
              ],
            ),

          ),
        ),
      ),
    );
  }
}

class HumidityWidget extends StatelessWidget {
  final String humidity;
  final String dewPoint;
  const HumidityWidget({super.key, required this.humidity, required this.dewPoint});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return   Padding(
      padding: const EdgeInsets.fromLTRB(5,0,20,0),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 13.0, sigmaY: 13.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFD7D1D1).withValues(alpha: 0.18),
              borderRadius: const BorderRadius.all( Radius.circular(16.0)),
              border: Border.all(color: Theme.of(context).primaryColorDark.withValues(alpha: 0.3), width: 0.3,),
            ),
            height: size.width/2-25,
            width: size.width/2-25,

            child: Column(
              children: [
                Spacer(flex: 1,),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Padding(
                        padding: const EdgeInsets.fromLTRB(14,0,7,0),
                        child: SizedBox(
                          height: 14,
                          width: 15,
                          child: SvgPicture.asset(
                            "assets/svg/sw_waves.svg",
                            colorFilter: ColorFilter.mode(Theme.of(context).primaryColorDark.withValues(alpha: 0.7), BlendMode.srcIn),

                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Text("HUMIDITY",
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 13,letterSpacing:-0.1,color: Theme.of(context).primaryColorDark.withValues(alpha: 0.7))),
                      ),
                    ],
                  ),
                ),

                Spacer(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.fromLTRB(15,10,0,0),
                      child: SizedBox(
                        width: size.width/2-50,
                        child: Text("$humidity%",overflow: TextOverflow.ellipsis,maxLines: 1,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 37,color: Theme.of(context).primaryColorDark.withValues(alpha: 1) )),
                      ),
                    ),
                  ],
                ),

                Spacer(flex: 6,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.fromLTRB(15,0,0,0),
                      child: SizedBox(
                        width: size.width/2-50,
                        child: Text("The dew point is $dewPoint° right now.",overflow: TextOverflow.ellipsis,maxLines: 2,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 15,height:1.2,color: Theme.of(context).primaryColorDark.withValues(alpha: 1))),
                      ),
                    ),
                  ],
                ),
                Spacer(flex: 3,),
              ],
            ),

          ),
        ),
      ),
    );
  }
}

class TidesWidget extends StatelessWidget {
  final bool isSunUp;
  final List<Tide> tides;
  final bool isImperial;

  const TidesWidget({
    super.key,
    required this.isSunUp,
    required this.tides,
    required this.isImperial,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return   Padding(
      padding: const EdgeInsets.fromLTRB(20,0,20,0),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 13.0, sigmaY: 13.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFD7D1D1).withValues(alpha: 0.18),
              borderRadius: const BorderRadius.all( Radius.circular(16.0)),
              border: Border.all(color: Theme.of(context).primaryColorDark.withValues(alpha: 0.3), width: 0.3,),
            ),
            width: size.width-40,
            height: size.width*0.456,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Spacer(flex: 1,),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Padding(
                        padding: const EdgeInsets.fromLTRB(14,0,7,0),
                        child: SizedBox(
                          height: 14,
                          width: 15,
                          child: SvgPicture.asset(
                            isSunUp? "assets/svg/sw_tides_day.svg" : "assets/svg/sw_tides_night.svg",
                            colorFilter: ColorFilter.mode(Theme.of(context).primaryColorDark.withValues(alpha: 0.7), BlendMode.srcIn),

                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Text("TIDES",
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 13,letterSpacing:-0.1,color: Theme.of(context).primaryColorDark.withValues(alpha: 0.7))),
                      ),
                    ],
                  ),
                ),

                Spacer(flex: 3,),

                SizedBox(
                  height: 91,
                  width: size.width-64,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: tides.length,
                    itemBuilder: (context, i){

                      Tide tide = tides[i];

                      return   Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15),
                        child: SizedBox(
                          height:91,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                child: Text(tide.extractTideTime(),overflow: TextOverflow.ellipsis,maxLines: 1,
                                    style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 15,height:1.2,color: Theme.of(context).primaryColorDark.withValues(alpha: 0.7))),
                              ),

                              SizedBox(
                                height: 25,
                                width: 27,
                                child: SvgPicture.asset(
                                  tide.isHighTide() ?   "assets/svg/sw_tides.svg": "assets/svg/sw_tides_low.svg",
                                  colorFilter: ColorFilter.mode(Theme.of(context).primaryColorDark.withValues(alpha: 0.7), BlendMode.srcIn),

                                ),
                              ),

                              SizedBox(
                                child: Text(tide.tideType,overflow: TextOverflow.ellipsis,maxLines: 1,
                                    style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 16,height:1.2,letterSpacing:-0.7,color: Theme.of(context).primaryColorDark.withValues(alpha: 0.8))),
                              ),

                              SizedBox(
                                child: Text(tide.getTideHeight(isImperial),overflow: TextOverflow.ellipsis,maxLines: 1,
                                    style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 16,height:1.2,color: Theme.of(context).primaryColorDark.withValues(alpha: 0.7))),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Spacer(flex: 3,),


              ],
            ),

          ),
        ),
      ),
    );
  }
}

class WindWidget extends StatelessWidget {
  final String windSpeedUnit;
  final String windSpeed;
  final String gustSpeed;
  final String windDirection;
  final String windDegree;

  const WindWidget({
    super.key,
    required this.windSpeedUnit,
    required this.windSpeed,
    required this.gustSpeed,
    required this.windDirection,
    required this.windDegree,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,0,20,0),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 13.0, sigmaY: 13.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFD7D1D1).withValues(alpha: 0.18),
              borderRadius: const BorderRadius.all( Radius.circular(16.0)),
              border: Border.all(color: Theme.of(context).primaryColorDark.withValues(alpha: 0.3), width: 0.3,),
            ),
            width: size.width-40,
            height: size.width*0.461,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Spacer(flex: 3,),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Padding(
                        padding: const EdgeInsets.fromLTRB(14,0,7,0),
                        child: SizedBox(
                          height: 14,
                          width: 15,
                          child: SvgPicture.asset(
                            "assets/svg/sw_wind.svg",
                            colorFilter: ColorFilter.mode(Theme.of(context).primaryColorDark.withValues(alpha: 0.7), BlendMode.srcIn),

                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Text("WIND",
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 13,letterSpacing:-0.1,color: Theme.of(context).primaryColorDark.withValues(alpha: 0.7))),
                      ),
                    ],
                  ),
                ),

                Spacer(flex: 5,),

                Padding(
                  padding: const EdgeInsets.only(left: 14.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                child: Text(windSpeed,overflow: TextOverflow.ellipsis,maxLines: 1,
                                    style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 37,height:1.2,letterSpacing:-0.7,color: Theme.of(context).primaryColorDark)),
                              ),
                              SizedBox(width: 9,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    child: Text(windSpeedUnit,overflow: TextOverflow.ellipsis,maxLines: 1,
                                        style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 13,height:1.2,color: Theme.of(context).primaryColorDark.withValues(alpha: 0.7))),
                                  ),
                                  SizedBox(
                                    child: Text("Wind",overflow: TextOverflow.ellipsis,maxLines: 1,
                                        style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 16,height:1.2,letterSpacing:-0.7,color: Theme.of(context).primaryColorDark)),
                                  ),
                                ],
                              ),
                              SizedBox(width: 74,),
                            ],
                          ),
                          SizedBox(
                              width: 165,
                              height: 10,
                              child: Divider(indent: 0,endIndent: 0,color: Theme.of(context).primaryColorDark.withValues(alpha: 0.41),)),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                child: Text(gustSpeed,overflow: TextOverflow.ellipsis,maxLines: 1,
                                    style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 37,height:1.2,letterSpacing:-0.7,color: Theme.of(context).primaryColorDark)),
                              ),
                              SizedBox(width: 9,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    child: Text(windSpeedUnit,overflow: TextOverflow.ellipsis,maxLines: 1,
                                        style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 13,height:1.2,color: Theme.of(context).primaryColorDark.withValues(alpha: 0.7))),
                                  ),
                                  SizedBox(
                                    child: Text("Gusts",overflow: TextOverflow.ellipsis,maxLines: 1,
                                        style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 16,height:1.2,letterSpacing:-0.7,color: Theme.of(context).primaryColorDark)),
                                  ),
                                ],
                              ),
                              SizedBox(width: 74,),
                            ],
                          ),
                        ],
                      ),

                      Spacer(),

                      Column(
                        children: [
                          SizedBox(
                            child: Text("$windDegree°",overflow: TextOverflow.ellipsis,maxLines: 1,textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 47,height:1.2,letterSpacing:-0.7,color: Theme.of(context).primaryColorDark)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 18.0,bottom: 30),
                            child: SizedBox(
                              child: Text(windDirection,overflow: TextOverflow.ellipsis,maxLines: 1,
                                  style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 21,height:1.2,letterSpacing:-0.7,color: Theme.of(context).primaryColorDark.withValues(alpha: 0.7))),
                            ),
                          ),
                        ],
                      ),

                      Spacer(),


                    ],
                  ),
                ),

                Spacer(flex: 5,),


              ],
            ),

          ),
        ),
      ),
    );
  }
}

class TodaysForecastWidget extends StatelessWidget {
  final String weatherSummary;
  final List<Hour> hours;
  final bool isImperial;
  const TodaysForecastWidget({
    super.key,
    required this.hours,
    required this.weatherSummary,
    required this.isImperial,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,0,20,0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFD7D1D1).withValues(alpha: 0.18),
          borderRadius: const BorderRadius.all( Radius.circular(16.0)),
          border: Border.all(color: Theme.of(context).primaryColorDark.withValues(alpha: 0.3), width: 0.3,),
        ),
        width: size.width-40,
        height: size.width*0.546,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Spacer(flex: 3,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                Padding(
                  padding: const EdgeInsets.fromLTRB(15,0,0,0),
                  child: SizedBox(
                    width: size.width-60,
                    child: Text(weatherSummary,overflow: TextOverflow.ellipsis,maxLines: 3,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 15,height:1.2,color: Theme.of(context).primaryColorDark.withValues(alpha: 0.7))),
                  ),
                ),
              ],
            ),

            Spacer(flex: 1,),

            Divider(indent: 14,endIndent: 14,color: Theme.of(context).primaryColorDark.withValues(alpha: 0.41),),

            Spacer(flex: 3,),
            SizedBox(
              height: 91,
              width: size.width-64,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: hours.length,
                itemBuilder:(context, i){

                  Hour hour = hours[i];

                  String time = hour.getHourHH();
                  String temp = hour.getTemp(isImperial);
                  String icon = "https:${hour.condition.icon}";

                  return Padding(
                    padding: const EdgeInsets.only(left:5.0, right:6.0),
                    child: SizedBox(
                      height:91,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            child: Text(time,overflow: TextOverflow.ellipsis,maxLines: 1,
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 15,height:1.2,color: Theme.of(context).primaryColorDark.withValues(alpha: 0.7))),
                          ),

                          SizedBox(height: 5,),

                          Container(
                            color: Colors.transparent,
                            height: 31,
                            width: 31,
                            child: CachedNetworkImage(
                              imageUrl: icon,
                              placeholder: (context, url) => SizedBox(height:25, width:25,child: CircularProgressIndicator(strokeWidth: 3,)),
                              errorWidget: (context, url, error) => Icon(Icons.error, size: 12,),
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 11,),

                          SizedBox(
                            child: Text("$temp°",overflow: TextOverflow.ellipsis,maxLines: 1,
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(letterSpacing:-0.3,fontSize: 20,height:1.2,color: Theme.of(context).primaryColorDark.withValues(alpha: 0.7))),
                          ),
                        ],
                      ),
                    ),
                  );
              }

              ),
            ),

            Spacer(flex: 5,),


          ],
        ),

      ),
    );
  }
}

class ForecastWidget extends StatelessWidget {
  final int forecastDaysCount;
  final List<ForecastDay> forecastDays;
  final bool isImperial;
  final Function(ForecastDay forecastDay,int currentIndex) changeForecastDay;

  const ForecastWidget({
    super.key,
    required this.isImperial,
    required this.forecastDays,
    required this.forecastDaysCount,
    required this.changeForecastDay,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return   Padding(
        padding: const EdgeInsets.fromLTRB(20,0,20,0),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFD7D1D1).withValues(alpha: 0.18),
            borderRadius: const BorderRadius.all( Radius.circular(16.0)),
            border: Border.all(color: Theme.of(context).primaryColorDark.withValues(alpha: 0.3), width: 0.3,),
          ),
          width: size.width-40,

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.fromLTRB(14,0,7,0),
                      child: SizedBox(
                        height: 14,
                        width: 15,
                        child: SvgPicture.asset(
                          "assets/svg/sw_calendar.svg",
                          colorFilter: ColorFilter.mode(Theme.of(context).primaryColorDark.withValues(alpha: 0.7), BlendMode.srcIn),

                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child: Text("$forecastDaysCount-DAY FORECAST",
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 13,letterSpacing:-0.1,color: Theme.of(context).primaryColorDark.withValues(alpha: 0.7))),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10,),
              Column(
                children: List.generate(forecastDays.length, (index) {
                  ForecastDay forecastDay = forecastDays[index];
                  String icon = "https:${forecastDay.day.condition.icon}";
                  String dayOfTheWeek = forecastDay.getDayOfWeekFromEpoch();
                  double minTemp = forecastDay.day.getMinTempDouble(isImperial);
                  double maxTemp = forecastDay.day.getMaxTempDouble(isImperial);
                  String minTempString = forecastDay.day.getMinTempString(isImperial);
                  String maxTempString = forecastDay.day.getMaxTempString(isImperial);

                  return   InkWell(
                    onTap: (){
                      changeForecastDay(forecastDay,index );
                    },
                    child: SizedBox(
                      height: 45,
                      width: size.width-64,
                      child: Column(
                        children: [

                          SizedBox(
                              height: 3,
                              child: Divider(indent: 0,endIndent: 0,color: Theme.of(context).primaryColorDark.withValues(alpha: 0.41),)),
                          Spacer(),
                          Row(
                            children: [
                              SizedBox(
                                child: Text(
                                  dayOfTheWeek,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    fontSize: 20,
                                    height: 1.2,
                                    color: Theme.of(context).primaryColorDark.withValues(alpha: 0.7)
                                  ),
                                ),
                              ),
                              Spacer(),
                              SizedBox(
                                height: 28,
                                width: 28,
                                child: CachedNetworkImage(
                                  imageUrl: icon,
                                  placeholder: (context, url) => SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Icon(Icons.error, size: 12),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Spacer(),
                              SizedBox(
                                width: size.width / 2,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          child: Text(
                                            "$minTempString°",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                              letterSpacing: -0.3,
                                              fontSize: 20,
                                              height: 1.2,
                                                color: Theme.of(context).primaryColorDark.withValues(alpha: 0.7)
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                                              gradient: LinearGradient(
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                                colors: [
                                                  minTemp < (isImperial ? 68 : 20)
                                                      ? Colors.blueAccent
                                                      : Colors.orangeAccent,
                                                  maxTemp > (isImperial ? 86 : 30)
                                                      ? Colors.redAccent
                                                      : Colors.yellowAccent,
                                                ],
                                                stops: [0.0, 0.8],
                                              ),
                                              border: Border.all(
                                                color: Theme.of(context).primaryColorDark.withValues(alpha:1),
                                                width: 0.3,
                                              ),
                                            ),
                                            height: 6,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        SizedBox(
                                          child: Text(
                                            "$maxTempString°",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                              letterSpacing: -0.3,
                                              fontSize: 20,
                                              height: 1.2,
                                                color: Theme.of(context).primaryColorDark.withValues(alpha: 0.7)
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  );
                }),
              ),


              SizedBox(height: 10,),
            ],
          ),

        ),
      );
  }
}

class VisibilityWidget extends StatelessWidget {
  final String visibility;
  final String visibilityDescription;
  const VisibilityWidget({
    super.key,
    required this.visibility,
    required this.visibilityDescription
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(5,0,20,0),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 13.0, sigmaY: 13.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFD7D1D1).withValues(alpha: 0.18),
              borderRadius: const BorderRadius.all( Radius.circular(16.0)),
              border: Border.all(color: Theme.of(context).primaryColorDark.withValues(alpha: 0.3), width: 0.3,),
            ),
            height: size.width/2-25,
            width: size.width/2-25,

            child: Column(
              children: [
                Spacer(flex: 1,),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Padding(
                        padding: const EdgeInsets.fromLTRB(14,0,7,0),
                        child: SizedBox(
                          height: 14,
                          width: 15,
                          child: SvgPicture.asset(
                            "assets/svg/sw_eye.svg",
                            colorFilter: ColorFilter.mode(Theme.of(context).primaryColorDark.withValues(alpha: 0.7), BlendMode.srcIn),

                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Text("VISIBILITY",
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 13,letterSpacing:-0.1,color: Theme.of(context).primaryColorDark.withValues(alpha: 0.7))),
                      ),
                    ],
                  ),
                ),

                Spacer(flex: 3,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.fromLTRB(15,10,0,0),
                      child: SizedBox(
                        width: size.width/2-50,
                        child: Text(visibility,overflow: TextOverflow.ellipsis,maxLines: 1,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 47,color: Theme.of(context).primaryColorDark.withValues(alpha: 1) )),
                      ),
                    ),
                  ],
                ),

                Spacer(flex: 5,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.fromLTRB(15,0,0,0),
                      child: SizedBox(
                        width: size.width/2-50,
                        child: Text(visibilityDescription,overflow: TextOverflow.ellipsis,maxLines: 2,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 15,height:1.2,color: Theme.of(context).primaryColorDark.withValues(alpha: 1))),
                      ),
                    ),
                  ],
                ),
                Spacer(flex: 4,),
              ],
            ),

          ),
        ),
      ),
    );
  }
}

class AverageWidget extends StatelessWidget {
  final String averageTemp;
  final String averageVisibility;
  final String averageHumidity;

  const AverageWidget({
    super.key,
    required this.averageTemp,
    required this.averageVisibility,
    required this.averageHumidity,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,0,5,0),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 13.0, sigmaY: 13.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFD7D1D1).withValues(alpha: 0.18),
              borderRadius: const BorderRadius.all( Radius.circular(16.0)),
              border: Border.all(color: Theme.of(context).primaryColorDark.withValues(alpha: 0.3), width: 0.3,),
            ),
            height: size.width/2-25,
            width: size.width/2-25,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(flex: 1,),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Padding(
                        padding: const EdgeInsets.fromLTRB(14,0,7,0),
                        child: SizedBox(
                          height: 14,
                          width: 15,
                          child: SvgPicture.asset(
                            "assets/svg/sw_average.svg",
                            colorFilter: ColorFilter.mode(Theme.of(context).primaryColorDark.withValues(alpha: 0.7), BlendMode.srcIn),

                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Text("AVERAGES",
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 13,letterSpacing:-0.1,color: Theme.of(context).primaryColorDark.withValues(alpha: 0.7))),
                      ),
                    ],
                  ),
                ),
                Spacer(flex: 1,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15,0,0,0),
                  child: SizedBox(
                    width: size.width/2-50,
                    child: Row(
                      children: [
                        Text("Temp:",overflow: TextOverflow.ellipsis,maxLines: 1,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 15,height:1.2,color: Theme.of(context).primaryColorDark.withValues(alpha: 1))),
                         Spacer(),
                        Text("$averageTemp°",overflow: TextOverflow.ellipsis,maxLines: 1,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 15,height:1.2,color: Theme.of(context).primaryColorDark.withValues(alpha: 1))),
                      ],
                    ),
                  ),
                ),

                Spacer(flex: 1,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15,0,0,0),
                  child: SizedBox(
                    width: size.width/2-50,
                    child: Row(
                      children: [
                        Text("Humidity:",overflow: TextOverflow.ellipsis,maxLines: 1,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 15,height:1.2,color: Theme.of(context).primaryColorDark.withValues(alpha: 1))),
                        Spacer(),
                        Text("$averageHumidity%",overflow: TextOverflow.ellipsis,maxLines: 1,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 15,height:1.2,color: Theme.of(context).primaryColorDark.withValues(alpha: 1))),
                      ],
                    ),
                  ),
                ),

                Spacer(flex: 1,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15,0,0,0),
                  child: SizedBox(
                    width: size.width/2-50,
                    child: Row(
                      children: [
                        Text("Visibility:",overflow: TextOverflow.ellipsis,maxLines: 1,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 15,height:1.2,color: Theme.of(context).primaryColorDark.withValues(alpha: 1))),
                        Spacer(),
                        Text(averageVisibility,overflow: TextOverflow.ellipsis,maxLines: 1,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 15,height:1.2,color: Theme.of(context).primaryColorDark.withValues(alpha: 1))),
                      ],
                    ),
                  ),
                ),

                Spacer(flex: 2,),


              ],
            ),

          ),
        ),
      ),
    );
  }
}

class UvWidget extends StatelessWidget {
  final String uvIndex;
  final String uvLevel;
  final String uvRecommendation;
  const UvWidget({
    super.key,
    required this.uvIndex,
    required this.uvLevel,
    required this.uvRecommendation,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(5,0,20,0),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 13.0, sigmaY: 13.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFD7D1D1).withValues(alpha: 0.18),
              borderRadius: const BorderRadius.all( Radius.circular(16.0)),
              border: Border.all(color: Theme.of(context).primaryColorDark.withValues(alpha: 0.3), width: 0.3,),
            ),
            height: size.width/2-25,
            width: size.width/2-25,

            child: Column(
              children: [
                Spacer(flex: 1,),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Padding(
                        padding: const EdgeInsets.fromLTRB(14,0,7,0),
                        child: SizedBox(
                          height: 14,
                          width: 15,
                          child: SvgPicture.asset(
                            "assets/svg/sw_sun.svg",
                            colorFilter: ColorFilter.mode(Theme.of(context).primaryColorDark.withValues(alpha: 0.7), BlendMode.srcIn),

                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Text("UV INDEX",
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 13,letterSpacing:-0.1,color: Theme.of(context).primaryColorDark.withValues(alpha: 0.7))),
                      ),
                    ],
                  ),
                ),

                Spacer(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.fromLTRB(15,10,0,0),
                      child: SizedBox(
                        width: size.width/2-50,
                        child: Text(uvIndex,overflow: TextOverflow.ellipsis,maxLines: 1,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 37,color: Theme.of(context).primaryColorDark.withValues(alpha: 1) )),
                      ),
                    ),
                  ],
                ),

                Spacer(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.fromLTRB(15,0,0,0),
                      child: SizedBox(
                        width: size.width/2-50,
                        child: Text(uvLevel,overflow: TextOverflow.ellipsis,maxLines: 1,
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 20,letterSpacing:-0.1,color: Theme.of(context).primaryColorDark.withValues(alpha: 1))),
                      ),
                    ),
                  ],
                ),

                Spacer(flex: 3,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.fromLTRB(15,0,0,0),
                      child: SizedBox(
                        width: size.width/2-50,
                        child: Text(uvRecommendation,overflow: TextOverflow.ellipsis,maxLines: 3,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 13,height:1.2,color: Theme.of(context).primaryColorDark.withValues(alpha: 1))),
                      ),
                    ),
                  ],
                ),
                Spacer(flex: 3,),
              ],
            ),

          ),
        ),
      ),
    );
  }
}

class FeelsLikeWidget extends StatelessWidget {
  final String feelsLike;
  const FeelsLikeWidget({super.key, required this.feelsLike});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(5,0,20,0),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 13.0, sigmaY: 13.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFD7D1D1).withValues(alpha: 0.18),
              borderRadius: const BorderRadius.all( Radius.circular(16.0)),
              border: Border.all(color: Theme.of(context).primaryColorDark.withValues(alpha: 0.3), width: 0.3,),
            ),
            height: size.width/2-25,
            width: size.width/2-25,

            child: Column(
              children: [
                Spacer(flex: 1,),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Padding(
                        padding: const EdgeInsets.fromLTRB(14,0,7,0),
                        child: SizedBox(
                          height: 14,
                          width: 15,
                          child: SvgPicture.asset(
                            "assets/svg/sw_thermometer.svg",
                            colorFilter: ColorFilter.mode(Theme.of(context).primaryColorDark.withValues(alpha: 0.7), BlendMode.srcIn),

                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Text("FEELS LIKE",
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 13,letterSpacing:-0.1,color: Theme.of(context).primaryColorDark.withValues(alpha: 0.7))),
                      ),
                    ],
                  ),
                ),

                Spacer(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Padding(
                      padding: const EdgeInsets.fromLTRB(15,10,0,0),
                      child: SizedBox(
                        width: size.width/2-50,
                        child: Text("$feelsLike°",overflow: TextOverflow.ellipsis,maxLines: 1,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 48,color: Theme.of(context).primaryColorDark.withValues(alpha: 1) )),
                      ),
                    ),
                  ],
                ),

                Spacer(flex: 3,),
              ],
            ),

          ),
        ),
      ),
    );
  }
}

class WeatherViewLoadingWidget extends StatelessWidget {
  const WeatherViewLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 13.0, sigmaY: 13.0),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFFD7D1D1).withValues(alpha: 0.18),
          ),
          height: size.height,
          width: size.width,
          child:const Center(child: CupertinoActivityIndicator(radius: 18,color: Colors.white,)),
        ),
      ),
    );
  }
}


