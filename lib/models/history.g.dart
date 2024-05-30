// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HistoryAdapter extends TypeAdapter<History> {
  @override
  final int typeId = 3;

  @override
  History read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return History(
      email: fields[1] as String,
      calculationResults: (fields[2] as List).cast<CalculationResult>(),
    )..id = fields[0] as String?;
  }

  @override
  void write(BinaryWriter writer, History obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.calculationResults);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CalculationResultAdapter extends TypeAdapter<CalculationResult> {
  @override
  final int typeId = 4;

  @override
  CalculationResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalculationResult(
      calculationId: fields[0] as int,
      departureLocation: fields[1] as String,
      arrivalLocation: fields[2] as String,
      departureAddress: fields[3] as String,
      arrivalAddress: fields[4] as String,
      price: fields[5] as int,
      distance: fields[6] as double,
      duration: fields[7] as int,
      estimatedArrivalTime: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CalculationResult obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.calculationId)
      ..writeByte(1)
      ..write(obj.departureLocation)
      ..writeByte(2)
      ..write(obj.arrivalLocation)
      ..writeByte(3)
      ..write(obj.departureAddress)
      ..writeByte(4)
      ..write(obj.arrivalAddress)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.distance)
      ..writeByte(7)
      ..write(obj.duration)
      ..writeByte(8)
      ..write(obj.estimatedArrivalTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalculationResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
