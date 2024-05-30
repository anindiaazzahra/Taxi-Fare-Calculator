import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taxi_fare/models/history.dart';

import 'detail_history_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late String _email = '';
  late List<CalculationResult> calculationResults = [];
  late List<CalculationResult> filteredResults = []; // List for filtered results
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadHistories();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('user');
    if (user != null) {
      setState(() {
        _email = json.decode(user)['email'];
      });
      _loadHistories();
    }
  }

  Future<void> _loadHistories() async {
    final historyBox = await Hive.openBox<History>('historyBox');
    History? history = historyBox.get(_email);
    setState(() {
      calculationResults = history?.calculationResults.toList().reversed.toList() ?? [];
      filteredResults = calculationResults; // Initialize filtered results with all calculation results
    });
  }

  // Function to filter calculation results based on departure or arrival location
  void _filterResults(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredResults = calculationResults; // Reset filtered results when query is empty
      } else {
        filteredResults = calculationResults.where((result) =>
        result.departureLocation.toLowerCase().contains(query.toLowerCase()) ||
            result.arrivalLocation.toLowerCase().contains(query.toLowerCase())).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterResults,
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search by departure or arrival location...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredResults.length,
              itemBuilder: (context, index) {
                final result = filteredResults[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailHistoryScreen(
                          calculationResult: result,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${result.departureLocation} - ${result.arrivalLocation}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Price: \$${(result.price / 100).toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Distance: ${result.distance} km',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Duration: ${result.duration} min',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Estimated Arrival Time: ${result.estimatedArrivalTime.toLocal().toString().split(' ')[1].substring(0, 5)}',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
