import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scale_button/scale_button.dart';
import 'package:scorohod_app/bloc/orders_bloc/orders_bloc.dart';
import 'package:scorohod_app/bloc/orders_bloc/orders_event.dart';
import 'package:scorohod_app/objects/order_element.dart';
import 'package:scorohod_app/services/constants.dart';
import 'package:scorohod_app/widgets/button.dart';

class BasketCard extends StatefulWidget {
  final int index;
  final Color color;
  final OrderElement orderElement;
  final Function() onChanged;
  const BasketCard(
      {Key? key,
      required this.index,
      required this.color,
      required this.orderElement,
      required this.onChanged})
      : super(key: key);

  @override
  State<BasketCard> createState() => _BasketCardState();
}

class _BasketCardState extends State<BasketCard> {
  @override
  Widget build(BuildContext context) {
    var block = BlocProvider.of<OrdersBloc>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
      width: double.infinity,
      height: 110,
      decoration: BoxDecoration(
        boxShadow: shadow,
        borderRadius: radius,
        color: Colors.white,
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Image.memory(
            base64Decode(block.products[widget.index].image!),
            width: 70,
            height: 70,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 15),
          child: Align(
            // alignment: Alignment.topLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: 180,
                  child: Text(
                    block.products[widget.index].name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  block.products[widget.index].weight,
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.grey[500]),
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ScaleButton(
                        duration: const Duration(milliseconds: 150),
                        bound: 0.05,
                        onTap: () {
                          if (block.products[widget.index].quantity > 1) {
                            block.products[widget.index].quantity--;
                          } else {
                            BlocProvider.of<OrdersBloc>(context).add(
                                RemoveProductFromBasketPage(
                                    orderElement: widget.orderElement));
                          }
                          widget.onChanged;
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
                          child: Text(
                            block.products[widget.index].quantity.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              height: 1.2,
                              fontFamily: 'SFUI',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      ScaleButton(
                        duration: const Duration(milliseconds: 150),
                        bound: 0.05,
                        onTap: () {
                          block.products[widget.index].quantity++;
                          setState(() {});
                        },
                        child: AddColorButton(color: widget.color),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  print('true');
                  widget.onChanged;
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 15, right: 15),
                  child: Icon(
                    Icons.close,
                    size: 23,
                    color: Colors.grey[500],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15, right: 15),
                child: Text(
                  (block.products[widget.index].price *
                              block.products[widget.index].quantity)
                          .toInt()
                          .toString() +
                      ' ₽',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
