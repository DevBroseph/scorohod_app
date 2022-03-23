import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scale_button/scale_button.dart';
import 'package:scorohod_app/bloc/orders_bloc/orders_bloc.dart';
import 'package:scorohod_app/bloc/orders_bloc/orders_event.dart';
import 'package:scorohod_app/bloc/orders_bloc/orders_state.dart';
import 'package:scorohod_app/objects/order_element.dart';
import 'package:scorohod_app/services/app_data.dart';
import 'package:scorohod_app/services/constants.dart';
import 'package:scorohod_app/widgets/button.dart';
import 'package:scorohod_app/widgets/basket_widget.dart';

class BasketPage extends StatefulWidget {
  final Color color;
  const BasketPage({Key? key, required this.color}) : super(key: key);

  @override
  _BasketPageState createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  @override
  Widget build(BuildContext context) {
    var block = BlocProvider.of<OrdersBloc>(context);
    var provider = Provider.of<DataProvider>(context);
    if (block.products.isEmpty) {
      Timer(
          const Duration(milliseconds: 300), () => Navigator.maybePop(context));
    }

    void _removeAllFromBasket() async {
      final clickedButton = await FlutterPlatformAlert.showCustomAlert(
          windowTitle: 'Вы точно хотите очистить корзину?',
          text: '',
          positiveButtonTitle: 'Да',
          negativeButtonTitle: 'Нет',
          iconStyle: IconStyle.information,
          windowPosition: AlertWindowPosition.screenCenter);
      if (clickedButton == CustomButton.positiveButton) {
        BlocProvider.of<OrdersBloc>(context).add(RemoveProducts());
        Navigator.pop(context);
      }
    }

    return BlocBuilder<OrdersBloc, OrdersState>(builder: (context, snapshot) {
      return Scaffold(
        body: Stack(
          children: [
            CustomScrollView(physics: BouncingScrollPhysics(), slivers: [
              SliverAppBar(
                pinned: true,
                // elevation: 0,
                foregroundColor: widget.color,
                // expandedHeight: 210,
                title: Text(
                  'Корзина',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: widget.color,
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: IconButton(
                        onPressed: _removeAllFromBasket,
                        icon: const Icon(
                          FontAwesomeIcons.trashAlt,
                          size: 20,
                        )),
                  )
                ],
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 15,
                ),
              ),
              if (block.products.isNotEmpty)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (context, index) => basketCard(block, index),
                      childCount:
                          BlocProvider.of<OrdersBloc>(context).products.length),
                ),
              SliverToBoxAdapter(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: SizedBox(
                          width: 110,
                          child: Row(
                            children: const [
                              Text(
                                'Доставка',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.info_outline),
                            ],
                          ),
                        ),
                        trailing: Text(
                          provider.currentShop.shopPriceDelivery + ' ₽',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 130,
                ),
              ),
            ]),
            Align(
              child: BasketWidget(
                price: 12,
                color: widget.color,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              alignment: Alignment.bottomCenter,
            ),
          ],
        ),
      );
    });
  }

  Widget basketCard(OrdersBloc block, int index) {
    StreamController<int> _streamController = StreamController<int>();
    int count = block.products[index].quantity;

    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        BlocProvider.of<OrdersBloc>(context).add(
            RemoveProductFromBasketPage(orderElement: block.products[index]));
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
        width: double.infinity,
        height: 130,
        decoration: BoxDecoration(
          boxShadow: shadow,
          borderRadius: radius,
          color: Colors.white,
        ),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Image.network(
              block.products[index].image!,
              width: 70,
              height: 70,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 10),
            child: Align(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: 150,
                    child: Text(
                      block.products[index].name,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    block.products[index].weight,
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.grey[500]),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ScaleButton(
                          duration: const Duration(milliseconds: 150),
                          bound: 0.05,
                          onTap: () {
                            if (count > 1) {
                              _streamController.sink.add(--count);
                              BlocProvider.of<OrdersBloc>(context).add(
                                  AddProduct(
                                      orderElement: OrderElement(
                                          id: block.products[index].id,
                                          basePrice:
                                              block.products[index].basePrice,
                                          quantity: block
                                              .products[index].quantity -= 1,
                                          price: block.products[index].price -
                                              block.products[index].basePrice,
                                          name: block.products[index].name,
                                          weight: block.products[index].weight,
                                          image: block.products[index].image)));
                              // setState(() {});
                            } else {
                              BlocProvider.of<OrdersBloc>(context).add(
                                  RemoveProductFromBasketPage(
                                      orderElement: block.products[index]));
                              setState(() {});
                            }
                          },
                          child: Image.asset(
                            "assets/button_del_big.png",
                            height: 30,
                            width: 30,
                          ),
                        ),
                        StreamBuilder<int>(
                          stream: _streamController.stream,
                          initialData: count,
                          builder: ((context, snapshot) => SizedBox(
                                width: 36,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    snapshot.data.toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      height: 1.2,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )),
                        ),
                        ScaleButton(
                          duration: const Duration(milliseconds: 150),
                          bound: 0.05,
                          onTap: () {
                            // BlocProvider.of<OrdersBloc>(context)
                            //     .products[index]
                            //     .quantity++;
                            _streamController.sink.add(++count);
                            BlocProvider.of<OrdersBloc>(context).add(
                              AddProduct(
                                  orderElement: OrderElement(
                                      id: block.products[index].id,
                                      basePrice:
                                          block.products[index].basePrice,
                                      quantity:
                                          block.products[index].quantity += 1,
                                      price: block.products[index].price +
                                          block.products[index].basePrice,
                                      name: block.products[index].name,
                                      weight: block.products[index].weight,
                                      image: block.products[index].image)),
                            );
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
            width: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    BlocProvider.of<OrdersBloc>(context).add(
                        RemoveProductFromBasketPage(
                            orderElement: block.products[index]));
                    setState(() {});
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
                StreamBuilder(
                  stream: block.stream,
                  builder: ((context, snapshot) => Container(
                        margin: const EdgeInsets.only(bottom: 15, right: 15),
                        child: Text(
                          (block.products[index].basePrice * count).toString() +
                              ' ₽',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      )),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  // String getPrice(String price) {
  //   var newPrice = '';

  // }
}
