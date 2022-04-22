import 'dart:convert';

String coordinatesToJson(Coordinates data) => json.encode(data.toJson());
Coordinates coordinatesFromJson(String str) =>
    Coordinates.fromJson(json.decode(str));

class Coordinates {
  Coordinates({
    required this.latitude,
    required this.longitude,
  });

  double latitude;
  double longitude;

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
        latitude: json['latitude'],
        longitude: json['longitude'],
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}
