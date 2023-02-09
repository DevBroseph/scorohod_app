import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:scale_button/scale_button.dart';
import 'package:scorohod_app/bloc/orders_bloc/orders.dart';
import 'package:scorohod_app/objects/order_element.dart';
import 'package:scorohod_app/objects/product.dart';
import 'package:scorohod_app/services/constants.dart';
import 'package:scorohod_app/widgets/bottom_dialog_product_info.dart';

import 'button.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    Key? key,
    required this.width,
    required this.item,
    required this.color,
  }) : super(key: key);

  final double width;
  final Product item;
  final Color color;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isTake = false;
  bool wasAdded = false;
  int quantity = 0;
  StreamController<bool> _streamController = StreamController<bool>();
  StreamController<int> _countStreamController = StreamController<int>();

  void getVisibility(OrdersBloc bloc) {
    if (bloc.products
        .where((element) => element.id == widget.item.nomenclatureId)
        .isNotEmpty) {
      _streamController.sink.add(bloc.products
              .firstWhere((element) => element.id == widget.item.nomenclatureId)
              .quantity >
          0);
    }
  }

  bool getId(OrdersBloc bloc, int id) {
    for (int i = 0; i < bloc.products.length; i++) {
      if (bloc.products[i].id == id && bloc.products[i].quantity > 0) {
        return true;
      }
    }
    return false;
  }

  int getQuantity(OrdersBloc bloc, int id) {
    for (int i = 0; i < bloc.products.length; i++) {
      if (bloc.products[i].id == id) {
        return bloc.products[i].quantity;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<OrdersBloc>(context);

    return BlocBuilder<OrdersBloc, OrdersState>(builder: (context, snapshot) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
        child: ScaleButton(
          duration: const Duration(milliseconds: 150),
          bound: 0.05,
          onTap: () {
            showMaterialModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) => ProductInfoBottomDialog(
                color: widget.color,
                product: widget.item,
                callBack: (value) {},
              ),
            );
          },
          child: Container(
            width: (MediaQuery.of(context).size.width - 48) / 2,
            height: widget.width + 85,
            decoration: BoxDecoration(
              borderRadius: radius,
              boxShadow: shadow,
              color: Colors.white,
            ),
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Image.network(
                      widget.item.image,
                      width: widget.width / 2,
                      height: widget.width / 2,
                    )),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.name.length < 51
                              ? widget.item.name
                              : widget.item.name.substring(0, 50) + '...',
                          maxLines: 4,
                          // widget.item.name,
                          style: GoogleFonts.rubik(
                              fontWeight: FontWeight.w500, fontSize: 15),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.item.measure,
                          style: GoogleFonts.rubik(
                            color: Colors.grey,
                          ),
                        ),
                        Expanded(child: Container()),
                        _addButton(bloc, context)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Container _addButton(OrdersBloc bloc, BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: !getId(bloc, int.parse(widget.item.nomenclatureId))
            ? Colors.grey[100]
            : Colors.white,
      ),
      height: 35,
      child: Stack(
        children: [
          Center(
            child: !getId(bloc, int.parse(widget.item.nomenclatureId))
                ? Text(
                    widget.item.price.toInt().toString() + ' ₽',
                    style: GoogleFonts.rubik(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ScaleButton(
                        duration: const Duration(milliseconds: 150),
                        bound: 0.05,
                        onTap: () {
                          if (getQuantity(
                                  bloc, int.parse(widget.item.nomenclatureId)) >
                              0) {
                            bloc.add(
                              AddProduct(
                                orderElement: OrderElement(
                                  id: int.parse(widget.item.nomenclatureId),
                                  basePrice: widget.item.price.toDouble(),
                                  quantity: getQuantity(
                                        bloc,
                                        int.parse(
                                          widget.item.nomenclatureId,
                                        ),
                                      ) -
                                      1,
                                  price: (getQuantity(
                                            bloc,
                                            int.parse(
                                              widget.item.nomenclatureId,
                                            ),
                                          ) -
                                          1) *
                                      widget.item.price,
                                  name: widget.item.name,
                                  weight: widget.item.measure,
                                  image: widget.item.image,
                                ),
                              ),
                            );
                          }
                          if (bloc.products
                                  .firstWhere((element) =>
                                      element.id.toString() ==
                                      widget.item.nomenclatureId)
                                  .quantity ==
                              0) {
                            bloc.products.removeWhere((element) =>
                                element.id.toString() ==
                                widget.item.nomenclatureId);
                          }
                        },
                        child: Image.asset(
                          "assets/button_del_big.png",
                          height: 30,
                          width: 30,
                        ),
                      ),
                      SizedBox(
                        width: 36,
                        child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: BlocBuilder<OrdersBloc, OrdersState>(
                                builder: (context, snapshot) {
                              return Text(
                                getQuantity(bloc,
                                        int.parse(widget.item.nomenclatureId))
                                    .toString(),
                                style: GoogleFonts.rubik(
                                  fontSize: 18,
                                  height: 1.2,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            })),
                      ),
                      ScaleButton(
                        duration: const Duration(milliseconds: 150),
                        bound: 0.05,
                        onTap: () {
                          var quantity = getQuantity(
                              bloc, int.parse(widget.item.nomenclatureId));
                          bloc.add(
                            AddProduct(
                                orderElement: OrderElement(
                                    id: int.parse(widget.item.nomenclatureId),
                                    basePrice: widget.item.price.toDouble(),
                                    quantity: quantity + 1,
                                    price: (quantity + 1) * widget.item.price,
                                    name: widget.item.name,
                                    weight: widget.item.measure,
                                    image: widget.item.image)),
                          );
                          double totalPrice = 0;
                          for (var element
                              in BlocProvider.of<OrdersBloc>(context)
                                  .products) {
                            totalPrice += getQuantity(bloc,
                                    int.parse(widget.item.nomenclatureId)) *
                                widget.item.price;
                          }
                        },
                        child: AddColorButton(color: widget.color),
                      ),
                    ],
                  ),
          ),
          StreamBuilder<bool>(
              stream: _streamController.stream,
              initialData: false,
              builder: (context, snapshot) {
                if (snapshot.data!) {
                  return Container(
                    alignment: Alignment.centerRight,
                    color: widget.color,
                    height: 10,
                    width: 10,
                  );
                } else {
                  return Container();
                }
              })
        ],
      ),
    );
  }
}
