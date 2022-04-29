import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:weather_app/api.dart';
import 'package:weather_app/services/boxes.dart';
import 'package:weather_app/src/models/weather.dart';

import 'package:hive/hive.dart';
part 'hourly_data.g.dart';

@HiveType(typeId: 2)
class HourlyData {
  @HiveField(0)
  int? dt;
  @HiveField(1)
  double? temp;
  @HiveField(2)
  double? feelsLike;
  @HiveField(3)
  int? pressure;
  @HiveField(4)
  int? humidity;
  @HiveField(5)
  double? dewPoint;
  @HiveField(6)
  int? uvi;
  @HiveField(7)
  int? clouds;
  @HiveField(8)
  int? visibility;
  @HiveField(9)
  double? windSpeed;
  @HiveField(10)
  int? windDeg;
  @HiveField(11)
  double? windGust;
  @HiveField(12)
  List<Weather>? weather;
  @HiveField(13)
  int? pop;

  HourlyData(
      {this.dt,
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
      this.windGust,
      this.weather,
      this.pop});

  HourlyData.fromJson(Map<String, dynamic> json) {
    dt = json['dt'];
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
    windGust = json['wind_gust'];
    if (json['weather'] != null) {
      weather = <Weather>[];
      json['weather'].forEach((v) {
        weather!.add(new Weather.fromJson(v));
      });
    }
    pop = json['pop'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dt'] = this.dt;
    data['temp'] = this.temp;
    data['feels_like'] = this.feelsLike;
    data['pressure'] = this.pressure;
    data['humidity'] = this.humidity;
    data['dew_point'] = this.dewPoint;
    data['uvi'] = this.uvi;
    data['clouds'] = this.clouds;
    data['visibility'] = this.visibility;
    data['wind_speed'] = this.windSpeed;
    data['wind_deg'] = this.windDeg;
    data['wind_gust'] = this.windGust;
    if (this.weather != null) {
      data['weather'] = this.weather!.map((v) => v.toJson()).toList();
    }
    data['pop'] = this.pop;
    return data;
  }
}

class ListHourlyData {
  ApisService get service => GetIt.I<ApisService>();

  Future<List<HourlyData>> getHourlyWeatherData() async {
    List<HourlyData> listHourlyData = <HourlyData>[];

    if (kDebugMode) {
      print('Getting HOURLY Weather Data in Model');
    }

    dynamic res = await service.getWeatherData();

    if (res.statusCode == 200) {
      res.data['hourly'].forEach((value) {
        HourlyData hourlyData = HourlyData();
        hourlyData.dt = value['dt'];
        hourlyData.temp = value['temp'] + .0;
        hourlyData.windSpeed = value['wind_speed'] + .0;

        List<Weather> listW = <Weather>[];

        value['weather'].forEach((value) {
          Weather w = Weather();
          w.main = value['main'];
          w.icon = value['icon'];
          w.id = value['id'];
          w.description = value['description'];

          listW.add(w);
        });

        hourlyData.weather = listW;

        listHourlyData.add(hourlyData);
      });
    }

    final box = Boxes.getHourlyData();
    if (box.isEmpty) {
      int i = 0;
      for (var value in listHourlyData) {
        box.put(i, value);
        if (kDebugMode) {
          print('value: ${value} ; variable: ${i}');
          i++;
        }
      }
    }

    return listHourlyData;
  }
}
