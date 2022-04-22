import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:scorohod_app/services/constants.dart';

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
    _googlePlace = GooglePlace(googleAPIKey);
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
                    leading: const Icon(
                      Icons.pin_drop,
                      color: red,
                    ),
                    title: Text(_predictions[index].description ?? ""),
                    onTap: () {
                      getPrediction(_predictions[index]);
                    });
              },
              childCount: _predictions.length,
            ),
          ),
        ],
      ),
    );
  }

  void getPrediction(AutocompletePrediction? p) async {
    if (p != null) {
      var detail = await _googlePlace.details.get(p.placeId!);

      var placeId = p.placeId;
      double lat = detail!.result!.geometry!.location!.lat!;
      double lng = detail.result!.geometry!.location!.lng!;

      // var address = await Geocoder.local.findAddressesFromQuery(p.description);
      widget.onSelect(p.description ?? '', LatLng(lat, lng));
      print(lat);
      print(lng);
    }
  }
}
