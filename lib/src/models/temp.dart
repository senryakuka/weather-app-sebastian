import 'package:hive/hive.dart';
part 'temp.g.dart';

@HiveType(typeId: 4)
class Temp {
  @HiveField(0)
  double? day;
  @HiveField(1)
  double? min;
  @HiveField(2)
  double? max;
  @HiveField(3)
  double? night;
  @HiveField(4)
  double? eve;
  @HiveField(5)
  double? morn;

  Temp({this.day, this.min, this.max, this.night, this.eve, this.morn});

  Temp.fromJson(Map<String, dynamic> json) {
    day = json['day'];
    min = json['min'];
    max = json['max'];
    night = json['night'];
    eve = json['eve'];
    morn = json['morn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day'] = this.day;
    data['min'] = this.min;
    data['max'] = this.max;
    data['night'] = this.night;
    data['eve'] = this.eve;
    data['morn'] = this.morn;
    return data;
  }
}
