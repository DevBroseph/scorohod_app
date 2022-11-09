import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:provider/provider.dart';
import 'package:scorohod_app/services/app_data.dart';
import 'package:scorohod_app/services/constants.dart';
import 'package:yandex_geocoder/yandex_geocoder.dart';

import '../widgets/home_menu.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    Key? key,
    required this.close,
    required this.onSelect,
  }) : super(key: key);

  final Function() close;
  final Function(String placeId, LatLng latLng) onSelect;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // late final GooglePlace _googlePlace;
  final YandexGeocoder geocoder =
      YandexGeocoder(apiKey: '844ff5f2-ed67-4950-bd7c-1544e3d9056f');
  List<FeatureMember>? _predictions;
  final _searchController = TextEditingController();

  void _searchPlace() async {
    if (_searchController.text.isNotEmpty) {
      var result = await geocoder.getGeocode(
        GeocodeRequest(
          geocode: AddressGeocode(address: _searchController.text),
          lang: Lang.ru,
          kind: KindRequest.house,
        ),
      );
      if (result != null && mounted) {
        setState(() {
          _predictions = result.response?.geoObjectCollection?.featureMember;
        });
      }
    } else {
      setState(() {
        _predictions = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // _googlePlace = GooglePlace(googleAPIKey);
    _searchController.addListener(_searchPlace);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomeMenu(),
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
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
                    leading: Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: const Icon(
                        Icons.place,
                        color: red,
                      ),
                    ),
                    title: Text(
                      _predictions?[index].geoObject?.name ?? "",
                      style: GoogleFonts.rubik(
                          fontWeight: FontWeight.w400, fontSize: 17),
                    ),
                    subtitle: Text(
                      _predictions?[index].geoObject?.description ?? "",
                      maxLines: 2,
                      style: GoogleFonts.rubik(
                          fontWeight: FontWeight.w400, fontSize: 14),
                    ),
                    onTap: () {
                      getPrediction(_predictions?[index].geoObject);
                    });
              },
              childCount: _predictions != null ? _predictions?.length : 0,
            ),
          ),
        ],
      ),
    );
  }

  void getPrediction(GeoObject? p) async {
    if (p != null) {
      // var address = await Geocoder.local.findAddressesFromQuery(p.description);
      _searchController.text = p.name!;
      _searchController.selection = TextSelection(
        baseOffset: _searchController.text.length,
        extentOffset: _searchController.text.length,
      );
      print(p.metaDataProperty?.geocoderMetaData?.addressDetails?.country
          ?.addressLine);
      setState(() {});
      widget.onSelect('${p.description}, ${p.name}',
          LatLng(p.point!.latitude, p.point!.longitude));
    }
  }
}
