import 'dart:convert';

List<Product> productsFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

Product productFromJson(String str) => Product.fromJson(json.decode(str));

class Product {
  Product({
    required this.nomenclatureId,
    required this.itemNumber,
    required this.name,
    required this.shopId,
    required this.groupId,
    required this.image,
    required this.description,
    required this.measure,
    required this.manufacturer,
    required this.terms,
    required this.price,
  });

  String nomenclatureId;
  String itemNumber;
  String name;
  String shopId;
  String groupId;
  String image;
  String description;
  String measure;
  String manufacturer;
  String terms;
  double price;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        nomenclatureId: json["nomenclature_id"],
        itemNumber: json["item_number"],
        name: json["name"],
        shopId: json["shop_id"],
        groupId: json["group_id"],
        image: json["image"],
        description: json["description"],
        measure: json["measure"],
        manufacturer: json["manufacturer"],
        terms: json["terms"],
        price: (int.tryParse(json['price'].toString()) ??
                double.parse(json['price'].toString()))
            .toDouble(),
      );
}
