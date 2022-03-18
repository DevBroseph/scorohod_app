import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:scorohod_app/objects/group.dart';
import 'package:scorohod_app/objects/product.dart';
import 'package:scorohod_app/services/constants.dart';
import 'package:scorohod_app/widgets/category.dart';
import 'package:scorohod_app/widgets/product_card.dart';
import 'package:scorohod_app/widgets/rect_getter.dart';

import '../widgets/home_menu.dart';

class SearchProductsPage extends StatefulWidget {
  const SearchProductsPage({
    Key? key,
    required this.close,
    required this.products,
    required this.groups,
    required this.color,
  }) : super(key: key);

  final Function() close;
  final List<Product> products;
  final List<Group> groups;
  final Color color;

  @override
  _SearchProductsPageState createState() => _SearchProductsPageState();
}

class _SearchProductsPageState extends State<SearchProductsPage> {
  List<Product> _searchedProduct = [];
  final _searchController = TextEditingController();

  final StreamController<List<Product>> _streamController =
      StreamController<List<Product>>();

  void _searchProduct() async {
    if (_searchController.text.isNotEmpty) {
      _streamController.sink.add(widget.products
          .where((element) => element.name
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList());
    } else {
      _streamController.sink.add(widget.products);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget buildItem(int index, double width) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: CategoryWidget(
          category: widget.groups[index],
          index: index,
          products: _searchedProduct,
          color: widget.color,
          width: width),
    );
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchProduct);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width / 2 - 22.5;

    return Scaffold(
      body: Stack(
        children: [
          // if (_searchedProduct.isEmpty)
          //   const Center(
          //     child: Text('К сожаление пока нет такого товара('),
          //   ),
          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                title: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Укажите название",
                    border: InputBorder.none,
                    labelStyle: TextStyle(
                      color: Colors.grey[900],
                      fontSize: 16,
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: widget.close,
                    icon: const Icon(
                      FontAwesomeIcons.timesCircle,
                      color: Colors.grey,
                      size: 20,
                    ),
                  )
                ],
              ),
              SliverToBoxAdapter(
                child: StreamBuilder<List<Product>>(
                  stream: _streamController.stream,
                  initialData: widget.products,
                  builder: (context, snapshot) =>
                      elements(width, snapshot.data!),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).padding.bottom * 7,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget elements(width, List<Product> products) {
    List<Widget> list = [];
    for (int i = 0; i < products.length; i = i + 2) {
      list.add(_twoElementsRow(i, width, products));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(children: list),
    );
  }

  Widget _twoElementsRow(int index, width, List<Product> products) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ProductCard(
          item: products[index],
          color: widget.color,
          width: width,
        ),
        if (index + 1 < products.length)
          ProductCard(
            item: products[index + 1],
            color: widget.color,
            width: width,
          ),
      ],
    );
  }
}
