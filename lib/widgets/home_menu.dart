import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:scorohod_app/objects/city_coordinates.dart';
import 'package:scorohod_app/services/app_data.dart' as appData;
import 'package:scorohod_app/pages/about.dart';
import 'package:scorohod_app/pages/account.dart';
import 'package:yandex_geocoder/yandex_geocoder.dart';
import 'package:scorohod_app/pages/delivery_info_page.dart';
import 'package:scorohod_app/pages/orders.dart';
import 'package:scorohod_app/services/constants.dart';

import '../pages/choose_city.dart';
import '../services/app_data.dart';
import '../services/network.dart';

class HomeMenu extends StatefulWidget {
  const HomeMenu({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomeMenuState();
}

class HomeMenuState extends State<HomeMenu> {
  bool isListVisible = false;
  List<String> result = [];
  late String userCity;

  final YandexGeocoder geo =
      YandexGeocoder(apiKey: '844ff5f2-ed67-4950-bd7c-1544e3d9056f');

  @override
  Widget build(BuildContext context) {
    var city = Provider.of<appData.DataProvider>(context);
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
                padding: const EdgeInsets.only(
                  top: 20,
                  right: 10,
                  left: 0,
                  bottom: 40,
                ),
                child: Image.asset(
                  "assets/logo_text.png",
                  width: 400,
                  // color: red,
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
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChooseCity()));
                },
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.only(left: 15, right: 20, top: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[200]!,
                        offset: const Offset(0, 0),
                        spreadRadius: 1,
                        blurRadius: 10,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          city.city.nameRU == ''
                              ? 'Выбор города'
                              : city.city.nameRU,
                          style: GoogleFonts.rubik(
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            letterSpacing: 0.3,
                          ),
                        ),
                        SvgPicture.asset(
                          'assets/right.svg',
                          height: 25,
                        ),
                      ],
                    ),
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
/*
var answer = await NetHandler(context).getCoordinates();
                  print(answer);
                  if (answer != null) {
                    for (int i = answer.length-1; i>0; i--){
                      var answersCity = await geo.getGeocode(GeocodeRequest(
                          geocode: PointGeocode(
                              latitude: answer[i].coordinates.latitude,
                              longitude: answer[i].coordinates.longitude)
                      ));
                      var city = answersCity.firstAddress?.formatted;
                      List<String>? listCityInfo = city?.split(', ');
                      if (!result.contains(listCityInfo![2])) {
                        setState(() {
                          result.add(listCityInfo[2]);
                        });
                      }
                    }
                  }
                  setState(() {
                    if (_height == MediaQuery.of(context).size.height - 500) {
                      setState(() {
                        _height = 50;
                        _rotation = 0;
                      });
                    } else {
                      setState(() {
                        _height = MediaQuery.of(context).size.height - 500;
                        _rotation = 180;
                      });
                    }
                  });
 */
