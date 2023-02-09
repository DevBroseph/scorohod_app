import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scorohod_app/objects/coordinates.dart';
import 'package:scorohod_app/objects/order_element.dart';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));
// LatLng latLngFromJson(String str) => LatLng.fromJson(json.decode(str))!;
List<Order> ordersFromJson(String str) =>
    List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String orderToJson(Order data) => json.encode(data.toJson());
String latLngToJson(LatLng data) => json.encode(data.toJson());

class Order {
  Order({
    required this.orderId,
    required this.date,
    required this.status,
    required this.products,
    required this.totalPrice,
    required this.clientId,
    required this.address,
    required this.userLatLng,
    required this.discount,
    required this.receiptId,
    required this.courierId,
    required this.shopId,
  });

  String orderId;
  String date;
  String status;
  List<OrderElement> products;
  String totalPrice;
  String clientId;
  String address;
  Coordinates userLatLng;
  String discount;
  String receiptId;
  String? courierId;
  String shopId;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderId: json["order_id"],
        date: json["date"] ?? '',
        status: json["status"],
        products: ordersElementFromJson(json["products"]),
        totalPrice: json["total_price"],
        clientId: json["client_id"],
        address: json["address"],
        userLatLng: coordinatesFromJson(json['user_lat_lng']),
        discount: json["discount"],
        receiptId: json["receipt_id"],
        courierId: json["courier_id"],
        shopId: json["shop_id"],
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "date": date,
        "status": status,
        "products": products,
        "total_price": totalPrice,
        "client_id": clientId,
        "address": address,
        "discount": discount,
        "receipt_id": receiptId,
        "shop_id": shopId,
      };
}
