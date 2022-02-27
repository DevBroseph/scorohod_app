import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scorohod_app/objects/group.dart';
import 'package:scorohod_app/objects/product.dart';
import 'package:scorohod_app/objects/shop.dart';
import 'package:image/image.dart' as img;
import 'package:scorohod_app/pages/group.dart';
import 'package:scorohod_app/pages/home.dart';
import 'package:scorohod_app/services/constants.dart';
import 'package:scorohod_app/services/extensions.dart';
import 'package:scorohod_app/services/network.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({
    Key? key,
    required this.shop,
  }) : super(key: key);

  final Shop shop;

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  var _color = const Color.fromARGB(255, 255, 255, 255);

  List<Group> _allGroups = [];
  List<Group> _perrentGroups = [];

  List<Product> _products = [];

  Future<void> _update() async {
    var result = await NetHandler(context).getGroups();
    var products = await NetHandler(context).getProducts();

    _allGroups = result ?? [];

    for (var item in _allGroups) {
      if (item.parentId == '0' && item.shopId == widget.shop.shopId) {
        _perrentGroups.add(item);
      }
    }

    setState(() {
      _products = products ?? [];
    });
  }

  int _abgrToArgb(int argbColor) {
    int r = (argbColor >> 16) & 0xFF;
    int b = argbColor & 0xFF;
    return (argbColor & 0xFF00FF00) | (b << 16) | r;
  }

  void _getColor() {
    List<int> values = base64Decode(widget.shop.shopLogo).buffer.asUint8List();
    var photo = img.decodeImage(values);

    if (photo == null) return;

    double px = 1.0;
    double py = 0.0;

    int pixel32 = photo.getPixelSafe(px.toInt(), py.toInt());
    int hex = _abgrToArgb(pixel32);

    setState(() {
      _color = Color(hex);
    });
  }

  @override
  void initState() {
    super.initState();
    _getColor();
  }

  @override
  Widget build(BuildContext context) {
    if (_allGroups.isEmpty) {
      _update();
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            // elevation: 0,
            foregroundColor: _color,
            // expandedHeight: 210,
            title: Text(
              widget.shop.shopName,
              style: TextStyle(
                fontSize: 16,
                color: _color,
              ),
            ),
            // flexibleSpace: FlexibleSpaceBar(
            //   // centerTitle: true,
            //   background: Padding(
            //     padding: const EdgeInsets.only(
            //         left: 15, right: 15, bottom: 15, top: 30),
            //     child: Align(
            //       alignment: Alignment.bottomCenter,
            //       child: Container(
            //         margin: EdgeInsets.only(top: 30),
            //         height: 120,
            //         decoration: BoxDecoration(
            //           borderRadius: radius,
            //           boxShadow: shadow,
            //           color: Colors.white,
            //         ),
            //         child: Stack(
            //           children: [
            //             Container(
            //               width: MediaQuery.of(context).size.width / 2,
            //               height: double.infinity,
            //               decoration: BoxDecoration(
            //                 color: _color,
            //                 borderRadius: const BorderRadius.only(
            //                   topLeft: Radius.circular(15),
            //                   topRight: Radius.circular(15),
            //                   bottomLeft: Radius.circular(15),
            //                   bottomRight: Radius.circular(150),
            //                 ),
            //               ),
            //             ),
            //             Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
            //                 children: [
            //                   Column(
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     children: [
            //                       Text(
            //                         'Время работы',
            //                         style: TextStyle(color: Colors.grey[300]),
            //                       ),
            //                       const SizedBox(
            //                         height: 15,
            //                       ),
            //                       const Text(
            //                         '08:00-21:00',
            //                         style: TextStyle(color: Colors.white),
            //                       )
            //                     ],
            //                   ),
            //                   Column(
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     children: [
            //                       Text(
            //                         'Доставка от',
            //                         style: TextStyle(color: Colors.grey[500]),
            //                       ),
            //                       const SizedBox(
            //                         height: 15,
            //                       ),
            //                       const Text('500р.')
            //                     ],
            //                   ),
            //                 ]),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            snap: false,
          ),
          if (_allGroups.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(left: 15, top: 15),
                child: Text(
                  'Категории',
                  style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          if (_allGroups.isNotEmpty)
            SliverPadding(
              padding: EdgeInsets.only(left: 7.5, right: 7.5),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  var group = _perrentGroups[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 7.5, horizontal: 7.5),
                    decoration: const BoxDecoration(
                      borderRadius: radius,
                    ),
                    height: 150.0,
                    child: Material(
                      color: Colors.grey[100],
                      borderRadius: radius,
                      child: InkWell(
                          hoverColor: _color.withOpacity(0.1),
                          highlightColor: _color.withOpacity(0.1),
                          splashColor: _color.withOpacity(0.1),
                          borderRadius: radius,
                          onTap: () => context.nextPage(
                                GroupPage(
                                  perrent: group,
                                  groups: _allGroups,
                                  products: _products,
                                  color: _color,
                                ),
                              ),
                          child: Stack(
                            children: [
                              if (_perrentGroups[index].groupImage != '')
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 9, bottom: 9, right: 9, top: 9),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Image.memory(
                                      base64Decode(
                                          _perrentGroups[index].groupImage),
                                      fit: BoxFit.scaleDown,
                                      width: group.name.length > 23 ? 45 : 55,
                                    ),
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 9, bottom: 9, right: 9),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    group.name,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              )
                            ],
                          )),
                    ),
                  );
                }, childCount: _perrentGroups.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
              ),
            ),
          if (_allGroups.isEmpty)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(top: 200),
                child: const Center(
                  child: CupertinoActivityIndicator(),
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            ),
          ),
        ],
      ),
    );
  }
}
