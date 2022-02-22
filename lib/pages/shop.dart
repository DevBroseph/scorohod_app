import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scorohod_app/objects/group.dart';
import 'package:scorohod_app/objects/product.dart';
import 'package:scorohod_app/objects/shop.dart';
import 'package:image/image.dart' as img;
import 'package:scorohod_app/pages/group.dart';
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
            foregroundColor: _color,
            title: Text(
              widget.shop.shopName,
              style: TextStyle(
                color: _color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                var group = _perrentGroups[index];

                return ListTile(
                  onTap: () => context.nextPage(
                    GroupPage(
                      perrent: group,
                      groups: _allGroups,
                      products: _products,
                      color: _color,
                    ),
                  ),
                  title: Text(group.name),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  ),
                  leading: group.groupImage.isNotEmpty
                      ? Image.memory(
                          base64Decode(group.groupImage),
                          width: 40,
                          height: 40,
                        )
                      : Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _color.withOpacity(0.1),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                        ),
                );
              },
              childCount: _perrentGroups.length,
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
