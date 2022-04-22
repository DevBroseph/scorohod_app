import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scorohod_app/bloc/orders_bloc/orders_bloc.dart';
import 'package:scorohod_app/bloc/orders_bloc/orders_state.dart';
import 'package:scorohod_app/objects/group.dart';
import 'package:scorohod_app/objects/product.dart';
import 'package:scorohod_app/pages/search_products.dart';
import 'package:scorohod_app/widgets/category.dart';
import 'package:scorohod_app/widgets/order_widget.dart';
import 'package:scorohod_app/widgets/rect_getter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'home.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({
    Key? key,
    required this.perrent,
    required this.groups,
    required this.products,
    required this.color,
  }) : super(key: key);

  final Group perrent;
  final List<Group> groups;
  final List<Product> products;
  final Color color;

  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> with TickerProviderStateMixin {
  final List<Group> _perrentGroups = [];
  final List<Product> _perrentProducts = [];

  TabController? _tabController;

  AutoScrollController scrollController = AutoScrollController();
  bool pauseRectGetterIndex = false;
  final listViewKey = RectGetter.createGlobalKey();
  Map<int, dynamic> itemsKeys = {};

  final StreamController<bool> _streamController = StreamController<bool>();

  int selectedMenu = 0;
  bool _search = false;

  @override
  void initState() {
    for (var itemGroup in widget.groups) {
      if (itemGroup.parentId == widget.perrent.id) {
        for (var item in widget.products) {
          if (item.groupId == itemGroup.id) {
            _perrentProducts.add(item);
          }
        }
        if (widget.products
            .where((element) => element.groupId == itemGroup.id)
            .isNotEmpty) {
          _perrentGroups.add(itemGroup);
        }
      }
    }
    // setState(() {
    _tabController = TabController(
      length: _perrentGroups.length,
      vsync: this,
    );
    // });

    _tabController!.addListener(() {
      if (VerticalScrollableTabBarStatus.isOnTap) {
        animateAndScrollTo(VerticalScrollableTabBarStatus.isOnTapIndex);
        VerticalScrollableTabBarStatus.isOnTap = false;
      }
    });
    super.initState();
  }

  void animateAndScrollTo(int index) async {
    pauseRectGetterIndex = true;
    _tabController!.animateTo(index);
    await scrollController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.begin,
    );
    selectedMenu = index;
    pauseRectGetterIndex = false;
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (pauseRectGetterIndex) return true;

    int lastTabIndex = _tabController!.length - 1;
    List<int> visibleItems = getVisibleItemsIndex();

    bool reachLastTabIndex = visibleItems.isNotEmpty &&
        visibleItems.length <= 2 &&
        visibleItems.last == lastTabIndex;

    if (reachLastTabIndex) {
      _tabController!.animateTo(lastTabIndex);
    } else {
      int sumIndex = visibleItems.reduce(
        (value, element) => value + element + 1,
      );
      int middleIndex = sumIndex ~/ visibleItems.length;

      if (_tabController!.index != middleIndex) {
        _tabController!.animateTo(middleIndex);
      }
    }
    return false;
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  List<int> getVisibleItemsIndex() {
    Rect? rect = RectGetter.getRectFromKey(listViewKey);
    List<int> items = [];
    if (rect == null) return items;

    itemsKeys.forEach((index, key) {
      Rect? itemRect = RectGetter.getRectFromKey(key);
      if (itemRect == null) return;
      if (itemRect.top > rect.bottom) return;
      if (itemRect.bottom < rect.top) return;

      items.add(index);
    });

    return items;
  }

  Widget buildItem(int index, double width) {
    return RectGetter(
      key: itemsKeys[index],
      child: AutoScrollTag(
        key: ValueKey(index),
        index: index,
        controller: scrollController,
        child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
            ),
            child: CategoryWidget(
                category: _perrentGroups[index],
                index: index,
                products: _perrentProducts,
                color: widget.color,
                width: width)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width / 2 - 22.5;

    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        return StreamBuilder<bool>(
          stream: _streamController.stream,
          initialData: _search,
          builder: ((context, snapshot) {
            return Scaffold(
              body: Stack(
                children: [
                  RectGetter(
                    key: listViewKey,
                    child: NotificationListener<ScrollNotification>(
                      child: CustomScrollView(
                        physics: BouncingScrollPhysics(),
                        controller: scrollController,
                        slivers: [
                          SliverAppBar(
                            pinned: true,
                            elevation: 0,
                            expandedHeight: 80,
                            foregroundColor: widget.color,
                            title: Text(
                              widget.perrent.name,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: widget.color,
                                  fontWeight: FontWeight.w600),
                            ),
                            snap: false,
                            actions: [
                              IconButton(
                                  onPressed: () {
                                    // setState(() {
                                    _streamController.sink.add(true);
                                    // });
                                  },
                                  icon: Icon(
                                    Icons.search,
                                    color: widget.color,
                                  ))
                            ],
                          ),
                          if (_tabController != null)
                            SliverAppBar(
                              automaticallyImplyLeading: false,
                              pinned: true,
                              backgroundColor:
                                  Theme.of(context).appBarTheme.backgroundColor,
                              shadowColor: Colors.black.withOpacity(0.3),
                              toolbarHeight: Platform.isIOS ? 5 : 30,
                              flexibleSpace: TabBar(
                                isScrollable: true,
                                controller: _tabController,
                                overlayColor: MaterialStateProperty.all(
                                  Colors.transparent,
                                ),
                                indicatorPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.grey[700],
                                indicator: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(32),
                                  ),
                                  color: widget.color,
                                ),
                                tabs: _perrentGroups.map((e) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 25,
                                      vertical: 10,
                                    ),
                                    child: Text(
                                      e.name,
                                    ),
                                  );
                                }).toList(),
                                onTap: (index) {
                                  VerticalScrollableTabBarStatus.setIndex(
                                      index);
                                },
                              ),
                            ),
                          if (_tabController != null)
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  itemsKeys[index] =
                                      RectGetter.createGlobalKey();
                                  return buildItem(index, width);
                                },
                                childCount: _perrentGroups.length,
                              ),
                            ),
                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: 400,
                            ),
                          ),
                        ],
                      ),
                      onNotification: onScrollNotification,
                    ),
                  ),
                  Align(
                    child: OrderWidget(price: 12, color: widget.color),
                    alignment: Alignment.bottomCenter,
                  ),
                  if (snapshot.data!)
                    SearchProductsPage(
                      close: () {
                        _streamController.sink.add(_search = false);
                      },
                      products: _perrentProducts,
                      groups: _perrentGroups,
                      color: widget.color,
                    ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
