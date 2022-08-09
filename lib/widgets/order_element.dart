import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scorohod_app/objects/order_element.dart';

import '../services/constants.dart';

class OrderElementCard extends StatelessWidget {
  const OrderElementCard({Key? key, required this.orderElement})
      : super(key: key);

  final OrderElement orderElement;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
      width: double.infinity,
      height: 110,
      // color: Colors.white,
      decoration: BoxDecoration(
        boxShadow: shadow,
        borderRadius: radius,
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Image.network(
                orderElement.image!,
                width: 70,
                height: 70,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 10, right: 15),
              child: Align(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 145,
                      child: Text(
                        orderElement.name,
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
                      orderElement.weight,
                      style: GoogleFonts.rubik(color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            ),
          ]),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 15, bottom: 15),
              child: Text(
                '${orderElement.quantity} шт, ${orderElement.price} ₽',
                style: GoogleFonts.rubik(fontWeight: FontWeight.w400),
              ),
            ),
          ),
          // Container(
          //   width: double.infinity,
          //   height: 1,
          //   color: Colors.grey[200],
          // )
        ],
      ),
    );
  }
}
