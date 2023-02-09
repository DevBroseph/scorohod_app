import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

List<UserAddress> addressesFromJson(String str) => List<UserAddress>.from(
    json.decode(str).map((x) => UserAddress.fromJson(x)));
String addressesToJson(List<UserAddress> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserAddress {
  String address;
  int? room;
  int? floor;
  int? entrance;
  String? description;
  bool selected;
  bool editing;
  LatLng? latLng;

  UserAddress(
    this.address,
    this.floor,
    this.entrance,
    this.room,
    this.description,
    this.selected,
    this.editing,
    this.latLng,
  );

  factory UserAddress.fromJson(Map<String, dynamic> json) => UserAddress(
        json["address"],
        json["floor"],
        json["entrance"],
        json["room"],
        json["description"],
        json["selected"],
        json["editing"],
        LatLng.fromJson(json["latLng"]),
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "room": room,
        "floor": floor,
        "entrance": entrance,
        "description": description,
        "selected": selected,
        "editing": editing,
        "latLng": latLng?.toJson(),
      };
}
