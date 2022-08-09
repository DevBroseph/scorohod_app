// To parse this JSON data, do
//
//     final courierLocation = courierLocationFromJson(jsonString);

import 'dart:convert';

import 'package:scorohod_app/objects/coordinates.dart';
import 'package:scorohod_app/objects/order.dart';

CourierLocation courierLocationFromJson(String str) =>
    CourierLocation.fromJson(json.decode(str));

String courierLocationToJson(CourierLocation data) =>
    json.encode(data.toJson());

class CourierLocation {
  CourierLocation({
    required this.order,
    required this.courierLocation,
  });

  Order order;
  CourierLocationClass? courierLocation;

  factory CourierLocation.fromJson(Map<String, dynamic> json) =>
      CourierLocation(
        order: Order.fromJson(json["order"]),
        courierLocation: json["courier_location"] != null
            ? CourierLocationClass.fromJson(json["courier_location"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "order": order.toJson(),
        "courier_location": courierLocation?.toJson(),
      };
}

class CourierLocationClass {
  CourierLocationClass({
    required this.courierLocation,
  });

  Coordinates? courierLocation;

  factory CourierLocationClass.fromJson(Map<String, dynamic> json) =>
      CourierLocationClass(
        courierLocation: json['courier_location'] != null
            ? coordinatesFromJson(json['courier_location'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "courier_location": courierLocation,
      };
}
