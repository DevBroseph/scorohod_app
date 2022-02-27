import 'package:scorohod_app/objects/product.dart';

abstract class OrdersEvent {}

class AddProduct extends OrdersEvent {
  final Product product;

  AddProduct({required this.product});
}

class EditProduct extends OrdersEvent {
  final Product product;
  final int index;

  EditProduct({required this.product, required this.index});
}

// class RemoveProductFromBasketPage extends OrdersEvent {
//   final Product product;

//   RemoveProductFromBasketPage({
//     required this.product,
//   });
// }

class RemoveProductFromHomePage extends OrdersEvent {
  final Product product;

  RemoveProductFromHomePage({
    required this.product,
  });
}
