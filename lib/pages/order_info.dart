import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scorohod_app/objects/order.dart';
import 'package:scorohod_app/objects/shop.dart';
import 'package:scorohod_app/widgets/order_element.dart';

class OrderInfoPage extends StatefulWidget {
  const OrderInfoPage({
    Key? key,
    required this.color,
    required this.order,
    required this.shop,
  }) : super(key: key);

  final Color color;
  final Order order;
  final Shop shop;

  @override
  State<OrderInfoPage> createState() => _OrderInfoPageState();
}

class _OrderInfoPageState extends State<OrderInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(physics: BouncingScrollPhysics(), slivers: [
        SliverAppBar(
          pinned: true,
          // elevation: 0,
          foregroundColor: widget.color,
          // expandedHeight: 210,
          title: Text(
            'Ваш заказ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: widget.color,
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
              (context, index) =>
                  OrderElementCard(orderElement: widget.order.products[index]),
              childCount: widget.order.products.length),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 20),
        ),
        SliverToBoxAdapter(
          child: Column(children: [
            Text(
              'Итого',
              style: TextStyle(fontSize: 15, color: Colors.grey[600]),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              widget.order.totalPrice + ' ₽',
              style: TextStyle(
                  color: Colors.grey[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            )
          ]),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 20),
        ),
        SliverToBoxAdapter(
          child: Column(children: [
            _bottomCard('Номер заказа', widget.order.orderId, height: 70),
            _bottomCard(
              'Дата заказа',
              DateFormat('dd.MM.yyyy в HH:mm').format(
                DateTime.fromMillisecondsSinceEpoch(
                    int.parse(widget.order.date) * 1000),
              ),
            ),
            _bottomCard(
              'Магазин',
              widget.shop.shopName,
            ),
            _bottomCard(
              'Адрес доставки',
              widget.order.address,
            ),
          ]),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 50),
        ),
      ]),
    );
  }

  Widget _bottomCard(String title, String subtitle, {double? height}) {
    return SizedBox(
      height: height ?? 80,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
              fontSize: 15),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            subtitle,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
