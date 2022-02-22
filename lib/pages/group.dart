import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scorohod_app/objects/group.dart';
import 'package:scorohod_app/objects/product.dart';
import 'package:scorohod_app/services/constants.dart';
import 'package:scorohod_app/services/extensions.dart';

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

class _GroupPageState extends State<GroupPage> {
  final List<Group> _perrentGroups = [];
  final List<Product> _perrentProducts = [];

  final List<Widget> _list = [];

  @override
  void initState() {
    for (var item in widget.groups) {
      if (item.parentId == widget.perrent.id) {
        _perrentGroups.add(item);
      }
    }
    for (var item in widget.products) {
      if (item.groupId == widget.perrent.id) {
        _perrentProducts.add(item);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width / 2 - 22.5;
    _list.clear();
    for (var item in _perrentProducts) {
      _list.add(
        Container(
          width: width,
          height: width + 30,
          margin: const EdgeInsets.only(left: 15),
          decoration: BoxDecoration(
            borderRadius: radius,
            boxShadow: shadow,
            color: Colors.white,
          ),
          child: Column(
            children: [
              Image.memory(
                base64Decode(item.image),
                width: width / 2,
                height: width / 2,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        item.measure,
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
      );
    }
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            foregroundColor: widget.color,
            title: Text(
              widget.perrent.name,
              style: TextStyle(
                color: widget.color,
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
                      groups: widget.groups,
                      products: widget.products,
                      color: widget.color,
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
                            color: widget.color.withOpacity(0.1),
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
          const SliverToBoxAdapter(
            child: SizedBox(height: 15),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Wrap(
              runSpacing: 15,
              children: _list,
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
