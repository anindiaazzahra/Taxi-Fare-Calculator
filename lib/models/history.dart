import 'package:hive/hive.dart';

part 'history.g.dart';

@HiveType(typeId: 3)
class History extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String email;

  @HiveField(2)
  List<CalculationResult> calculationResults;

  History({
    required this.email,
    required this.calculationResults,
  });
}

@HiveType(typeId: 4)
class CalculationResult extends HiveObject {
  @HiveField(0)
  int calculationId;

  @HiveField(1)
  String departureLocation;

  @HiveField(2)
  String arrivalLocation;

  @HiveField(3)
  String departureAddress;

  @HiveField(4)
  String arrivalAddress;

  @HiveField(5)
  int price;

  @HiveField(6)
  double distance;

  @HiveField(7)
  int duration;

  @HiveField(8)
  DateTime estimatedArrivalTime;

  CalculationResult({
    required this.calculationId,
    required this.departureLocation,
    required this.arrivalLocation,
    required this.departureAddress,
    required this.arrivalAddress,
    required this.price,
    required this.distance,
    required this.duration,
    required this.estimatedArrivalTime,
  });
}
