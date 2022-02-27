import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:scale_button/scale_button.dart';
import 'package:scorohod_app/bloc/orders_bloc/orders_bloc.dart';
import 'package:scorohod_app/bloc/orders_bloc/orders_event.dart';
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
  int count = 1;

  @override
  Widget build(BuildContext context) {
    var bottom = MediaQuery.of(context).padding.bottom;

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
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.only(
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
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.black,
                          height: 1.2,
                          fontFamily: 'SFUI',
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // if (widget.product.image != '')
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
                                child: Image.memory(
                                  base64Decode(widget.product.image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.fromLTRB(15, 30, 15, 50),
                          decoration: BoxDecoration(
                              borderRadius: radius, color: Colors.white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 15, top: 15),
                                child: Text(
                                  'Описание',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              if (widget.product.description.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, left: 15, right: 15),
                                  child: Text(
                                    widget.product.description,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      height: 1.5,
                                      fontFamily: 'SFUI',
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
                              const Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(
                                  'Вес',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              if (widget.product.manufacturer.isNotEmpty)
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 10, 15, 0),
                                  child: Text(
                                    widget.product.measure,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      height: 1.5,
                                      fontFamily: 'SFUI',
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
                              const Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(
                                  'Производитель',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              if (widget.product.manufacturer.isNotEmpty)
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 10, 15, 15),
                                  child: Text(
                                    widget.product.manufacturer,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      height: 1.5,
                                      fontFamily: 'SFUI',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // if (widget.product.description.isNotEmpty)
                        //   Padding(
                        //     padding: const EdgeInsets.only(
                        //       top: 18.0,
                        //       left: 20,
                        //       right: 20,
                        //       bottom: 10,
                        //     ),
                        //     child: Text(
                        //       'Описание: ' + widget.product.description,
                        //       textAlign: TextAlign.start,
                        //       style: const TextStyle(
                        //         fontSize: 14,
                        //         color: Colors.black,
                        //         height: 1.5,
                        //         fontFamily: 'SFUI',
                        //         fontWeight: FontWeight.w400,
                        //       ),
                        //     ),
                        //   ),
                        // if (widget.product.manufacturer.isNotEmpty)
                        //   Padding(
                        //     padding: const EdgeInsets.only(
                        //       top: 18.0,
                        //       left: 20,
                        //       right: 20,
                        //       bottom: 200,
                        //     ),
                        //     child: Text(
                        //       'Производитель: ' + widget.product.manufacturer,
                        //       textAlign: TextAlign.start,
                        //       style: const TextStyle(
                        //         fontSize: 14,
                        //         color: Colors.black,
                        //         height: 1.5,
                        //         fontFamily: 'SFUI',
                        //         fontWeight: FontWeight.w400,
                        //       ),
                        //     ),
                        //   ),
                      ],
                    ),
                    // _sizes(),
                    // AddsInProductInfo(
                    //   options: widget.dish.options,
                    //   onChangeAdd: optionAdd,
                    //   onChangeDel: optionDel,
                    //   onChangeOne: optionOne,
                    // ),
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
                          ScaleButton(
                            duration: const Duration(milliseconds: 150),
                            bound: 0.05,
                            onTap: () {
                              if (count > 0) count--;
                              setState(() {});
                            },
                            child: Image.asset(
                              "assets/button_del_big.png",
                              height: 30,
                              width: 30,
                            ),
                          ),
                          SizedBox(
                            width: 36,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                count.toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  height: 1.2,
                                  fontFamily: 'SFUI',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          ScaleButton(
                            duration: const Duration(milliseconds: 150),
                            bound: 0.05,
                            onTap: () {
                              count++;
                              setState(() {});
                            },
                            child: AddColorButton(color: widget.color),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
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
                            if (count > 0) {
                              double totalPrice = 100;
                              for (var element
                                  in BlocProvider.of<OrdersBloc>(context)
                                      .products) {
                                totalPrice += 100 + 100;
                              }
                              BlocProvider.of<OrdersBloc>(context).add(
                                AddProduct(product: widget.product),
                              );
                              Navigator.of(context).pop();
                            }
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
                            child: Text(
                              "добавить к заказу".toUpperCase(),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                height: 1.2,
                                fontFamily: 'SFUI',
                                fontWeight: FontWeight.w700,
                              ),
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

  // Widget _sizes() {
  //   // var app = p.Provider.of<AppColor>(context);

  //   // if (widget.dish.size.length != 1) {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 23.0, bottom: 7.0),
  //     child: SingleChildScrollView(
  //       child: LimitedBox(
  //         maxWidth: 90,
  //         maxHeight: 90,
  //         child: ListView.separated(
  //           padding: const EdgeInsets.symmetric(horizontal: 20.0),
  //           scrollDirection: Axis.horizontal,
  //           shrinkWrap: true,
  //           primary: false,
  //           itemBuilder: (context, index) {
  //             return InkWell(
  //               onTap: () {
  //                 checkedSizeId = index;
  //                 setState(() {});
  //               },
  //               borderRadius: const BorderRadius.all(Radius.circular(14)),
  //               child: Padding(
  //                 padding: const EdgeInsets.symmetric(vertical: 5.0),
  //                 child: Container(
  //                   height: 82,
  //                   //width: double.infinity,
  //                   decoration: BoxDecoration(
  //                     // boxShadow: ContainerShadow().getShadowProduct(),
  //                     borderRadius: const BorderRadius.all(Radius.circular(14)),
  //                     color: checkedSizeId == index
  //                         ? Theme.of(context).primaryColor
  //                         : Colors.white,
  //                   ),
  //                   child: Center(
  //                     child: Padding(
  //                       padding: const EdgeInsets.symmetric(horizontal: 36.0),
  //                       child: Column(
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: [
  //                           Text(
  //                             // widget.product..toString() +
  //                             " 100p",
  //                             style: TextStyle(
  //                               fontSize: 15,
  //                               color: checkedSizeId == index
  //                                   ? Colors.white
  //                                   : Colors.black,
  //                               height: 1.2,
  //                               fontFamily: 'SFUI',
  //                               fontWeight: FontWeight.w700,
  //                             ),
  //                           ),
  //                           const SizedBox(height: 8),
  //                           Text(
  //                             widget.product.measure,
  //                             style: TextStyle(
  //                               fontSize: 13,
  //                               color: checkedSizeId == index
  //                                   ? Colors.white
  //                                   : Colors.black,
  //                               height: 1.2,
  //                               fontFamily: 'SFUI',
  //                               fontWeight: FontWeight.w600,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             );
  //           },
  //           separatorBuilder: (context, index) => const SizedBox(width: 12),
  //           itemCount: 1,
  //         ),
  //       ),
  //     ),
  //   );
  //   // } else {
  //   //   return const SizedBox(height: 28);
  //   // }
  // }
}
