import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scale_button/scale_button.dart';
import 'package:scorohod_app/objects/group.dart';
import 'package:scorohod_app/objects/product.dart';
import 'package:scorohod_app/pages/group.dart';
import 'package:scorohod_app/services/constants.dart';
import 'package:scorohod_app/services/extensions.dart';

class GroupCard extends StatelessWidget {
  const GroupCard({
    Key? key,
    required Color color,
    required this.group,
    required List<Group> allGroups,
    required List<Product> products,
    required List<Group> perrentGroups,
    required this.index,
  })  : _color = color,
        _allGroups = allGroups,
        _products = products,
        _perrentGroups = perrentGroups,
        super(key: key);

  final Color _color;
  final Group group;
  final int index;
  final List<Group> _allGroups;
  final List<Product> _products;
  final List<Group> _perrentGroups;

  @override
  Widget build(BuildContext context) {
    return ScaleButton(
      duration: const Duration(milliseconds: 150),
      bound: 0.05,
      onTap: () => context.nextPage(
        GroupPage(
          perrent: group,
          groups: _allGroups,
          products: _products,
          color: _color,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 7.5,
          horizontal: 7.5,
        ),
        decoration: BoxDecoration(
          borderRadius: radius,
          color: Theme.of(context).cardColor,
        ),
        height: 150.0,
        child: Stack(
          children: [
            if (_perrentGroups[index].groupImage != '')
              Padding(
                padding: const EdgeInsets.only(
                  left: 9,
                  bottom: 9,
                  right: 9,
                  top: 9,
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Image.memory(
                    base64Decode(
                      _perrentGroups[index].groupImage,
                    ),
                    fit: BoxFit.scaleDown,
                    width: group.name.length > 23 ? 45 : 55,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(
                left: 9,
                bottom: 9,
                right: 9,
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  group.name,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
