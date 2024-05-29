import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:taxi_fare/models/location_model.dart';

class LocationService {
  final String apiKey = dotenv.env['API_KEY'] ?? '';
  static const String baseUrl = 'https://trueway-geocoding.p.rapidapi.com/Geocode';

  Future<Location?> getLocation(String address) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?address=$address'),
        headers: {
          'X-RapidAPI-Key': apiKey,
          'X-RapidAPI-Host': 'trueway-geocoding.p.rapidapi.com', // Ganti host menjadi trueway-geocoding
        },
      );

      if (response.statusCode == 200) {
        final body = response.body;
        final result = jsonDecode(body);

        if (result.containsKey('results') && result['results'] != null) {
          final List<dynamic> results = result['results'];

          if (results.isNotEmpty) {
            // Ambil lokasi pertama dari results
            final Map<String, dynamic> firstResult = results.first;

            // Ambil objek location yang berisi latitude dan longitude
            final Map<String, dynamic> location = firstResult['location'];

            final Location firstLocation = Location.fromJson(location);

            // Kembalikan lokasi pertama sebagai Location
            return firstLocation;
          }
        }
      }
      return null;
    } catch(e) {
      throw Exception(e.toString());
    }
  }
}
