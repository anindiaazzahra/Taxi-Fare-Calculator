import 'package:flutter/material.dart';
import 'package:taxi_fare/models/history.dart';
import 'package:intl/intl.dart';

class DetailHistoryScreen extends StatefulWidget {
  final CalculationResult calculationResult;

  const DetailHistoryScreen({Key? key, required this.calculationResult}) : super(key: key);

  @override
  _DetailHistoryScreenState createState() => _DetailHistoryScreenState();
}

class _DetailHistoryScreenState extends State<DetailHistoryScreen> {
  String _selectedCurrency = 'USD';
  double _convertedPrice = 0.0;
  String _selectedTimeZone = 'WIB';

  final Map<String, double> _conversionRates = {
    "USD": 1,
    "IDR": 16192.774883,
    "EUR": 0.924428,
    "JPY": 157.486414,
    "GBP": 0.786339,
    "CAD": 1.369417,
    "AUD": 1.510388,
    "CHF": 0.913098,
    "CNY": 7.258892,
    "KRW": 1368.050661,
  };

  final Map<String, Duration> _timeZoneOffsets = {
    'WIB': Duration(hours: 0),
    'WITA': Duration(hours: 1),
    'WIT': Duration(hours: 2),
    'London': Duration(hours: -7), // Assuming WIB is GMT+7
  };

  @override
  void initState() {
    super.initState();
    _convertedPrice = widget.calculationResult.price / 100;
  }

  void _convertPrice() {
    setState(() {
      double rate = _conversionRates[_selectedCurrency]!;
      _convertedPrice = (widget.calculationResult.price / 100) * rate;
    });
  }

  DateTime _convertTimeZone(DateTime time, String timeZone) {
    Duration offset = _timeZoneOffsets[timeZone]!;
    return time.add(offset);
  }

  @override
  Widget build(BuildContext context) {
    DateTime arrivalTime = widget.calculationResult.estimatedArrivalTime;
    DateTime convertedArrivalTime = _convertTimeZone(arrivalTime, _selectedTimeZone);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DetailItem(title: 'Departure Location', value: '${widget.calculationResult.departureLocation} - ${widget.calculationResult.departureAddress}'),
              DetailItem(title: 'Arrival Location', value: '${widget.calculationResult.arrivalLocation} - ${widget.calculationResult.arrivalAddress}'),
              Row(
                children: [
                  Expanded(
                    child: DetailItem(
                      title: 'Price',
                      value: '$_selectedCurrency ${_convertedPrice.toStringAsFixed(2)}',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: DropdownButton<String>(
                      value: _selectedCurrency,
                      items: _conversionRates.keys.map((String currency) {
                        return DropdownMenuItem<String>(
                          value: currency,
                          child: Text(currency),
                        );
                      }).toList(),
                      onChanged: (String? newCurrency) {
                        setState(() {
                          _selectedCurrency = newCurrency!;
                          _convertPrice();
                        });
                      },
                    ),
                  ),
                ],
              ),
              DetailItem(title: 'Distance', value: '${widget.calculationResult.distance} km'),
              DetailItem(title: 'Duration', value: '${widget.calculationResult.duration} min'),
              Row(
                children: [
                  Expanded(
                    child: DetailItem(
                      title: 'Estimated Arrival Time',
                      value: DateFormat.Hm().format(convertedArrivalTime),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: DropdownButton<String>(
                      value: _selectedTimeZone,
                      items: _timeZoneOffsets.keys.map((String timeZone) {
                        return DropdownMenuItem<String>(
                          value: timeZone,
                          child: Text(timeZone),
                        );
                      }).toList(),
                      onChanged: (String? newTimeZone) {
                        setState(() {
                          _selectedTimeZone = newTimeZone!;
                        });
                      },
                    ),
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

class DetailItem extends StatelessWidget {
  final String title;
  final String value;

  const DetailItem({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
