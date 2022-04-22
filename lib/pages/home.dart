import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:scorohod_app/bloc/orders_bloc/orders_bloc.dart';
import 'package:scorohod_app/bloc/orders_bloc/orders_event.dart';
import 'package:scorohod_app/main.dart';
import 'package:scorohod_app/objects/category.dart';
import 'package:scorohod_app/objects/shop.dart';
import 'package:scorohod_app/pages/search.dart';
import 'package:scorohod_app/pages/shop.dart';
import 'package:scorohod_app/services/app_data.dart';
import 'package:scorohod_app/services/constants.dart';
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
  final List<ShopCell> _list = [];
  List<Shop> _shops = [];
  List<Category> _categories = [];

  var _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _update(DataProvider provider, OrdersBloc bloc) async {
    var width = MediaQuery.of(context).size.width / 2 - 22.5;
    var result = await NetHandler(context).getShops();
    var categories = await NetHandler(context).getCategories();
    print(provider.user.latLng);
    setAddress(provider);

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
            onTap: () async {
              if (provider.currentShop != item && bloc.products.isNotEmpty) {
                final clickedButton =
                    await FlutterPlatformAlert.showCustomAlert(
                        windowTitle:
                            'Чтобы зайти в другой магазин необходимо очистить корзину.',
                        text: 'Очистить?',
                        positiveButtonTitle: 'Да',
                        negativeButtonTitle: 'Нет',
                        // alertStyle: AlertButtonStyle.yesNoCancel,
                        iconStyle: IconStyle.information,
                        windowPosition: AlertWindowPosition.screenCenter);
                if (clickedButton == CustomButton.positiveButton) {
                  BlocProvider.of<OrdersBloc>(context).add(RemoveProducts());
                  provider.setShop(item);
                  context.nextPage(
                    ShopPage(),
                  );
                }
              } else {
                provider.setShop(item);
                context.nextPage(
                  ShopPage(),
                );
              }
            }),
      );
    }

    setState(() {
      tabController = TabController(
        length: _categories.length,
        vsync: this,
      );
    });
  }

  void setAddress(DataProvider provider) {
    if (provider.user.address != '') {
      setState(() {
        _address = provider.user.address;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DataProvider>(context);
    var bloc = BlocProvider.of<OrdersBloc>(context);
    if (_list.isEmpty) {
      _update(provider, bloc);
    }

    if (provider.user.address != _address) {
      setAddress(provider);
    }

    return Scaffold(
      drawer: const HomeMenu(),
      key: _scaffoldKey,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                if (_categories.isNotEmpty)
                  SliverAppBar(
                    pinned: true,
                    elevation: 0,
                    leading: InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      onTap: () {
                        _scaffoldKey.currentState!.openDrawer();
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        padding: EdgeInsets.all(18),
                        child: SvgPicture.asset(
                          'assets/menu.svg',
                          color: Colors.black,
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ),
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
                if (_categories.isNotEmpty)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (context, index) => Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (_list
                                      .where((element) =>
                                          element.shop.categoryId ==
                                          _categories[index].categoryId)
                                      .isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Text(
                                        _categories[index].categoryName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  Wrap(
                                    runSpacing: 15,
                                    children: _list
                                        .where((element) =>
                                            element.shop.categoryId ==
                                            _categories[index].categoryId)
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                        childCount: _categories.length),
                  ),
                // if (_categories.isNotEmpty)
                //   SliverToBoxAdapter(
                //     child: Padding(
                //       padding: EdgeInsets.all(15),
                //       child: Text(
                //         _categories[0].categoryName,
                //         style: TextStyle(
                //           fontSize: 18,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ),
                //   ),
                // SliverFillRemaining(
                //   child: Wrap(
                //     runSpacing: 15,
                //     children: _list,
                //   ),
                // ),
              ],
            ),
            if (_search)
              SearchPage(
                close: () {
                  setState(() {
                    _search = false;
                  });
                },
                onSelect: (address, latLng) {
                  debugPrint(address);
                  setState(() {
                    provider.setUserLatLng(latLng);
                    provider.setUserAddress(address);
                    _search = false;
                    provider.user.address = address;
                  });
                },
              ),
            if (_categories.isEmpty)
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Align(
                  alignment: Alignment.center,
                  child: LoadingAnimationWidget.inkDrop(
                    color: Theme.of(context).primaryColor,
                    size: 50,
                  ),
                ),
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
