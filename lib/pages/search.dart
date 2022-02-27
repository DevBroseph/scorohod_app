import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
