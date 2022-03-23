import 'package:scorohod_app/objects/order_element.dart';
import 'package:scorohod_app/objects/product.dart';

abstract class OrdersEvent {}

class AddProduct extends OrdersEvent {
  final OrderElement orderElement;

  AddProduct({required this.orderElement});
}

class EditProduct extends OrdersEvent {
  final OrderElement orderElement;
  final int index;

  EditProduct({required this.orderElement, required this.index});
}

class RemoveProductFromBasketPage extends OrdersEvent {
  final OrderElement orderElement;

  RemoveProductFromBasketPage({
    required this.orderElement,
  });
}

class RemoveProductFromHomePage extends OrdersEvent {
  final Product product;

  RemoveProductFromHomePage({
    required this.product,
  });
}

class RemoveProducts extends OrdersEvent {}
