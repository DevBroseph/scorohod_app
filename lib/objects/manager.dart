// To parse this JSON data, do
//
//     final manager = managerFromJson(jsonString);

import 'dart:convert';

Manager managerFromJson(String str) => Manager.fromJson(json.decode(str));

String managerToJson(Manager data) => json.encode(data.toJson());

class Manager {
  Manager({
    required this.managerId,
    required this.phone,
    required this.managerName,
  });

  String managerId;
  String phone;
  String managerName;

  factory Manager.fromJson(Map<String, dynamic> json) => Manager(
        managerId: json["manager_id"],
        phone: json["phone"],
        managerName: json["manager_name"],
      );

  Map<String, dynamic> toJson() => {
        "manager_id": managerId,
        "phone": phone,
        "manager_name": managerName,
      };
}
