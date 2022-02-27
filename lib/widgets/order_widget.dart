import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scale_button/scale_button.dart';
import 'package:scorohod_app/bloc/orders_bloc/orders_bloc.dart';
import 'package:scorohod_app/bloc/orders_bloc/orders_state.dart';
import 'package:scorohod_app/pages/basket.dart';
import 'package:scorohod_app/services/constants.dart';

class OrderWidget extends StatefulWidget {
  final int price;
  final Color color;

  const OrderWidget({
    Key? key,
    required this.price,
    required this.color,
  }) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<OrderWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        if (BlocProvider.of<OrdersBloc>(context).products.isEmpty) {
          return Container();
        } else {
          double sum = BlocProvider.of<OrdersBloc>(context).totalPrice;

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: shadow,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            width: double.infinity,
            height: 85 + MediaQuery.of(context).padding.bottom,
            child: Column(
              children: [
                ScaleButton(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BasketPage(
                          color: widget.color,
                        ),
                      ),
                    );
                  },
                  duration: const Duration(milliseconds: 150),
                  bound: 0.05,
                  child: Container(
                    height: 45,
                    margin: const EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      color: widget.color,
                      boxShadow: shadow,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "В корзину",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            height: 1.2,
                            fontFamily: 'SFUI',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "${sum.toStringAsFixed(2)} ₽",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            height: 1.2,
                            fontFamily: 'SFUI',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
