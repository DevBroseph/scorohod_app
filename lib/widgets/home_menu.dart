import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scorohod_app/pages/account.dart';
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
                leading: const Icon(
                  FontAwesomeIcons.userAlt,
                  color: red,
                ),
                title: const Text("Аккаунт"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AccountPage()));
                },
              ),
              ListTile(
                leading: const Icon(
                  FontAwesomeIcons.coins,
                  color: red,
                ),
                title: const Text("Заказы"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderStatusPage()));
                },
              ),
              ListTile(
                leading: const Icon(
                  FontAwesomeIcons.wallet,
                  color: red,
                ),
                title: const Text("Доставка и оплата"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(
                  FontAwesomeIcons.solidQuestionCircle,
                  color: red,
                ),
                title: const Text("Служба поддержки"),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(
                  FontAwesomeIcons.infoCircle,
                  color: red,
                ),
                title: const Text("О сервисе"),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
