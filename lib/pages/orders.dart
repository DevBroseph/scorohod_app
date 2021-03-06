import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:scorohod_app/objects/order.dart';
import 'package:scorohod_app/objects/shop.dart';
import 'package:scorohod_app/services/app_data.dart';
import 'package:scorohod_app/services/constants.dart';
import 'package:scorohod_app/services/network.dart';
import 'package:scorohod_app/widgets/order_element_status.dart';

class OrderStatusPage extends StatefulWidget {
  const OrderStatusPage({Key? key}) : super(key: key);

  @override
  State<OrderStatusPage> createState() => _OrderStatusPageState();
}

class _OrderStatusPageState extends State<OrderStatusPage> {
  List<Order> _orders = [];
  List<Shop> _shops = [];

  late Timer _timer;
  bool _empty = false;

  void getOrders() async {
    var userId = Provider.of<DataProvider>(context, listen: false).user.id;
    if (userId.isNotEmpty) {
      print(userId);
      var result = await NetHandler(context).getOrders(userId);
      var shops = await NetHandler(context).getShops();
      if (result != null) {
        if (result.isEmpty) {
          setState(() {
            _empty = true;
          });
        } else {
          if (!const IterableEquality().equals(_orders, result.reversed)) {
            setState(() {
              _orders = result.reversed.toList();
            });
          }
        }
      }
      if (shops != null) {
        setState(() {
          _shops = shops;
        });
      }
    } else {
      setState(() {
        _empty = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      getOrders();
    });
    getOrders();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: red,
        elevation: 0,
        title: const Text(
          '???????? ????????????',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: red,
          ),
        ),
      ),
      body: Stack(
        children: [
          if (_orders.isNotEmpty)
            CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (context, index) => OrderElementStatusCard(
                            order: _orders[index],
                            shop: _shops.firstWhere((element) =>
                                element.shopId == _orders[index].shopId),
                          ),
                      childCount: _orders.length),
                ),
              ],
            ),
          if (_orders.isEmpty && _empty == false)
            Container(
              margin: EdgeInsets.only(bottom: 50),
              height: MediaQuery.of(context).size.height,
              child: Align(
                alignment: Alignment.center,
                child: LoadingAnimationWidget.inkDrop(
                  color: Theme.of(context).primaryColor,
                  size: 50,
                ),
              ),
            ),
          if (_empty)
            const Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Center(
                child: Text('?????????????? ???????? ???? ??????.'),
              ),
            )
        ],
      ),
    );
  }
}
