import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:scorohod_app/objects/group.dart';
import 'package:scorohod_app/objects/product.dart';
import 'package:scorohod_app/objects/shop.dart';
import 'package:image/image.dart' as img;
import 'package:scorohod_app/pages/group.dart';
import 'package:scorohod_app/pages/home.dart';
import 'package:scorohod_app/services/app_data.dart';
import 'package:scorohod_app/services/constants.dart';
import 'package:scorohod_app/services/extensions.dart';
import 'package:scorohod_app/services/network.dart';
import 'package:scorohod_app/widgets/group_card.dart';
import 'package:scorohod_app/widgets/order_widget.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({
    Key? key,
  }) : super(key: key);

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
      if (item.parentId == '0') {
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

  void _getColor(Shop shop) {
    List<int> values = base64Decode(shop.shopLogo).buffer.asUint8List();
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
  Widget build(BuildContext context) {
    var shop = Provider.of<DataProvider>(context);
    if (_allGroups.isEmpty) {
      _update();
      _getColor(shop.currentShop);
    }

    return Scaffold(
      body: Stack(
        children: [
          if (_allGroups.isEmpty)
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Align(
                alignment: Alignment.center,
                child: LoadingAnimationWidget.inkDrop(
                  color: _color,
                  size: 50,
                ),
              ),
            ),
          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                foregroundColor: _color,
                title: Text(
                  shop.currentShop.shopName,
                  style: TextStyle(
                      fontSize: 18, color: _color, fontWeight: FontWeight.bold),
                ),
                snap: false,
              ),
              if (_allGroups.isNotEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(left: 15, top: 15),
                    child: Text(
                      'Категории',
                      style:
                          TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              if (_allGroups.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.only(
                    left: 7.5,
                    right: 7.5,
                  ),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        var group = _perrentGroups[index];
                        return GroupCard(
                          color: _color,
                          group: group,
                          allGroups: _allGroups,
                          index: index,
                          products: _products,
                          perrentGroups: _perrentGroups,
                        );
                      },
                      childCount: _perrentGroups.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).padding.bottom + 100,
                ),
              ),
            ],
          ),
          if (_allGroups.isNotEmpty)
            Align(
              child: OrderWidget(price: 12, color: _color),
              alignment: Alignment.bottomCenter,
            ),
        ],
      ),
    );
  }
}
