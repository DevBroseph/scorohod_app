// To parse this JSON data, do
//
//     final group = groupFromJson(jsonString);

import 'dart:convert';

List<Group> groupsFromJson(String str) =>
    List<Group>.from(json.decode(str).map((x) => Group.fromJson(x)));

Group groupFromJson(String str) => Group.fromJson(json.decode(str));

class Group {
  Group({
    required this.id,
    required this.name,
    required this.description,
    required this.parentId,
    required this.shopId,
    required this.groupImage,
  });

  String id;
  String name;
  String description;
  String parentId;
  String shopId;
  String groupImage;

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        parentId: json["parent_id"],
        shopId: json["shop_id"],
        groupImage: json["group_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "parent_id": parentId,
        "shop_id": shopId,
        "group_image": groupImage,
      };
}
