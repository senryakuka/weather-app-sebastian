// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hourly_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HourlyDataAdapter extends TypeAdapter<HourlyData> {
  @override
  final int typeId = 2;

  @override
  HourlyData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HourlyData(
      dt: fields[0] as int?,
      temp: fields[1] as double?,
      feelsLike: fields[2] as double?,
      pressure: fields[3] as int?,
      humidity: fields[4] as int?,
      dewPoint: fields[5] as double?,
      uvi: fields[6] as int?,
      clouds: fields[7] as int?,
      visibility: fields[8] as int?,
      windSpeed: fields[9] as double?,
      windDeg: fields[10] as int?,
      windGust: fields[11] as double?,
      weather: (fields[12] as List?)?.cast<Weather>(),
      pop: fields[13] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, HourlyData obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.dt)
      ..writeByte(1)
      ..write(obj.temp)
      ..writeByte(2)
      ..write(obj.feelsLike)
      ..writeByte(3)
      ..write(obj.pressure)
      ..writeByte(4)
      ..write(obj.humidity)
      ..writeByte(5)
      ..write(obj.dewPoint)
      ..writeByte(6)
      ..write(obj.uvi)
      ..writeByte(7)
      ..write(obj.clouds)
      ..writeByte(8)
      ..write(obj.visibility)
      ..writeByte(9)
      ..write(obj.windSpeed)
      ..writeByte(10)
      ..write(obj.windDeg)
      ..writeByte(11)
      ..write(obj.windGust)
      ..writeByte(12)
      ..write(obj.weather)
      ..writeByte(13)
      ..write(obj.pop);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HourlyDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
