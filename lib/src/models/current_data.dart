import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:weather_app/api.dart';
import 'package:weather_app/services/boxes.dart';
import 'package:weather_app/src/models/weather.dart';

import 'package:hive/hive.dart';
part 'current_data.g.dart';

@HiveType(typeId: 0)
class CurrentData extends HiveObject {
  @HiveField(0)
  int? dt;
  @HiveField(1)
  int? sunrise;
  @HiveField(2)
  int? sunset;
  @HiveField(3)
  double? temp;
  @HiveField(4)
  double? feelsLike;
  @HiveField(5)
  int? pressure;
  @HiveField(6)
  int? humidity;
  @HiveField(7)
  double? dewPoint;
  @HiveField(8)
  int? uvi;
  @HiveField(9)
  int? clouds;
  @HiveField(10)
  int? visibility;
  @HiveField(11)
  double? windSpeed;
  @HiveField(12)
  int? windDeg;
  @HiveField(13)
  List<Weather>? weather;

  CurrentData(
      {this.dt,
      this.sunrise,
      this.sunset,
      this.temp,
      this.feelsLike,
      this.pressure,
      this.humidity,
      this.dewPoint,
      this.uvi,
      this.clouds,
      this.visibility,
      this.windSpeed,
      this.windDeg,
      this.weather});

  CurrentData.fromJson(Map<String, dynamic> json) {
    dt = json['dt'];
    sunrise = json['sunrise'];
    sunset = json['sunset'];
    temp = json['temp'];
    feelsLike = json['feels_like'];
    pressure = json['pressure'];
    humidity = json['humidity'];
    dewPoint = json['dew_point'];
    uvi = json['uvi'];
    clouds = json['clouds'];
    visibility = json['visibility'];
    windSpeed = json['wind_speed'];
    windDeg = json['wind_deg'];
    if (json['weather'] != null) {
      weather = <Weather>[];
      json['weather'].forEach((v) {
        weather!.add(Weather.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dt'] = dt;
    data['sunrise'] = sunrise;
    data['sunset'] = sunset;
    data['temp'] = temp;
    data['feels_like'] = feelsLike;
    data['pressure'] = pressure;
    data['humidity'] = humidity;
    data['dew_point'] = dewPoint;
    data['uvi'] = uvi;
    data['clouds'] = clouds;
    data['visibility'] = visibility;
    data['wind_speed'] = windSpeed;
    data['wind_deg'] = windDeg;
    if (weather != null) {
      data['weather'] = weather!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CurrentWeatherData {
  ApisService get service => GetIt.I<ApisService>();

  Future<CurrentData> getCurrentWeatherData() async {
    CurrentData currentData = CurrentData();

    if (kDebugMode) {
      print('Getting CURRENT Weather Data in Model');
    }

    Response res = await service.getWeatherData();

    if (kDebugMode) {
      print('${res.statusCode.runtimeType} : ${res.statusCode}');
    }
    if (kDebugMode) {
      print('${res.data.runtimeType} : ${res.data['current']['dt']}');
    }

    if (res.statusCode == 200) {
      currentData.dt = res.data['current']['dt'];
      currentData.sunrise = res.data['current']['sunrise'];
      currentData.sunset = res.data['current']['sunset'];
      currentData.temp = res.data['current']['temp'];
      currentData.windSpeed = res.data['current']['wind_speed'];
      currentData.humidity = res.data['current']['humidity'];
      currentData.dewPoint = res.data['current']['dew_point'];

      List<Weather> listW = <Weather>[];
      res.data['current']['weather'].forEach((value) {
        Weather w = Weather();
        w.main = value['main'];
        w.icon = value['icon'];
        w.id = value['id'];
        w.description = value['description'];

        listW.add(w);
      });

      currentData.weather = listW;

      if (kDebugMode) {
        print('Weather is tru? : ${currentData.weather![0].main}');
      }
    }

    final box = Boxes.getCurrentData();

    box.put('0', currentData);

    List<CurrentData> dissect = <CurrentData>[];
    if (kDebugMode) {
      print('${box.runtimeType} : Current Box Opened');
      box.isEmpty
          ? print('No Value : Current Box Opened')
          : dissect = box.values.toList();
      print('${dissect.first.weather![0].main} : Current Data Get');
    }
    // box.add(currentData);

    return currentData;
  }
}
