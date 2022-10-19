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
  List<String> resultENG = [];
  final YandexGeocoder geo = YandexGeocoder(apiKey: '844ff5f2-ed67-4950-bd7c-1544e3d9056f');

  void getCities () async {
    var answer = await NetHandler(context).getCoordinates();
    if (answer != null) {
      for (int i = answer.length-1; i>0; i--){
        print(answer[i].coordinates.latitude);
        print(answer[i].coordinates.longitude);
        print('\n');
        var answersCity = await geo.getGeocode(GeocodeRequest(
            geocode: PointGeocode(
                latitude: answer[i].coordinates.latitude,
                longitude: answer[i].coordinates.longitude
            ),
            lang: Lang.ru,
            kind: KindRequest.locality,
        ));
        var city = answersCity.firstAddress?.formatted;
        print(city);
        List<String>? listCityInfo = city?.split(', ');
        if (!result.contains(listCityInfo?.last)) {
          result.add(listCityInfo?.last);
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
    var city = Provider.of<appData.DataProvider>(context);
    return Scaffold(
      backgroundColor: Color.fromRGBO(247, 247, 247, 1),
      body: Stack(
        children: [
          CustomScrollView(slivers: [
            SliverAppBar(
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
            ),
          ]),
          SafeArea(
            bottom: true,
            child: isLoading ? Padding(
              padding: EdgeInsets.only(top: 50),
              child: ListView.builder(
                itemCount: result.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: GestureDetector(
                      onTap: () {
                        var isEmptyCity;
                        if (city.city.nameRU == '') {
                          isEmptyCity = true;
                        }  else  {
                          isEmptyCity = false;
                        }
                        city.city.nameRU = result[index]!;
                        print(resultENG[index]);
                        city.city.nameENG = resultENG[index];
                        city.changeCity(city.city);
                        if (!isEmptyCity) {
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                                  (route) => false
                          );
                        }  else  {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                        }
                      },
                      child: Container(
                        height: 60,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(result[index]!, style: TextStyle(fontSize: 20, color: Colors.black87)),
                              SvgPicture.asset('assets/right.svg', height: 25,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ) : Container(
              alignment: Alignment.center,
              child: LoadingAnimationWidget.horizontalRotatingDots(
                color: Theme.of(context).primaryColor,
                size: 50,
              ),
            )
          )
        ],
      ),
    );
  }
}
