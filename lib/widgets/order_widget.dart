import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scale_button/scale_button.dart';
import 'package:scorohod_app/bloc/orders_bloc/orders_bloc.dart';
import 'package:scorohod_app/bloc/orders_bloc/orders_state.dart';
import 'package:scorohod_app/pages/basket.dart';
import 'package:scorohod_app/services/app_data.dart';
import 'package:scorohod_app/services/constants.dart';
import 'package:scorohod_app/widgets/my_flushbar.dart';

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
    var provider = Provider.of<DataProvider>(context);
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        if (BlocProvider.of<OrdersBloc>(context).products.isEmpty) {
          return Container();
        } else {
          double sum = BlocProvider.of<OrdersBloc>(context).totalPrice;
          var shopMinSum =
              Provider.of<DataProvider>(context).currentShop.shopMinSum;

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
            height: 110 + MediaQuery.of(context).padding.bottom,
            child: Column(
              children: [
                ScaleButton(
                  onTap: () {
                    if (provider.user.address != '') {
                      if (sum < int.parse(shopMinSum)) {
                        MyFlushbar.showFlushbar(
                            context, 'Ошибка.', 'Недостаточная сумма.');
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => BasketPage(
                              color: widget.color,
                            ),
                          ),
                        );
                      }
                    } else {
                      MyFlushbar.showFlushbar(context, 'Внимание.',
                          'Необходимо указать адрес доставки.');
                    }
                  },
                  duration: const Duration(milliseconds: 150),
                  bound: 0.05,
                  child: Container(
                    height: 45,
                    margin: const EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      color: sum < int.parse(shopMinSum)
                          ? Colors.grey[400]
                          : widget.color,
                      boxShadow: shadow,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "В корзину",
                          style: GoogleFonts.rubik(
                            fontSize: 14,
                            color: Colors.white,
                            height: 1.2,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "${sum.toStringAsFixed(2)} ₽",
                          style: GoogleFonts.rubik(
                            fontSize: 14,
                            color: Colors.white,
                            height: 1.2,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  bottom: true,
                  top: false,
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'Минимальная сумма заказа: $shopMinSum₽',
                        style: GoogleFonts.rubik(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
