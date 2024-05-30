class Location {
  final double latitude;
  final double longitude;
  final String address;

  Location({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: json['location']['lat'] as double,
      longitude: json['location']['lng'] as double,
      address: json['address'] as String,
    );
  }
}
