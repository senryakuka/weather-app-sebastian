import 'package:hive/hive.dart';
import 'package:weather_app/src/models/current_data.dart';
import 'package:weather_app/src/models/daily_data.dart';
import 'package:weather_app/src/models/hourly_data.dart';

class Boxes {
  static Box<CurrentData> getCurrentData() =>
      Hive.box<CurrentData>('current_datas');
  static Box<DailyData> getDailyData() => Hive.box<DailyData>('daily_datas');
  static Box<HourlyData> getHourlyData() =>
      Hive.box<HourlyData>('hourly_datas');
}
