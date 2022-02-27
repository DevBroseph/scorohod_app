import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scorohod_app/main.dart';
import 'package:scorohod_app/objects/category.dart';
import 'package:scorohod_app/objects/shop.dart';
import 'package:scorohod_app/pages/search.dart';
import 'package:scorohod_app/pages/shop.dart';
import 'package:scorohod_app/services/extensions.dart';
import 'package:scorohod_app/services/network.dart';
import 'package:scorohod_app/widgets/home_menu.dart';
import 'package:scorohod_app/widgets/order_widget.dart';
import 'package:scorohod_app/widgets/shop_cell.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  var _address = "Укажите свой адрес";
  var _search = false;

  TabController? tabController;
  final List<Widget> _list = [];
  List<Shop> _shops = [];
  List<Category> _categories = [];

  Future<void> _update() async {
    var width = MediaQuery.of(context).size.width / 2 - 22.5;
    var result = await NetHandler(context).getShops();
    var categories = await NetHandler(context).getCategories();

    if (categories != null) {
      setState(() {
        _categories = categories;
      });
    }

    if (result == null) return;
    _shops = result;
    _list.clear();
    for (var item in result) {
      _list.add(
        ShopCell(
          shop: item,
          width: width,
          onTap: () => context.nextPage(
            ShopPage(
              shop: item,
            ),
          ),
        ),
      );
    }

    setState(() {
      tabController = TabController(
        length: _categories.length,
        vsync: this,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_list.isEmpty) {
      _update();
    }

    return Scaffold(
      drawer: const HomeMenu(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  // automaticallyImplyLeading: false,
                  elevation: 0,
                  title: GestureDetector(
                    onTap: () {
                      setState(() {
                        _search = true;
                      });
                    },
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        _address,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 15),
                ),
                if (tabController != null)
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    pinned: true,
                    backgroundColor:
                        Theme.of(context).appBarTheme.backgroundColor,
                    shadowColor: Colors.black.withOpacity(0.3),
                    toolbarHeight: Platform.isIOS ? 5 : 30,
                    flexibleSpace: TabBar(
                      isScrollable: true,
                      controller: tabController,
                      overlayColor: MaterialStateProperty.all(
                        Colors.transparent,
                      ),
                      indicatorPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey[700],
                      indicator: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(32),
                          ),
                          color: Colors.red),
                      tabs: _categories.map((e) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 10,
                          ),
                          child: Text(
                            e.categoryName,
                          ),
                        );
                      }).toList(),
                      onTap: (index) {
                        VerticalScrollableTabBarStatus.setIndex(index);
                      },
                    ),
                  ),
                // const SliverToBoxAdapter(
                //   child: SizedBox(height: 15),
                // ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "Продукты",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // const SliverToBoxAdapter(
                //   child: SizedBox(height: 15),
                // ),
                SliverFillRemaining(
                  child: Wrap(
                    runSpacing: 15,
                    children: _list,
                  ),
                ),
              ],
            ),
            if (_search)
              SearchPage(
                close: () {
                  setState(() {
                    _search = false;
                  });
                },
                onSelect: (address) {
                  debugPrint(address);
                  setState(() {
                    _search = false;
                    _address = address;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}

class VerticalScrollableTabBarStatus {
  static bool isOnTap = false;
  static int isOnTapIndex = 0;

  static void setIndex(int index) {
    VerticalScrollableTabBarStatus.isOnTap = true;
    VerticalScrollableTabBarStatus.isOnTapIndex = index;
  }
}
