import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scorohod_app/pages/about.dart';
import 'package:scorohod_app/pages/account.dart';
import 'package:scorohod_app/pages/delivery_info_page.dart';
import 'package:scorohod_app/pages/orders.dart';
import 'package:scorohod_app/services/constants.dart';

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
            ],
          ),
        ),
      ),
    );
  }
}
