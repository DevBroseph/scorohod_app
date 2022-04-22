import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scale_button/scale_button.dart';
import 'package:scorohod_app/objects/order.dart';
import 'package:scorohod_app/objects/shop.dart';
import 'package:scorohod_app/pages/order_info.dart';
import 'package:scorohod_app/services/extensions.dart';
import 'package:image/image.dart' as img;
import '../services/constants.dart';

class OrderElementStatusCard extends StatelessWidget {
  const OrderElementStatusCard(
      {Key? key, required this.order, required this.shop})
      : super(key: key);

  final Order order;
  final Shop shop;

  img.Image? getShopLogo() {
    List<int> values = base64Decode(shop.shopLogo).buffer.asUint8List();
    var photo = img.decodeImage(values);
    return photo;
  }

  @override
  Widget build(BuildContext context) {
    return ScaleButton(
      duration: const Duration(milliseconds: 150),
      bound: 0.05,
      onTap: () {
        context.nextPage(
            OrderInfoPage(
              color: red,
              order: order,
              shop: shop,
            ),
            fullscreenDialog: true);
      },
      child: Container(
        // margin: const EdgeInsets.only(
        //   bottom: 1,
        // ),
        width: double.infinity,
        height: 110,
        // decoration: BoxDecoration(
        //   boxShadow: shadow,
        //   borderRadius: radius,
        //   color: Colors.white,
        // ),
        color: Colors.white,
        child: Stack(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                width: 80,
                height: 70,
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (order.products.length > 0)
                          Image.network(
                            order.products[0].image!,
                            width: 30,
                            height: 30,
                          ),
                        if (order.products.length > 1)
                          Image.network(
                            order.products[1].image!,
                            width: 30,
                            height: 30,
                          ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (order.products.length > 2)
                          Image.network(
                            order.products[2].image!,
                            width: 30,
                            height: 30,
                          ),
                        if (order.products.length > 3)
                          Image.network(
                            order.products[3].image!,
                            width: 30,
                            height: 30,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10, right: 15),
                child: Align(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 145,
                        child: Text(
                          getStatus(order.status),
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
                        DateFormat('dd.MM.yyyy в HH:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(order.date) * 1000),
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 15, top: 15),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      child: Image.memory(
                        base64Decode(shop.shopLogo),
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 15, bottom: 15),
                    child: Text(
                      order.totalPrice + ' ₽',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                )
              ],
            ),
            Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey[200],
            )
          ],
        ),
      ),
    );
  }
}
