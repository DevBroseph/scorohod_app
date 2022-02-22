import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:scale_button/scale_button.dart';
import 'package:scorohod_app/objects/shop.dart';
import 'package:scorohod_app/pages/shop.dart';
import 'package:scorohod_app/services/constants.dart';
import 'package:scorohod_app/services/extensions.dart';
import 'package:scorohod_app/services/network.dart';
import 'package:image/image.dart' as img;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scorohod',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _address = "Укажите свой адрес";
  var _search = false;

  final List<Widget> _list = [];

  Future<void> _update() async {
    var width = MediaQuery.of(context).size.width / 2 - 22.5;
    var result = await NetHandler(context).getShops();

    if (result == null) return;

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

    setState(() {});
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
    return ScaleButton(
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
          ],
        ),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({
    Key? key,
    required this.close,
    required this.onSelect,
  }) : super(key: key);

  final Function() close;
  final Function(String placeId) onSelect;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final GooglePlace _googlePlace;
  List<AutocompletePrediction> _predictions = [];
  final _searchController = TextEditingController();

  void _searchPlace() async {
    if (_searchController.text.isNotEmpty) {
      var result = await _googlePlace.autocomplete.get(
        _searchController.text,
        language: "RU_ru",
      );
      if (result != null && result.predictions != null && mounted) {
        setState(() {
          _predictions = result.predictions!;
        });
      }
    } else {
      setState(() {
        _predictions = [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _googlePlace = GooglePlace("AIzaSyC2enrbrduQm8Ku7fBqdP8gOKanBct4JkQ");
    _searchController.addListener(_searchPlace);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomeMenu(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Укажите свой адрес",
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
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ListTile(
                  leading: const Icon(
                    Icons.pin_drop,
                    color: red,
                  ),
                  title: Text(_predictions[index].description ?? ""),
                  onTap: () => widget.onSelect(
                    _predictions[index].description ?? "",
                  ),
                );
              },
              childCount: _predictions.length,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeMenu extends StatelessWidget {
  const HomeMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.5,
      child: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              Padding(
                padding: const EdgeInsets.all(50),
                child: Image.asset(
                  "assets/logo.png",
                  width: 100,
                  color: red,
                ),
              ),
              // ListTile(
              //   leading: const Icon(
              //     FontAwesomeIcons.userAlt,
              //     color: red,
              //   ),
              //   title: const Text("Войти"),
              //   onTap: () {},
              // ),
              ListTile(
                leading: const Icon(
                  FontAwesomeIcons.wallet,
                  color: red,
                ),
                title: const Text("Доставка и оплата"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(
                  FontAwesomeIcons.solidQuestionCircle,
                  color: red,
                ),
                title: const Text("Служба поддержки"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(
                  FontAwesomeIcons.infoCircle,
                  color: red,
                ),
                title: const Text("О сервисе"),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
