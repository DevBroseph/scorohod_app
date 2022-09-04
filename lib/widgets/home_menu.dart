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
  double _height = 50.0;
  double _opacity = 0.0;
  int _rotation = 0;
  bool isListVisible = false;
  List<String> result = [];
  late String userCity;

  final YandexGeocoder geo = YandexGeocoder(apiKey: '844ff5f2-ed67-4950-bd7c-1544e3d9056f');

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
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const ChooseCity()));
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          city.city.nameRU == '' ? 'Выбор города' : city.city.nameRU,
                          style: GoogleFonts.rubik(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            letterSpacing: 0.3,
                          ),
                        ),
                        RotationTransition(
                          turns: const AlwaysStoppedAnimation(90 / 360),
                          child: SvgPicture.asset(
                            'assets/triangle.svg',
                            color: Colors.white,
                            height: 20,
                          ),
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
