// To parse this JSON data, do
//
//     final info = infoFromJson(jsonString);

import 'dart:convert';

Info infoFromJson(String str) => Info.fromJson(json.decode(str));

String infoToJson(Info data) => json.encode(data.toJson());

class Info {
  Info({
    required this.id,
    required this.deliveryAndPay,
    required this.deliveryPrice,
    required this.workTime,
    required this.otherConditions,
    required this.phone,
  });

  String id;
  String deliveryAndPay;
  String deliveryPrice;
  String workTime;
  String otherConditions;
  String phone;

  factory Info.fromJson(Map<String, dynamic> json) => Info(
        id: json["id"],
        deliveryAndPay: json["delivery_and_pay"],
        deliveryPrice: json["delivery_price"],
        workTime: json["work_time"],
        otherConditions: json["other_conditions"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "delivery_and_pay": deliveryAndPay,
        "delivery_price": deliveryPrice,
        "work_time": workTime,
        "other_conditions": otherConditions,
        "phone": phone,
      };
}
