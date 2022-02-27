import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:scale_button/scale_button.dart';
import 'package:scorohod_app/objects/product.dart';
import 'package:scorohod_app/pages/group.dart';
import 'package:scorohod_app/services/constants.dart';
import 'package:scorohod_app/widgets/bottom_dialog_product_info.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    Key? key,
    required this.width,
    required this.item,
    required this.color,
  }) : super(key: key);

  final double width;
  final Product item;
  final Color color;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
      child: ScaleButton(
        duration: const Duration(milliseconds: 150),
        bound: 0.05,
        onTap: () {
          showMaterialModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) => ProductInfoBottomDialog(
              color: widget.color,
              product: widget.item,
            ),
          );
        },
        child: Container(
          width: (MediaQuery.of(context).size.width - 48) / 2,
          height: widget.width + 40,
          decoration: BoxDecoration(
            borderRadius: radius,
            boxShadow: shadow,
            color: Colors.white,
          ),
          child: Column(
            children: [
              Image.memory(
                base64Decode(widget.item.image),
                width: widget.width / 2,
                height: widget.width / 2,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.item.measure,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      Expanded(child: Container()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "100 ₽",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Container(
                            width: 30,
                            height: 30,
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                            decoration: BoxDecoration(
                              color: widget.color,
                              borderRadius: radius,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
