import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scorohod_app/pages/about.dart';
import 'package:scorohod_app/pages/account.dart';
import 'package:scorohod_app/objects/coordinates.dart';
import 'package:scorohod_app/pages/delivery_info_page.dart';
import 'package:scorohod_app/pages/orders.dart';
import 'package:scorohod_app/services/constants.dart';

import '../services/network.dart';

class HomeMenu extends StatefulWidget {
  const HomeMenu({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomeMenuState();
}

class HomeMenuState extends State<HomeMenu> {

  double _height = 50.0;
  double _opacity = 0.0;
  int _rotation = 0;
  String city = '';
  bool isListVisible = false;
  List<Coordinates> result = [];
  final list = ['Москва', 'Москва', 'Москва', 'Москва', 'Москва', ];


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
              ListTile(
                leading: SvgPicture.asset(
                  'assets/settings.svg',
                  color: red,
                  height: 27,
                  width: 27,
                ),
                title: Text(
                  "Аккаунт",
                  style: GoogleFonts.rubik(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    letterSpacing: 0.3,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AccountPage()));
                },
              ),
              ListTile(
                leading: SvgPicture.asset(
                  'assets/chat.svg',
                  color: red,
                  height: 27,
                  width: 27,
                ),
                title: Text(
                  "Заказы",
                  style: GoogleFonts.rubik(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    letterSpacing: 0.3,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderStatusPage()));
                },
              ),
              ListTile(
                leading: SvgPicture.asset(
                  'assets/card.svg',
                  color: red,
                  height: 27,
                  width: 27,
                ),
                title: Text(
                  "Доставка и оплата",
                  style: GoogleFonts.rubik(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    letterSpacing: 0.3,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DeliveryInfoPage()));
                },
              ),
              // ListTile(
              //   leading: const Icon(
              //     FontAwesomeIcons.solidQuestionCircle,
              //     color: red,
              //   ),
              //   title: const Text("Служба поддержки"),
              //   onTap: () {},
              // ),
              ListTile(
                leading: SvgPicture.asset(
                  'assets/phone.svg',
                  color: red,
                  height: 27,
                  width: 27,
                ),
                title: Text(
                  "О сервисе",
                  style: GoogleFonts.rubik(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    letterSpacing: 0.3,
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AboutPage()));
                },
              ),
              GestureDetector(
                onTap: () async {
                  var answer = await NetHandler(context).getCoordinates();
                  print(answer);
                  if (answer != null) {
                    result = answer;
                    print(answer[1].latitude);
                  }
                  print(result[1].latitude);
                  setState(() {
                    if (_height == MediaQuery.of(context).size.height-500) {
                      setState(() {
                        _height = 50;
                        _rotation = 0;
                      });
                    }  else {
                      setState(() {
                        _height = MediaQuery.of(context).size.height-500;
                        _rotation = 180;
                      });
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  height: _height,
                  onEnd: () {
                    setState(() {
                      if (_opacity == 1.0) {
                        _opacity = 0.0;
                      }  else  {
                        _opacity = 1.0;
                      }
                    });
                  },
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(city == '' ? 'Выбор города' : city,
                                style: GoogleFonts.rubik(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  letterSpacing: 0.3,
                                ),),
                              AnimatedRotation(
                                turns: _rotation / 360,
                                duration: const Duration(milliseconds: 200),
                                child: SvgPicture.asset('assets/triangle.svg', color: Colors.white, height: 20,),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: ListView.builder(
                            itemCount: 4,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      city = result[index].latitude.toString();
                                      _height = 50;
                                      _rotation = 0;
                                    });
                                  },
                                  child: Container(
                                    height: 40,
                                    alignment: Alignment.centerLeft,
                                    decoration: BoxDecoration(
                                      color: Colors.white12,
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(city == '' ? result[index].latitude.toString() : city,
                                        style: GoogleFonts.rubik(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                    )
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
