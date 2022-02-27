import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scorohod_app/bloc/orders_bloc/orders.dart';
import 'package:scorohod_app/objects/product.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  List<Product> products = [];
  double totalPrice = 0;
  int orderId = 0;

  OrdersBloc() : super(OrderIdle());

  @override
  Stream<OrdersState> mapEventToState(
    OrdersEvent event,
  ) async* {
    if (event is AddProduct) {
      yield OrderLoading();

      if (products
          .where((element) =>
              element.nomenclatureId == event.product.nomenclatureId)
          .toList()
          .isNotEmpty) {
        // products
        //     .where((element) =>
        //         element.nomenclatureId == event.product.nomenclatureId)
        //     .toList()
        //     .first
        //     .itemNumber += event.product.itemNumber;
        products.add(event.product);
      } else {
        products.add(event.product);
      }
      totalPrice = 0;
      for (var element in products) {
        totalPrice += 100;
      }
      yield OrderIdle();
    }

    if (event is EditProduct) {
      yield OrderLoading();

      products.removeAt(event.index);
      products.insert(event.index, event.product);

      totalPrice = 0;
      for (var element in products) {
        totalPrice += 100 * int.parse(element.itemNumber);
      }
      yield OrderIdle();
    }

    if (event is RemoveProductFromHomePage) {
      yield OrderLoading();
      var currentProduct = event.product;

      if (products.isNotEmpty &&
          int.parse(products.last.itemNumber) > 1 &&
          products.contains(currentProduct)) {
        products.firstWhere((element) =>
            element.nomenclatureId == currentProduct.nomenclatureId);
      } else {
        products.remove(currentProduct);
      }

      totalPrice = 0;

      for (var element in products) {
        totalPrice += 100 * int.parse(element.itemNumber);
      }

      yield OrderIdle();
    }
  }
}
