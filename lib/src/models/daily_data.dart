import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:weather_app/api.dart';
import 'package:weather_app/services/boxes.dart';
import 'package:weather_app/src/models/weather.dart';
import 'package:weather_app/src/models/temp.dart';
import 'package:weather_app/src/models/feels_like.dart';
import 'package:weather_app/src/models/current_data.dart';

import 'package:hive/hive.dart';
part 'daily_data.g.dart';

@HiveType(typeId: 1)
class DailyData {
  @HiveField(0)
  int? dt;
  @HiveField(1)
  int? sunrise;
  @HiveField(2)
  int? sunset;
  @HiveField(3)
  int? moonrise;
  @HiveField(4)
  int? moonset;
  @HiveField(5)
  double? moonPhase;
  @HiveField(6)
  Temp? temp;
  @HiveField(7)
  FeelsLike? feelsLike;
  @HiveField(8)
  int? pressure;
  @HiveField(9)
  int? humidity;
  @HiveField(10)
  double? dewPoint;
  @HiveField(11)
  double? windSpeed;
  @HiveField(12)
  int? windDeg;
  @HiveField(13)
  double? windGust;
  @HiveField(14)
  List<Weather>? weather;
  @HiveField(15)
  int? clouds;
  @HiveField(16)
  double? pop;
  @HiveField(17)
  double? uvi;
  @HiveField(18)
  double? rain;

  DailyData(
      {this.dt,
      this.sunrise,
      this.sunset,
      this.moonrise,
      this.moonset,
      this.moonPhase,
      this.temp,
      this.feelsLike,
      this.pressure,
      this.humidity,
      this.dewPoint,
      this.windSpeed,
      this.windDeg,
      this.windGust,
      this.weather,
      this.clouds,
      this.pop,
      this.uvi,
      this.rain});

  DailyData.fromJson(Map<String, dynamic> json) {
    dt = json['dt'];
    sunrise = json['sunrise'];
    sunset = json['sunset'];
    moonrise = json['moonrise'];
    moonset = json['moonset'];
    moonPhase = json['moon_phase'];
    temp = json['temp'] != null ? new Temp.fromJson(json['temp']) : null;
    feelsLike = json['feels_like'] != null
        ? new FeelsLike.fromJson(json['feels_like'])
        : null;
    pressure = json['pressure'];
    humidity = json['humidity'];
    dewPoint = json['dew_point'];
    windSpeed = json['wind_speed'];
    windDeg = json['wind_deg'];
    windGust = json['wind_gust'];
    if (json['weather'] != null) {
      weather = <Weather>[];
      json['weather'].forEach((v) {
        weather!.add(new Weather.fromJson(v));
      });
    }
    clouds = json['clouds'];
    pop = json['pop'];
    uvi = json['uvi'];
    rain = json['rain'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dt'] = this.dt;
    data['sunrise'] = this.sunrise;
    data['sunset'] = this.sunset;
    data['moonrise'] = this.moonrise;
    data['moonset'] = this.moonset;
    data['moon_phase'] = this.moonPhase;
    if (this.temp != null) {
      data['temp'] = this.temp!.toJson();
    }
    if (this.feelsLike != null) {
      data['feels_like'] = this.feelsLike!.toJson();
    }
    data['pressure'] = this.pressure;
    data['humidity'] = this.humidity;
    data['dew_point'] = this.dewPoint;
    data['wind_speed'] = this.windSpeed;
    data['wind_deg'] = this.windDeg;
    data['wind_gust'] = this.windGust;
    if (this.weather != null) {
      data['weather'] = this.weather!.map((v) => v.toJson()).toList();
    }
    data['clouds'] = this.clouds;
    data['pop'] = this.pop;
    data['uvi'] = this.uvi;
    data['rain'] = this.rain;
    return data;
  }
}

class ListDailyData {
  ApisService get service => GetIt.I<ApisService>();

  Future<List<DailyData>> getDailyWeatherData() async {
    List<DailyData> listDailyData = <DailyData>[];

    if (kDebugMode) {
      print('Getting HOURLY Weather Data in Model');
    }

    dynamic res = await service.getWeatherData();

    if (res.statusCode == 200) {
      res.data['daily'].forEach((value) {
        DailyData dailyData = DailyData();
        dailyData.dt = value['dt'];
        dailyData.humidity = value['humidity'];
        dailyData.dewPoint = value['dew_point'];

        Temp temp = Temp();
        temp.max = value['temp']['max'] + .0;
        temp.min = value['temp']['min'] + .0;

        dailyData.temp = temp;
        dailyData.windSpeed = value['wind_speed'];

        List<Weather> listW = <Weather>[];

        value['weather'].forEach((value) {
          Weather w = Weather();
          w.main = value['main'];
          w.icon = value['icon'];
          w.id = value['id'];
          w.description = value['description'];

          listW.add(w);
        });

        dailyData.weather = listW;

        listDailyData.add(dailyData);
      });
    }

    listDailyData.remove(listDailyData[0]);
    final box = Boxes.getDailyData();
    if (box.isEmpty) {
      int i = 0;
      for (var value in listDailyData) {
        box.put(i, value);
        if (kDebugMode) {
          print('value: ${value} ; variable: ${i}');
          i++;
        }
      }
    }

    if (kDebugMode) {
      print('${box.runtimeType} : Daily Box Opened');
      box.isEmpty
          ? print('No Value : No Data Get')
          : print('${box.values.toList()} : Daily Data Get');
    }

    return listDailyData;
  }
}
