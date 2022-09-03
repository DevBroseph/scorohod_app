// To parse this JSON data, do
//
//     final cityCoordinates = cityCoordinatesFromJson(jsonString);

import 'dart:convert';

import 'package:scorohod_app/objects/coordinates.dart';

List<CityCoordinates> cityCoordinatesFromJson(String str) =>
    List<CityCoordinates>.from(
        json.decode(str).map((x) => CityCoordinates.fromJson(x)));

String cityCoordinatesToJson(List<CityCoordinates> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CityCoordinates {
  CityCoordinates({
    required this.coordinates,
  });

  Coordinates coordinates;

  factory CityCoordinates.fromJson(Map<String, dynamic> json) =>
      CityCoordinates(
        coordinates: coordinatesFromJson(json["city_lat_lng"]),
      );

  Map<String, dynamic> toJson() => {
        // "city_lat_lng": cityLatLng,
      };
}
