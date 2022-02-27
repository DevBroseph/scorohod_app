import 'package:flutter/material.dart';

class BasketPage extends StatefulWidget {
  final Color color;
  const BasketPage({Key? key, required this.color}) : super(key: key);

  @override
  _BasketPageState createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  var _color = const Color.fromARGB(255, 255, 255, 255);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          pinned: true,
          // elevation: 0,
          foregroundColor: widget.color,
          // expandedHeight: 210,
          title: Text(
            'Корзина',
            style: TextStyle(
              fontSize: 16,
              color: widget.color,
            ),
          ),
        )
      ]),
    );
  }
}
