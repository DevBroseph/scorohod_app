import 'package:flutter/material.dart';
import 'package:scorohod_app/objects/order.dart';
import 'package:scorohod_app/objects/shop.dart';
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

  void getOrders() async {
    var result = await NetHandler(context).getOrders('test');
    var shops = await NetHandler(context).getShops();

    if (result != null) {
      setState(() {
        _orders = result.reversed.toList();
      });
    }
    if (shops != null) {
      setState(() {
        _shops = shops;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            pinned: true,
            // elevation: 0,
            foregroundColor: red,
            // expandedHeight: 210,
            title: Text(
              'Ваши заказы',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: red,
              ),
            ),
          ),
          if (_orders.isNotEmpty)
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index) => OrderElementStatusCard(
                          order: _orders[index],
                          shop: _shops.firstWhere((element) =>
                              element.shopId == _orders[index].shopId),
                        ),
                    childCount: _orders.length))
        ],
      ),
    );
  }
}
