import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:weather/bloc/cities_summery_container_bloc.dart';
import 'package:weather/bloc/daily_hourly_weather_bloc.dart';
import 'package:weather/bloc/weather_bloc.dart';
import 'package:weather/repositories/weather_repository.dart';
import 'package:weather/view/search_screen.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (BuildContext context) =>
                  WeatherBloc(WeatherRepository())),
          BlocProvider(
              create: (BuildContext context) =>
                  WeatherDetailsBloc(WeatherRepository())),
          BlocProvider(
              create: (BuildContext context) =>
                  CitiesWeathersSummeryBloc(WeatherRepository())),
        ],
        child: ScreenTypeLayout(
          breakpoints: ScreenBreakpoints(desktop: 900, tablet: 650, watch: 250),
          mobile: OrientationLayoutBuilder(
            portrait: (context) => SearchScreen(),
            landscape: (context) => SearchScreen(),
          ),
          tablet: SearchScreen(),
        )
      )
    );
  }
}


