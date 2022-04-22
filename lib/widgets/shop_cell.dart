import 'dart:convert';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:scale_button/scale_button.dart';
import 'package:scorohod_app/objects/shop.dart';
import 'package:scorohod_app/services/constants.dart';

class ShopCell extends StatefulWidget {
  const ShopCell({
    Key? key,
    required this.shop,
    required this.width,
    required this.onTap,
  }) : super(key: key);

  final Shop shop;
  final double width;
  final Function() onTap;

  @override
  _ShopCellState createState() => _ShopCellState();
}

class _ShopCellState extends State<ShopCell> {
  var _color = const Color.fromARGB(255, 0, 0, 0);

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
    return AnimatedSwitcher(
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(
          child: child,
          scale: animation,
        );
      },
      duration: const Duration(milliseconds: 300),
      child: ScaleButton(
        duration: const Duration(milliseconds: 150),
        bound: 0.05,
        onTap: widget.onTap,
        child: Container(
          width: widget.width,
          height: widget.width,
          margin: const EdgeInsets.only(left: 15),
          decoration: BoxDecoration(
            borderRadius: radius,
            boxShadow: shadow,
            color: _color.withOpacity(0.2),
          ),
          child: Stack(
            children: [
              // ClipRRect(
              //   borderRadius: radius,
              //   child: Image.memory(
              //     base64Decode(widget.shop.shopLogo),
              //   ),
              // ),
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: _color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(150),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: Text(
                        widget.shop.shopName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FittedBox(
                      child: Text(
                        widget.shop.shopWorkingHours,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    FittedBox(
                      child: Text(
                        "от ${widget.shop.shopMinSum} ₽",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                // margin: EdgeInsets.only(left: 5, bottom: 5),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(19),
                  ),
                  child: Image.memory(
                    base64Decode(widget.shop.shopLogo),
                    width: 50,
                    height: 50,
                    fit: BoxFit.fitWidth,
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
