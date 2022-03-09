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

  Map<String, dynamic> toJson() => {
        "id": id,
        "quantity": quantity,
      };
}
