// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.userId,
    required this.userName,
    required this.dateAuth,
    required this.phone,
    required this.token,
    required this.email,
    required this.uid,
    required this.os,
    required this.address,
    required this.room,
    required this.entrance,
    required this.floor,
  });

  String userId;
  String userName;
  String dateAuth;
  String phone;
  String token;
  String email;
  String uid;
  String os;
  String address;
  String room;
  String entrance;
  String floor;

  factory User.fromJson(Map<String, dynamic> json) => User(
        userId: json["user_id"],
        userName: json["user_name"],
        dateAuth: json["date_auth"],
        phone: json["phone"],
        token: json["token"],
        email: json["email"],
        uid: json["uid"],
        os: json["os"],
        address: json["address"],
        room: json["room"],
        entrance: json["entrance"],
        floor: json["floor"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_name": userName,
        "date_auth": dateAuth,
        "phone": phone,
        "token": token,
        "email": email,
        "uid": uid,
        "os": os,
      };
}
