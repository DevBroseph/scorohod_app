import 'dart:convert';

import 'package:scorohod_app/objects/order.dart';

String ordersElementsToJson(List<OrderElement> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<OrderElement> ordersElementFromJson(String str) => List<OrderElement>.from(
    json.decode(str).map((x) => OrderElement.fromJson(x)));

class OrderElement {
  OrderElement({
    required this.id,
    required this.quantity,
    required this.price,
    required this.basePrice,
    required this.weight,
    required this.image,
    required this.name,
  });

  int id;
  int quantity;
  double price;
  double basePrice;
  String weight;
  String? image;
  String name;

  factory OrderElement.fromJson(Map<String, dynamic> json) => OrderElement(
        id: json["id"],
        quantity: json["quantity"],
        price: double.tryParse(json["price"].toString()) ?? 1.0,
        basePrice: double.parse(json["basePrice"].toString()),
        weight: json["weight"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "quantity": quantity,
        "price": price,
        "weight": weight,
        "name": name,
        "basePrice": basePrice,
        "image": image,
      };
}
