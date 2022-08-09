import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:scale_button/scale_button.dart';
import 'package:scorohod_app/bloc/orders_bloc/orders_bloc.dart';
import 'package:scorohod_app/bloc/orders_bloc/orders_event.dart';
import 'package:scorohod_app/objects/order_element.dart';
import 'package:scorohod_app/objects/product.dart';
import 'package:scorohod_app/services/constants.dart';
import 'package:scorohod_app/widgets/button.dart';
import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';

class ProductInfoBottomDialog extends StatefulWidget {
  final Product product;
  final Color color;

  const ProductInfoBottomDialog({
    Key? key,
    required this.product,
    required this.color,
  }) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<ProductInfoBottomDialog> {
  int checkedSizeId = 0;
  int count = 0;
  bool countTrue = false;

  StreamController<int> _countStreamController = StreamController<int>();

  @override
  Widget build(BuildContext context) {
    var bottom = MediaQuery.of(context).padding.bottom;
    var block = BlocProvider.of<OrdersBloc>(context);

    if (count == 0) {
      if (block.products
          .where((element) => element.name == widget.product.name)
          .isNotEmpty) {
        _countStreamController.sink.add(count = block.products
            .firstWhere((element) => element.name == widget.product.name)
            .quantity);
        countTrue = true;
      }
    }

    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 12.0,
                  right: 12,
                  top: 32,
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Image.asset("assets/button_close.png", height: 31),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                padding: const EdgeInsets.only(bottom: 28.0, top: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20, left: 20),
                      child: Text(
                        widget.product.name,
                        style: GoogleFonts.rubik(
                          fontSize: 22,
                          color: Colors.black,
                          height: 1.2,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150,
                          margin: const EdgeInsets.only(
                            top: 18,
                            left: 15,
                            right: 15,
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            child: Center(
                              child: ZoomOverlay(
                                minScale: 0.5,
                                maxScale: 3.0,
                                twoTouchOnly: true,
                                child: Image.network(
                                  widget.product.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.fromLTRB(15, 30, 15, 50),
                          decoration: const BoxDecoration(
                              borderRadius: radius, color: Colors.white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 15, top: 15),
                                child: Text(
                                  'Описание',
                                  style: GoogleFonts.rubik(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              if (widget.product.description.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 15, right: 15),
                                  child: Text(
                                    widget.product.description,
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.rubik(
                                      fontSize: 15,
                                      color: Colors.black,
                                      height: 1.5,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              Container(
                                width: double.infinity,
                                height: 0.1,
                                color: Colors.grey[700],
                                margin: const EdgeInsets.all(15),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(
                                  'Единица измерения',
                                  style: GoogleFonts.rubik(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              if (widget.product.manufacturer.isNotEmpty)
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 10, 15, 0),
                                  child: Text(
                                    widget.product.measure,
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.rubik(
                                      fontSize: 15,
                                      color: Colors.black,
                                      height: 1.5,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              Container(
                                width: double.infinity,
                                height: 0.1,
                                color: Colors.grey[700],
                                margin: const EdgeInsets.all(15),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(
                                  'Производитель',
                                  style: GoogleFonts.rubik(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              if (widget.product.manufacturer.isNotEmpty)
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 10, 15, 0),
                                  child: Text(
                                    widget.product.manufacturer,
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.rubik(
                                      fontSize: 15,
                                      color: Colors.black,
                                      height: 1.5,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              Container(
                                width: double.infinity,
                                height: 0.1,
                                color: Colors.grey[700],
                                margin: const EdgeInsets.all(15),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  'Срок годности и условие хранения',
                                  style: GoogleFonts.rubik(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              if (widget.product.terms.isNotEmpty)
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 10, 15, 15),
                                  child: Text(
                                    widget.product.terms,
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.rubik(
                                      fontSize: 15,
                                      color: Colors.black,
                                      height: 1.5,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 66 + bottom),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: shadow,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            width: MediaQuery.of(context).size.width,
            height: 85 + bottom,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (countTrue == true)
                            ScaleButton(
                              duration: const Duration(milliseconds: 150),
                              bound: 0.05,
                              onTap: () {
                                // _countStreamController.stream.listen((event) {
                                if (count > 0) {
                                  _countStreamController.sink.add(--count);
                                  // count--;
                                }
                                // });
                              },
                              child: Image.asset(
                                "assets/button_del_big.png",
                                height: 30,
                                width: 30,
                              ),
                            ),
                          if (countTrue == true)
                            SizedBox(
                              width: 36,
                              child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: StreamBuilder<int>(
                                    stream: _countStreamController.stream,
                                    builder: (BuildContext buildContext,
                                        AsyncSnapshot<int> snapshop) {
                                      return Text(
                                        snapshop.data.toString(),
                                        style: GoogleFonts.rubik(
                                          fontSize: 18,
                                          height: 1.2,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      );
                                    },
                                  )),
                            ),
                          if (countTrue == true)
                            ScaleButton(
                              duration: const Duration(milliseconds: 150),
                              bound: 0.05,
                              onTap: () {
                                // count++;
                                _countStreamController.sink.add(++count);
                              },
                              child: AddColorButton(color: widget.color),
                            ),
                        ],
                      ),
                      if (countTrue == true) const SizedBox(width: 20),
                      Expanded(
                        child: ScaleButton(
                          duration: const Duration(milliseconds: 150),
                          bound: 0.05,
                          onTap: () {
                            // if (Utils.appData.settings.acceptOrdersBlocked) {
                            //   showMaterialModalBottomSheet(
                            //     backgroundColor: Colors.black.withOpacity(0.0),
                            //     context: context,
                            //     builder: (context) => SingleChildScrollView(
                            //       controller: ModalScrollController.of(context),
                            //       child: const OrderUnavailableBottomDialog(),
                            //     ),
                            //   );
                            // } else {
                            // if (count > 0) {
                            double totalPrice = 0;
                            for (var element
                                in BlocProvider.of<OrdersBloc>(context)
                                    .products) {
                              totalPrice += widget.product.price;
                            }
                            // if (block.products
                            //     .where((element) =>
                            //         element.name == widget.product.name)
                            //     .isNotEmpty) {
                            //   block.products
                            //       .firstWhere((element) =>
                            //           element.name == widget.product.name)
                            //       .quantity += count != 0 ? count : 1;
                            // } else {
                            BlocProvider.of<OrdersBloc>(context).add(
                              AddProduct(
                                  orderElement: OrderElement(
                                      id: int.parse(
                                          widget.product.nomenclatureId),
                                      basePrice:
                                          widget.product.price.toDouble(),
                                      quantity: count != 0 ? count : 1,
                                      price: (count != 0 ? count : 1) *
                                          widget.product.price,
                                      name: widget.product.name,
                                      weight: widget.product.measure,
                                      image: widget.product.image)),
                            );
                            // }
                            Navigator.of(context).pop();
                            // }
                            // }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(12),
                              ),
                              color: widget.color,
                              boxShadow: shadow,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Добавить ",
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  style: GoogleFonts.rubik(
                                    fontSize: 15,
                                    color: Colors.white,
                                    height: 1.2,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Icon(
                                  Icons.circle,
                                  color: Colors.white,
                                  size: 7,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  widget.product.price.toInt().toString() + '₽',
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  style: GoogleFonts.rubik(
                                    fontSize: 14,
                                    color: Colors.white,
                                    height: 1.2,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
