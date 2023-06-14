import 'package:flutter/material.dart';
import 'package:barberini_weather/models/weather.dart';
import 'package:barberini_weather/utilities/constants.dart';
import 'package:barberini_weather/screens/city/city.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.locationWeather});

  // ignore: prefer_typing_uninitialized_variables
  final locationWeather;

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WeatherModel weather = WeatherModel();

  DateTime date = DateTime.now();

  late int temperature;
  late int temperatureMin;
  late int temperatureMax;
  late String weatherIcon;
  late String cityName;
  String dayName = DateFormat('EEEE').format(DateTime.now());
  late String weatherCondition;

  @override
  void initState() {
    super.initState();

    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        temperature = 0;
        temperatureMin = 0;
        temperatureMax = 0;
        weatherIcon = 'Error';
        cityName = '';
        weatherCondition = '';
        return;
      }

      var temp = weatherData['main']['temp'];
      temperature = temp.toInt();

      var tempMin = weatherData['main']['temp_min'];
      temperatureMin = tempMin.toInt();

      var tempMax = weatherData['main']['temp_max'];
      temperatureMax = tempMax.toInt();

      var condition = weatherData['weather'][0]['id'];
      weatherIcon = weather.getWeatherIcon(condition);

      cityName = weatherData['name'];

      weatherCondition = weatherData['weather'][0]['main'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: buildAppBar(),
        body: Container(
          alignment: Alignment.center,
          // constraints: BoxConstraints.expand(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    cityName,
                    style: kCityNameTextStyle,
                  ),
                  Text(
                    dayName,
                    style: kTimeTextStyle,
                  ),
                ],
              ),
              Image.asset(
                'images/$weatherIcon.png',
                height: 160,
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      '$temperature°',
                      style: kTemperatureTextStyle,
                    ),
                  ),
                  Text(
                    weatherCondition.toUpperCase(),
                    style: kConditionTextStyle,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'images/thermometer_low.png',
                    height: 50,
                  ),
                  Text(
                    '$temperatureMin°',
                    style: kSmallTemperatureTextStyle,
                  ),
                  Image.asset(
                    'images/thermometer_high.png',
                    height: 50,
                  ),
                  Text(
                    '$temperatureMax°',
                    style: kSmallTemperatureTextStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: IconButton(
        highlightColor: Colors.transparent,
        splashRadius: 27.5,
        icon: const Icon(
          Icons.near_me,
          color: Colors.white,
        ),
        onPressed: () async {
          var weatherData = await weather.getLocationWeather();
          updateUI(weatherData);
        },
      ),
      actions: <Widget>[
        IconButton(
          highlightColor: Colors.transparent,
          splashRadius: 27.5,
          icon: const Icon(
            Icons.my_location,
            color: Colors.white,
          ),
          onPressed: () async {
            var typedName = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const CityScreen();
                },
              ),
            );
            if (typedName != null) {
              var weatherData = await weather.getCityWeather(typedName);
              updateUI(weatherData);
            }
          },
        )
      ],
    );
  }
}
