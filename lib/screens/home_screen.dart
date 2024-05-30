import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_fare/models/history.dart';
import 'package:taxi_fare/models/location_model.dart';
import 'package:taxi_fare/models/taxi_fare_model.dart';
import 'package:taxi_fare/screens/detail_history_screen.dart';
import 'package:taxi_fare/services/location_service.dart';
import 'package:taxi_fare/services/taxi_fare_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _email = '';
  Location? departureLocation;
  Location? arrivalLocation;
  TaxiFare? fare;
  DateTime? estimatedArrivalTime;
  final TextEditingController departureController = TextEditingController();
  final TextEditingController arrivalController = TextEditingController();
  final LocationService locationService = LocationService();
  final TaxiFareService taxiFareService = TaxiFareService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user');
    if (user != null) {
      setState(() {
        _email = json.decode(user)['email'];
      });
    }
  }

  void getLocations() async {
    try {
      final departureResult = await locationService.getLocation(departureController.text);
      final arrivalResult = await locationService.getLocation(arrivalController.text);

      setState(() {
        departureLocation = departureResult;
        arrivalLocation = arrivalResult;
      });

      if (departureResult == null || arrivalResult == null) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Location Not Found'),
              content: Text('Failed to find location data for the specified addresses. Please check the addresses and try again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        _calculateTaxiFare();
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to retrieve location data. Please try again later.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _calculateTaxiFare() async {
    if (departureLocation != null && arrivalLocation != null) {
      try {
        final result = await taxiFareService.getTaxiFare(
          departureLocation!.latitude,
          departureLocation!.longitude,
          arrivalLocation!.latitude,
          arrivalLocation!.longitude,
        );

        setState(() {
          fare = result;
          if (fare != null && fare!.duration != null) {
            estimatedArrivalTime = DateTime.now().add(Duration(minutes: fare!.duration));
          }
        });

        final historyBox = await Hive.openBox<History>('historyBox');
        History? history = historyBox.get(_email);
        if (history == null) {
          history = History(email: _email, calculationResults: []);
          historyBox.put(_email, history);
        }

        history?.calculationResults.add(CalculationResult(
          calculationId: historyBox.values.length + 1,
          departureLocation: departureController.text,
          arrivalLocation: arrivalController.text,
          departureAddress: departureLocation!.address,
          arrivalAddress: arrivalLocation!.address,
          price: fare!.fares[0].priceInCents ?? 0,
          distance: fare!.distance,
          duration: fare!.duration,
          estimatedArrivalTime: estimatedArrivalTime!,
        ));
        history?.save();

        if (history != null && history.calculationResults.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailHistoryScreen(
                calculationResult: history!.calculationResults.last,
              ),
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('No calculation results available.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to calculate taxi fare. Please try again later.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Taxi Fare Calculator',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: departureController,
                decoration: InputDecoration(
                  labelText: 'Departure Address',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: arrivalController,
                decoration: InputDecoration(
                  labelText: 'Arrival Address',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: getLocations,
                child: Text('Get Calculation'),
              ),
              SizedBox(height: 16.0),
              if (departureLocation != null && arrivalLocation != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Departure Location:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Latitude: ${departureLocation!.latitude}, Longitude: ${departureLocation!.longitude}, ${departureLocation!.address}',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Arrival Location:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Latitude: ${arrivalLocation!.latitude}, Longitude: ${arrivalLocation!.longitude},${arrivalLocation!.address}',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              if (fare != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Taxi Fare:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                      Text(
                        'Price: ${fare!.fares[0].priceInCents != null ? '\$${(fare!.fares[0].priceInCents! / 100).toStringAsFixed(2)}' : 'N/A'}',
                        style: TextStyle(fontSize: 14),
                      ),
                    Text(
                      'Distance: ${fare!.distance} km',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Duration: ${fare!.duration} min',
                      style: TextStyle(fontSize: 14),
                    ),
                    if (estimatedArrivalTime != null)
                      Text(
                        'Estimated Arrival Time: ${estimatedArrivalTime!.toLocal().toString().split(' ')[1].substring(0, 5)}',
                        style: TextStyle(fontSize: 14),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
