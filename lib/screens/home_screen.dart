import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_fare/models/history.dart';
import 'package:taxi_fare/models/location_model.dart';
import 'package:taxi_fare/models/taxi_fare_model.dart';
import 'package:taxi_fare/screens/detail_history_screen.dart';
import 'package:taxi_fare/services/location_service.dart';
import 'package:taxi_fare/services/taxi_fare_service.dart';
import 'package:taxi_fare/utils/colors.dart';

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
  bool isLoading = false;
  final TextEditingController departureController = TextEditingController();
  final TextEditingController arrivalController = TextEditingController();
  final LocationService locationService = LocationService();
  final TaxiFareService taxiFareService = TaxiFareService();
  final _formKey = GlobalKey<FormState>(); // Form key for validation

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
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

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
    } finally {
      setState(() {
        isLoading = false;
      });
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

          departureController.clear();
          arrivalController.clear();
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
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: CircularProgressIndicator(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey, // Form key for validation
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'lib/assets/images/taxi-fare-calculation.png',
                    width: size.width * 0.7,
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Please provide both departure and arrival addresses. The fare will be calculated based on these locations using API service.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: departureController,
                    decoration: InputDecoration(
                      labelText: 'Departure Address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: primaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: primaryColor),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a departure address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: arrivalController,
                    decoration: InputDecoration(
                      labelText: 'Arrival Address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: primaryColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: primaryColor),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an arrival address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30.0),
                  ElevatedButton(
                    onPressed: getLocations,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: Size(size.width, 60),
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text(
                      "Get Calculation",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
