import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:scale_button/scale_button.dart';
import 'package:scorohod_app/bloc/orders_bloc/orders_bloc.dart';
import 'package:scorohod_app/bloc/orders_bloc/orders_state.dart';
import 'package:scorohod_app/pages/order.dart';
import 'package:scorohod_app/services/app_data.dart';
import 'package:scorohod_app/services/constants.dart';

class DeliverWidget extends StatefulWidget {
  final int price;
  final Color color;
  final Function() onTap;

  const DeliverWidget({
    Key? key,
    required this.price,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<DeliverWidget> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DataProvider>(context);
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        if (BlocProvider.of<OrdersBloc>(context).products.isEmpty) {
          return Container();
        } else {
          double sum = BlocProvider.of<OrdersBloc>(context).totalPrice;

          return Container(
            width: double.infinity,
            height: 100 + MediaQuery.of(context).padding.bottom,
            child: Column(
              children: [
                ScaleButton(
                  onTap: widget.onTap,
                  duration: const Duration(milliseconds: 150),
                  bound: 0.05,
                  child: Container(
                    height: 50,
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
                          "Оформить заказ",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            height: 1.2,
                            fontFamily: 'SFUI',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "${(sum + double.parse(provider.currentShop.shopPriceDelivery)).toStringAsFixed(2)} ₽",
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
