import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:scorohod_app/objects/info.dart';
import 'package:scorohod_app/pages/web.dart';
import 'package:scorohod_app/services/constants.dart';
import 'package:scorohod_app/services/network.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String _appVersion = '';
  String _buildVersion = '';

  Info? _info = null;

  void _getInfo() async {
    var result = await NetHandler(context).getInfo();
    if (result != null) {
      setState(() {
        _info = result;
      });
    }
  }

  @override
  void initState() {
    _getVersion();
    _getInfo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: red,
        highlightElevation: 0,
        elevation: 0,
        onPressed: () {
          launch("tel://${_info!.phone}");
        },
        child: const Icon(Icons.phone),
      ),
      body: Stack(
        children: [
          CustomScrollView(slivers: [
            const SliverAppBar(
              pinned: true,
              // elevation: 0,
              foregroundColor: red,
              // expandedHeight: 210,
              title: Text(
                'О сервисе',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: red,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 35)),
            SliverToBoxAdapter(
              child: Image.asset(
                'assets/logo.png',
                width: 100,
                height: 100,
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 35)),
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Версия приложения: ',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    _appVersion,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 15)),
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Сборка: ',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    _buildVersion,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 55)),
            _card(
                'Политика конфиденциальности', 'https://scorohod.shop/policy/'),
            _card('Публичная оферта', 'https://scorohod.shop/terms/'),
            // _card('Поддержка', () => null),
          ]),
          SafeArea(
            bottom: true,
            child: Container(
              padding: Platform.isAndroid
                  ? EdgeInsets.only(bottom: 20)
                  : EdgeInsets.zero,
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    FontAwesomeIcons.copyright,
                    size: 15,
                  ),
                  SizedBox(width: 5),
                  Text('2022 Скороход')
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _getVersion() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        _appVersion = packageInfo.version;
        _buildVersion = packageInfo.buildNumber;
      });
    });
  }

  SliverToBoxAdapter _card(String title, String url) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Material(
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WebPage(title: title, url: url)));
              },
              child: ListTile(
                title: Text(
                  title,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w400),
                ),
                trailing: const Icon(
                  Icons.navigate_next_rounded,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
