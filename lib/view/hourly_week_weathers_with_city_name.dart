import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/bloc/daily_hourly_weather_bloc.dart';
import 'package:weather/convert/convert_temperature.dart';

class HourlyWeekWeathersWithCityName extends StatefulWidget {

  final String cityName;

  HourlyWeekWeathersWithCityName(this.cityName);

  @override
  _HourlyWeekWeathersWithCityNameState createState() => _HourlyWeekWeathersWithCityNameState(cityName);
}

class _HourlyWeekWeathersWithCityNameState extends State<HourlyWeekWeathersWithCityName> {

  final String cityName;
  var fm = new DateFormat('MM-dd – kk:mm');

  _HourlyWeekWeathersWithCityNameState(this.cityName);

  @override
  Widget build(BuildContext context) {

    final weatherBloc = BlocProvider.of<WeatherDetailsBloc>(context);
    weatherBloc.add(FetchWeathersDetailsWithCityName(cityName));

    return BlocBuilder<WeatherDetailsBloc, WeatherDetailsState>(builder: (context, state){
      if (state is WeatherDetailsLoadingState){
        return Center(child: CircularProgressIndicator());
      }else if (state is WeatherDetailsIsLoadedState) {

        var hourly = state.getWeather.list;

        return ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemCount: hourly.length - 20,
            itemBuilder: (context, index) {
              return SizedBox(
                width: MediaQuery.of(context).size.height / 10,
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height / 150),
                    Container(
                      width: MediaQuery.of(context).size.height / 12,
                      height: MediaQuery.of(context).size.height / 12,
                      child: Center(
                          child: SvgPicture.asset(
                            "assets/svgs/"+hourly[index].weather[0].icon+".svg", width: 40.0, cacheColorFilter: false,),
                      ),
                    ),
                    Text(
                      '${ConvertTemperature().fahrenheitToCelsius(hourly[index].main.temp)}°C',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 13),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 150),
                    Text('${DateFormat('h:m a').format( DateTime.fromMillisecondsSinceEpoch(hourly[index].dt* 1000))}', style: TextStyle(color: Colors.white,
                      fontSize: 13, fontWeight: FontWeight.w300),),
                  ],
                )
              );
            });
      } else if (state is WeatherDetailsIsNotLoadedState) {
        return Text(
          'City not Found',
          style: TextStyle(fontSize: 25, color: Colors.white),
        );
      } else
        return Text("",
            style: TextStyle(fontSize: 25, color: Colors.white));
    });
  }

  getLat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return double
    final lat = prefs.getDouble('lat') ?? null;
    return lat;
  }

  getLon() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return double
    final lon = prefs.getDouble('lon') ?? null;
    return lon;
  }
}


