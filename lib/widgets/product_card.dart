import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:scale_button/scale_button.dart';
import 'package:scorohod_app/bloc/orders_bloc/orders_bloc.dart';
import 'package:scorohod_app/objects/product.dart';
import 'package:scorohod_app/services/constants.dart';
import 'package:scorohod_app/widgets/bottom_dialog_product_info.dart';

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
  StreamController<bool> _streamController = StreamController<bool>();

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

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<OrdersBloc>(context);

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
            ),
          );
        },
        child: Container(
          width: (MediaQuery.of(context).size.width - 48) / 2,
          height: widget.item.name.length < 25
              ? widget.width + 50
              : widget.width + 80,
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
                        // widget.item.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.item.measure,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      Expanded(child: Container()),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey[100]),
                        height: 35,
                        child: Stack(
                          children: [
                            Center(
                              child: Text(
                                widget.item.price
                                        .toInt()
                                        // .toStringAsFixed(2)
                                        .toString() +
                                    ' ₽',
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
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
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
