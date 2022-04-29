// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CurrentDataAdapter extends TypeAdapter<CurrentData> {
  @override
  final int typeId = 0;

  @override
  CurrentData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurrentData(
      dt: fields[0] as int?,
      sunrise: fields[1] as int?,
      sunset: fields[2] as int?,
      temp: fields[3] as double?,
      feelsLike: fields[4] as double?,
      pressure: fields[5] as int?,
      humidity: fields[6] as int?,
      dewPoint: fields[7] as double?,
      uvi: fields[8] as int?,
      clouds: fields[9] as int?,
      visibility: fields[10] as int?,
      windSpeed: fields[11] as double?,
      windDeg: fields[12] as int?,
      weather: (fields[13] as List?)?.cast<Weather>(),
    );
  }

  @override
  void write(BinaryWriter writer, CurrentData obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.dt)
      ..writeByte(1)
      ..write(obj.sunrise)
      ..writeByte(2)
      ..write(obj.sunset)
      ..writeByte(3)
      ..write(obj.temp)
      ..writeByte(4)
      ..write(obj.feelsLike)
      ..writeByte(5)
      ..write(obj.pressure)
      ..writeByte(6)
      ..write(obj.humidity)
      ..writeByte(7)
      ..write(obj.dewPoint)
      ..writeByte(8)
      ..write(obj.uvi)
      ..writeByte(9)
      ..write(obj.clouds)
      ..writeByte(10)
      ..write(obj.visibility)
      ..writeByte(11)
      ..write(obj.windSpeed)
      ..writeByte(12)
      ..write(obj.windDeg)
      ..writeByte(13)
      ..write(obj.weather);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrentDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
