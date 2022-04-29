// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyDataAdapter extends TypeAdapter<DailyData> {
  @override
  final int typeId = 1;

  @override
  DailyData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyData(
      dt: fields[0] as int?,
      sunrise: fields[1] as int?,
      sunset: fields[2] as int?,
      moonrise: fields[3] as int?,
      moonset: fields[4] as int?,
      moonPhase: fields[5] as double?,
      temp: fields[6] as Temp?,
      feelsLike: fields[7] as FeelsLike?,
      pressure: fields[8] as int?,
      humidity: fields[9] as int?,
      dewPoint: fields[10] as double?,
      windSpeed: fields[11] as double?,
      windDeg: fields[12] as int?,
      windGust: fields[13] as double?,
      weather: (fields[14] as List?)?.cast<Weather>(),
      clouds: fields[15] as int?,
      pop: fields[16] as double?,
      uvi: fields[17] as double?,
      rain: fields[18] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, DailyData obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.dt)
      ..writeByte(1)
      ..write(obj.sunrise)
      ..writeByte(2)
      ..write(obj.sunset)
      ..writeByte(3)
      ..write(obj.moonrise)
      ..writeByte(4)
      ..write(obj.moonset)
      ..writeByte(5)
      ..write(obj.moonPhase)
      ..writeByte(6)
      ..write(obj.temp)
      ..writeByte(7)
      ..write(obj.feelsLike)
      ..writeByte(8)
      ..write(obj.pressure)
      ..writeByte(9)
      ..write(obj.humidity)
      ..writeByte(10)
      ..write(obj.dewPoint)
      ..writeByte(11)
      ..write(obj.windSpeed)
      ..writeByte(12)
      ..write(obj.windDeg)
      ..writeByte(13)
      ..write(obj.windGust)
      ..writeByte(14)
      ..write(obj.weather)
      ..writeByte(15)
      ..write(obj.clouds)
      ..writeByte(16)
      ..write(obj.pop)
      ..writeByte(17)
      ..write(obj.uvi)
      ..writeByte(18)
      ..write(obj.rain);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
