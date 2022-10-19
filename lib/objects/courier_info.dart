// To parse this JSON data, do
//
//     final courierInfo = courierInfoFromJson(jsonString);

import 'dart:convert';

CourierInfo courierInfoFromJson(String str) => CourierInfo.fromJson(json.decode(str));

String courierInfoToJson(CourierInfo data) => json.encode(data.toJson());

class CourierInfo {
  CourierInfo({
    required this.courierId,
    required this.courierUid,
    required this.courierName,
    required this.courierEmail,
    required this.courierPassword,
    required this.courierPhone,
    required this.courierStatus,
    required this.courierToken,
    required this.courierLocation,
  });

  String courierId;
  String courierUid;
  String courierName;
  String courierEmail;
  String courierPassword;
  String courierPhone;
  String courierStatus;
  String courierToken;
  String courierLocation;

  factory CourierInfo.fromJson(Map<String, dynamic> json) => CourierInfo(
    courierId: json["courier_id"],
    courierUid: json["courier_uid"],
    courierName: json["courier_name"],
    courierEmail: json["courier_email"],
    courierPassword: json["courier_password"],
    courierPhone: json["courier_phone"],
    courierStatus: json["courier_status"],
    courierToken: json["courier_token"],
    courierLocation: json["courier_location"],
  );

  Map<String, dynamic> toJson() => {
    "courier_id": courierId,
    "courier_uid": courierUid,
    "courier_name": courierName,
    "courier_email": courierEmail,
    "courier_password": courierPassword,
    "courier_phone": courierPhone,
    "courier_status": courierStatus,
    "courier_token": courierToken,
    "courier_location": courierLocation,
  };
}
