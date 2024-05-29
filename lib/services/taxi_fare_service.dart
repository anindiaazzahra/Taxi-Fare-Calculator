import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:taxi_fare/models/taxi_fare_model.dart';

class TaxiFareService {
  final String apiKey = dotenv.env['API_KEY'] ?? '';
  static const String baseUrl = 'https://taxi-fare-calculator.p.rapidapi.com';

  Future<TaxiFare?> getTaxiFare(
      double departureLatitude,
      double departureLongitude,
      double arrivalLatitude,
      double arrivalLongitude,
      ) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/search-geo?dep_lat=$departureLatitude&dep_lng=$departureLongitude&arr_lat=$arrivalLatitude&arr_lng=$arrivalLongitude'),
        headers: {
          'X-RapidAPI-Key': apiKey,
          'X-RapidAPI-Host': 'taxi-fare-calculator.p.rapidapi.com',
        },
      );

      if (response.statusCode == 200) {
        final body = response.body;
        final result = jsonDecode(body);
        if (result.containsKey('journey') && result['journey'] != null) {
          print('halo2');
          final data = result['journey'];
          print(data);
          try {
            final TaxiFare taxiFare = TaxiFare.fromJson(data);
            print(taxiFare);
            return taxiFare;
          } catch (e) {
            print('Error while parsing TaxiFare: $e');
          }
        }
      } else {
        print('Failed to load taxi fare data: ${response.statusCode}');
      }
      return null;
    } catch (e) {
      print('Failed to connect to the server: $e');
      return null;
    }
  }
}
