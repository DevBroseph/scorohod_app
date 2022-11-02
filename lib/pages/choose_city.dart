import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:scorohod_app/objects/info.dart';
import 'package:scorohod_app/pages/home.dart';
import 'package:scorohod_app/pages/web.dart';
import 'package:scorohod_app/services/app_data.dart';
import 'package:scorohod_app/services/constants.dart';
import 'package:scorohod_app/services/network.dart';
import 'package:scorohod_app/services/app_data.dart' as appData;
import 'package:yandex_geocoder/yandex_geocoder.dart';

class ChooseCity extends StatefulWidget {
  const ChooseCity({Key? key}) : super(key: key);

  @override
  State<ChooseCity> createState() => _ChooseCityState();
}

class _ChooseCityState extends State<ChooseCity> {
  bool isLoading = false;
  List<String?> result = [];
  List<String?> resultENG = [];
  final YandexGeocoder geo =
      YandexGeocoder(apiKey: '844ff5f2-ed67-4950-bd7c-1544e3d9056f');

  void getCities() async {
    var answer = await NetHandler(context).getCoordinates();
    if (answer != null) {
      for (int i = answer.length - 1; i > 0; i--) {
        var answersCity = await geo.getGeocode(GeocodeRequest(
          geocode: PointGeocode(
              latitude: answer[i].coordinates.latitude,
              longitude: answer[i].coordinates.longitude),
          lang: Lang.ru,
          kind: KindRequest.locality,
        ));
        var answersCityENG = await geo.getGeocode(GeocodeRequest(
          geocode: PointGeocode(
              latitude: answer[i].coordinates.latitude,
              longitude: answer[i].coordinates.longitude),
          lang: Lang.enEn,
          kind: KindRequest.locality,
        ));
        var city = answersCity.firstAddress?.formatted;
        var cityENG = answersCityENG.firstAddress?.formatted;
        List<String>? listCityInfo = city?.split(', ');
        List<String>? listCityInfoENG = cityENG?.split(', ');
        if (!result.contains(listCityInfo?.last)) {
          result.add(listCityInfo?.last);
        }
        if (!resultENG.contains(listCityInfoENG?.last)) {
          resultENG.add(listCityInfoENG?.last);
        }
      }
      setState(() {
        isLoading = true;
      });
    }
  }

  @override
  void initState() {
    getCities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(247, 247, 247, 1),
      body: CustomScrollView(
        slivers: [
          _appBar(),
          const SliverToBoxAdapter(child: SizedBox(height: 15)),
          _body(),
        ],
      ),
    );
  }

  Widget _body() {
    var city = Provider.of<appData.DataProvider>(context);
    return isLoading
        ? SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _cardWidget(index, city),
              childCount: result.length,
            ),
          )
        : SliverToBoxAdapter(
            child: Container(
              height: MediaQuery.of(context).size.height - 200,
              alignment: Alignment.center,
              child: LoadingAnimationWidget.horizontalRotatingDots(
                color: Theme.of(context).primaryColor,
                size: 50,
              ),
            ),
          );
  }

  SliverAppBar _appBar() {
    return SliverAppBar(
      backgroundColor: Color.fromRGBO(247, 247, 247, 1),
      pinned: true,
      foregroundColor: red,
      title: Text(
        'Выберите город для доставки',
        style: GoogleFonts.rubik(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: red,
        ),
      ),
    );
  }

  Widget _cardWidget(int index, DataProvider city) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: GestureDetector(
        onTap: () => _onTap(city, index),
        child: Container(
          height: 70,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[200]!,
                offset: const Offset(0, 0),
                spreadRadius: 1,
                blurRadius: 10,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.place,
                    color: red,
                  ),
                  SizedBox(width: 20),
                  Text(
                    result[index]!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              trailing: SvgPicture.asset(
                'assets/right.svg',
                height: 25,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTap(DataProvider city, int index) {
    var isEmptyCity;
    if (city.city.nameRU == '') {
      isEmptyCity = true;
    } else {
      isEmptyCity = false;
    }
    print(resultENG[index]);
    city.city.nameRU = result[index]!;
    city.city.nameENG = resultENG[index]!;
    city.changeCity(city.city);
    if (!isEmptyCity) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false);
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    }
  }
}
