import 'dart:convert';

import 'package:scorohod_app/objects/coordinates.dart';

List<Shop> shopsFromJson(String str) =>
    List<Shop>.from(json.decode(str).map((x) => Shop.fromJson(x)));

String shopsToJson(List<Shop> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Shop shopFromJson(String str) => Shop.fromJson(json.decode(str));

String shopToJson(Shop data) => json.encode(data.toJson());

class Shop {
  Shop({
    required this.shopId,
    required this.shopName,
    required this.shopLogo,
    required this.categoryId,
    required this.shopDescription,
    required this.shopMinSum,
    required this.shopPriceDelivery,
    required this.shopWorkingHours,
    required this.shopStatus,
    required this.shopAddress,
    required this.coordinates,
    required this.city,
    required this.cityCoordinates,
  });

  String shopId;
  String shopName;
  String shopLogo;
  String categoryId;
  String shopDescription;
  String shopMinSum;
  String shopPriceDelivery;
  String shopWorkingHours;
  String shopStatus;
  String shopAddress;
  Coordinates coordinates;
  String city;
  Coordinates cityCoordinates;

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        shopId: json["shop_id"].toString(),
        shopName: json["shop_name"].toString(),
        shopLogo: json["shop_logo"].toString(),
        categoryId: json["category_id"].toString(),
        shopDescription: json["shop_description"].toString(),
        shopMinSum: json["shop_min_sum"].toString(),
        shopPriceDelivery: json["shop_price_delivery"].toString(),
        shopWorkingHours: json["shop_working_hours"].toString(),
        shopStatus: json["shop_status"],
        shopAddress: json['shop_address'] ?? '',
        coordinates: coordinatesFromJson(json['shop_lat_lng']),
        city: json['city'] ?? '',
        cityCoordinates: coordinatesFromJson(json['city_lat_lng']),
      );
  Map<String, dynamic> toJson() => {
        "shop_id": shopId,
        "shop_name": shopName,
        "shop_logo": shopLogo,
        "category_id": categoryId,
        "shop_description": shopDescription,
        "shop_min_sum": shopMinSum,
        "shop_price_delivery": shopPriceDelivery,
        "shop_working_hours": shopWorkingHours,
        "shop_status": shopStatus,
        "shop_address": shopAddress,
        "shop_lat_lng": coordinatesToJson(coordinates),
        "city": shopAddress,
        "cityCoordinates": coordinatesToJson(cityCoordinates),
      };
}
