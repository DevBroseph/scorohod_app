import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
          boxShadow: shadow,
          color: Colors.white,
        ),
        height: 150.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              if (_perrentGroups[index].groupImage != '')
                Positioned(
                  bottom: -20.0,
                  left: -20.0,
                  // right: -15.0,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        // left: 9,
                        // bottom: 9,
                        // right: 9,
                        // top: 9,
                        ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Opacity(
                        opacity: 0.8,
                        child: Image.memory(
                          base64Decode(
                            _perrentGroups[index].groupImage,
                          ),
                          fit: BoxFit.scaleDown,
                          width: 80,
                        ),
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 5,
                  top: 9,
                  right: 5,
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    group.name,
                    style: GoogleFonts.rubik(
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.right,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
