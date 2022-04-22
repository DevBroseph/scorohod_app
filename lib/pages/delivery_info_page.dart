import 'package:flutter/material.dart';
import 'package:scorohod_app/objects/info.dart';
import 'package:scorohod_app/services/constants.dart';
import 'package:scorohod_app/services/network.dart';
import 'package:skeleton_text/skeleton_text.dart';

class DeliveryInfoPage extends StatefulWidget {
  const DeliveryInfoPage({Key? key}) : super(key: key);

  @override
  State<DeliveryInfoPage> createState() => _DeliveryInfoPageState();
}

class _DeliveryInfoPageState extends State<DeliveryInfoPage> {
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
    _getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            pinned: true,
            // elevation: 0,
            foregroundColor: red,
            // expandedHeight: 210,
            title: Text(
              '',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: red,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 15)),
          SliverToBoxAdapter(
            child: Image.asset(
              'assets/logo.png',
              width: 100,
              height: 100,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
          // if (_info != null)
          _infoCard('Доставка и оплата',
              _info != null ? _info!.deliveryAndPay : '', true, false),
          // if (_info != null)
          _infoCard('Стоимость доставки',
              _info != null ? _info!.deliveryPrice : '', false, false),
          if (_info != null)
            _infoCard('Время работы', _info != null ? _info!.workTime : '',
                false, true),
          // if (_info != null)
          _infoCard('Прочие условия',
              _info != null ? _info!.otherConditions : '', false, false),
        ],
      ),
    );
  }

  SliverToBoxAdapter _infoCard(
      String title, String subTitle, bool main, bool count) {
    return SliverToBoxAdapter(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: 40, top: 15, right: 40, bottom: 20),
        // width: 200,
        // height: 70,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(
            title,
            style: TextStyle(
                fontSize: main ? 22 : 12,
                fontWeight: main ? FontWeight.bold : FontWeight.w500,
                color: main ? Colors.black : Colors.grey[600]),
          ),
          SizedBox(height: main ? 30 : 5),
          if (subTitle != '')
            Text(
              subTitle,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
              textAlign: TextAlign.center,
            )
          else
            SkeletonAnimation(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: radius,
                ),
              ),
            ),
        ]),
      ),
    );
  }
}
