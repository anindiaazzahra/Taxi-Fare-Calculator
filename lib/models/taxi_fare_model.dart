class TaxiFare {
  final String cityName;
  final String departure;
  final String arrival;
  final int duration;
  final double distance;
  final List<Fare> fares;

  TaxiFare({
    required this.cityName,
    required this.departure,
    required this.arrival,
    required this.duration,
    required this.distance,
    required this.fares,
  });

  factory TaxiFare.fromJson(Map<String, dynamic> json) {
    var faresFromJson = json['fares'] as List;
    List<Fare> faresList = faresFromJson.map((i) => Fare.fromJson(i)).toList();

    return TaxiFare(
      cityName: json['city_name'],
      departure: json['department'],
      arrival: json['arrival'],
      duration: json['duration'],
      distance: json['distance'].toDouble(),
      fares: faresList,
    );
  }
}

class Fare {
  final String name;
  final int? priceInIDR;
  final int? priceInCents;
  final bool estimated;

  Fare({
    required this.name,
    this.priceInIDR,
    this.priceInCents,
    required this.estimated,
  });

  factory Fare.fromJson(Map<String, dynamic> json) {
    return Fare(
      name: json['name'],
      priceInIDR: json.containsKey('price_in_IDR') ? json['price_in_IDR'] : null,
      priceInCents: (json['price_in_cents'] != 'n/a') ? int.tryParse(json['price_in_cents'].toString()) : null,
      estimated: json['estimated'],
    );
  }
}
