class ExchangeRate {
  final String result;
  final String provider;
  final String documentation;
  final String termsOfUse;
  final int timeLastUpdateUnix;
  final String timeLastUpdateUtc;
  final int timeNextUpdateUnix;
  final String timeNextUpdateUtc;
  final int timeEolUnix;
  final String baseCode;
  final Map<String, double> rates;

  ExchangeRate({
    required this.result,
    required this.provider,
    required this.documentation,
    required this.termsOfUse,
    required this.timeLastUpdateUnix,
    required this.timeLastUpdateUtc,
    required this.timeNextUpdateUnix,
    required this.timeNextUpdateUtc,
    required this.timeEolUnix,
    required this.baseCode,
    required this.rates,
  });

  factory ExchangeRate.fromJson(Map<String, dynamic> json) {
    return ExchangeRate(
      result: json['result'],
      provider: json['provider'],
      documentation: json['documentation'],
      termsOfUse: json['terms_of_use'],
      timeLastUpdateUnix: json['time_last_update_unix'],
      timeLastUpdateUtc: json['time_last_update_utc'],
      timeNextUpdateUnix: json['time_next_update_unix'],
      timeNextUpdateUtc: json['time_next_update_utc'],
      timeEolUnix: json['time_eol_unix'],
      baseCode: json['base_code'],
      rates: Map<String, double>.from(json['rates']),
    );
  }
}
