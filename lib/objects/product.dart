import 'dart:convert';

List<Product> productsFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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
    required this.archive,
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
  String archive;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        nomenclatureId: json["nomenclature_id"] ?? '',
        itemNumber: json["item_number"] ?? '',
        name: json["name"] ?? '',
        shopId: json["shop_id"] ?? '',
        groupId: json["group_id"] ?? '',
        image: json["image"] ?? '',
        description: json["description"] ?? '',
        measure: json["measure"] ?? '',
        manufacturer: json["manufacturer"] ?? '',
        terms: json["terms"] ?? '',
        price: (int.tryParse(json['price'].toString()) ??
                double.parse(json['price'].toString()))
            .toDouble(),
        archive: json["archive"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "nomenclature_id": nomenclatureId,
        "item_number": itemNumber,
        "name": name,
        "shop_id": shopId,
        "group_id": groupId,
        "image": image,
        "description": description,
        "measure": measure,
        "manufacturer": manufacturer,
        "terms": terms,
        "price": price,
      };
}
