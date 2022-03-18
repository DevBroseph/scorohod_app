import 'dart:convert';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  Order({
    required this.orderId,
    required this.date,
    required this.status,
    required this.products,
    required this.totalPrice,
    required this.clientId,
    required this.address,
    required this.discount,
    required this.receiptId,
    required this.shopId,
  });

  String orderId;
  String date;
  String status;
  String products;
  String totalPrice;
  String clientId;
  String address;
  String discount;
  String receiptId;
  String shopId;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderId: json["order_id"],
        date: json["date"],
        status: json["status"],
        products: json["products"],
        totalPrice: json["total_price"],
        clientId: json["client_id"],
        address: json["address"],
        discount: json["discount"],
        receiptId: json["receipt_id"],
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
