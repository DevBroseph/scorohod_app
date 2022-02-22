import 'dart:convert';

List<Shop> shopsFromJson(String str) =>
    List<Shop>.from(json.decode(str).map((x) => Shop.fromJson(x)));

String shopsToJson(List<Shop> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Shop shopFromJson(String str) => Shop.fromJson(json.decode(str));

String shopToJson(Shop data) => json.encode(data.toJson());

class Shop {
  Shop({
    required this.shopId,
    required this.shopName,
    required this.shopLogo,
    required this.categoryId,
    required this.shopDescription,
    required this.shopMinSum,
    required this.shopPriceDelivery,
    required this.shopWorkingHours,
    required this.shopStatus,
  });

  String shopId;
  String shopName;
  String shopLogo;
  String categoryId;
  String shopDescription;
  String shopMinSum;
  String shopPriceDelivery;
  String shopWorkingHours;
  String shopStatus;

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
        shopId: json["shop_id"],
        shopName: json["shop_name"],
        shopLogo: json["shop_logo"],
        categoryId: json["category_id"],
        shopDescription: json["shop_description"],
        shopMinSum: json["shop_min_sum"],
        shopPriceDelivery: json["shop_price_delivery"],
        shopWorkingHours: json["shop_working_hours"],
        shopStatus: json["shop_status"],
      );

  Map<String, dynamic> toJson() => {
        "shop_id": shopId,
        "shop_name": shopName,
        "shop_logo": shopLogo,
        "category_id": categoryId,
        "shop_description": shopDescription,
        "shop_min_sum": shopMinSum,
        "shop_price_delivery": shopPriceDelivery,
        "shop_working_hours": shopWorkingHours,
        "shop_status": shopStatus,
      };
}
