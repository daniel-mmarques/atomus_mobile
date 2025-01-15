// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../ticker/ticker_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TickerDataAdapter extends TypeAdapter<TickerData> {
  @override
  final int typeId = 0;

  @override
  TickerData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TickerData(
      stock: fields[0] as String,
      name: fields[1] as String,
      close: fields[2] as double,
      change: fields[3] as double,
      volume: fields[4] as int,
      marketCap: fields[5] as double,
      logo: fields[6] as String,
      sector: fields[7] as String,
      type: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TickerData obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.stock)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.close)
      ..writeByte(3)
      ..write(obj.change)
      ..writeByte(4)
      ..write(obj.volume)
      ..writeByte(5)
      ..write(obj.marketCap)
      ..writeByte(6)
      ..write(obj.logo)
      ..writeByte(7)
      ..write(obj.sector)
      ..writeByte(8)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TickerDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
