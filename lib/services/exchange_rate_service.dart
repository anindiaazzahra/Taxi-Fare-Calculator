import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:taxi_fare/models/exchange_rate_model.dart';

class ExchangeRateService {
  static const String apiUrl = 'https://open.er-api.com/v6/latest/USD';

  Future<ExchangeRate?> fetchExchangeRates() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return ExchangeRate.fromJson(json);
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
