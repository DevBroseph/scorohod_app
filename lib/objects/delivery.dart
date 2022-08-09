// To parse this JSON data, do
//
//     final courierLocation = courierLocationFromJson(jsonString);

import 'dart:convert';

DeliveryInfo deliveryInfoFromJson(String str) =>
    DeliveryInfo.fromJson(json.decode(str));

String deliveryInfoToJson(DeliveryInfo data) => json.encode(data.toJson());

class DeliveryInfo {
  DeliveryInfo({
    required this.id,
    required this.countrySum,
    required this.outsideSum,
    required this.settlementDate,
  });

  String id;
  String countrySum;
  String outsideSum;
  String settlementDate;

  factory DeliveryInfo.fromJson(Map<String, dynamic> json) => DeliveryInfo(
        id: json["id"],
        countrySum: json["country_sum"],
        outsideSum: json["outside_sum"],
        settlementDate: json["settlement_date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "country_sum": countrySum,
        "outside_sum": outsideSum,
        "settlement_date": settlementDate,
      };
}
