import 'dart:convert';

List<Category> categoriesFromJson(String str) =>
    List<Category>.from(json.decode(str).map((x) => Category.fromJson(x)));

String categoriesToJson(List<Category> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  Category({
    required this.categoryId,
    required this.categoryName,
    required this.categoryDescription,
  });

  String categoryId;
  String categoryName;
  String categoryDescription;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        categoryId: json["category_id"].toString(),
        categoryName: json["category_name"].toString(),
        categoryDescription: json["category_description"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "category_name": categoryName,
        "category_description": categoryDescription,
      };
}
