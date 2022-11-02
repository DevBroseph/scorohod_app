import 'dart:convert';

String coordinatesToJson(Coordinates data) => json.encode(data.toJson());
Coordinates coordinatesFromJson(String str) =>
    Coordinates.fromJson(json.decode(str));

List<Coordinates> listOfCoordinatesFromJson(String str) =>
    List<Coordinates>.from(json.decode(str).map((x) => Coordinates.fromJson(x)));

class Coordinates {
  Coordinates({
    required this.latitude,
    required this.longitude,
  });

  double latitude;
  double longitude;

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
        latitude: json['latitude'] != null ? double.parse(json['latitude'].toString()) : 0.0,
        longitude: json['longitude'] != null ? double.parse(json['longitude'].toString()) : 0.0,
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
      };
}
