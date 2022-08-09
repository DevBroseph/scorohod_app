import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scale_button/scale_button.dart';
import 'package:scorohod_app/pages/phone.dart';
import 'package:scorohod_app/pages/search.dart';
import 'package:scorohod_app/services/app_data.dart';
import 'package:scorohod_app/services/constants.dart';
import 'package:scorohod_app/services/extensions.dart';
import 'package:scorohod_app/services/network.dart';
import 'package:scorohod_app/widgets/custom_text_field.dart';
import 'package:scorohod_app/widgets/my_flushbar.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage>
    with AutomaticKeepAliveClientMixin<AccountPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _roomController = TextEditingController();
  final _entranceController = TextEditingController();
  final _floorController = TextEditingController();

  firebase.FirebaseAuth auth = firebase.FirebaseAuth.instance;

  LatLng _latLng = LatLng(0, 0);
  bool _loadData = false;
  bool _search = false;

  void setUserData(DataProvider provider) {
    if (provider.hasUser) {
      setState(() {
        _nameController.text = provider.user.name;
        _phoneController.text = provider.user.phone;
        if (provider.user.address.isNotEmpty) {
          _addressController.text = provider.user.address;
        } else {
          _addressController.text = 'Нажмите, чтобы выбрать адрес.';
        }
        _roomController.text = provider.user.room;
        _entranceController.text = provider.user.entrance;
        _floorController.text = provider.user.floor;
        _loadData = true;
      });
    } else {
      setState(() {
        if (provider.user.address.isNotEmpty) {
          _addressController.text = provider.user.address;
        } else {
          _addressController.text = 'Нажмите, чтобы выбрать адрес.';
        }
        _nameController.text = '';
        if (provider.user.phone != '') {
          _phoneController.text = provider.user.phone;
        } else {
          _phoneController.text = '';
        }
        _roomController.text = '';
        _entranceController.text = '';
        _floorController.text = '';
        _loadData = true;
      });
    }
  }

  void setUserPhone(DataProvider provider) {
    setState(() {
      _phoneController.text = provider.user.phone;
    });
  }

  void showAlert(DataProvider provider) async {
    // await FlutterPlatformAlert.playAlertSound();

    final clickedButton = await FlutterPlatformAlert.showCustomAlert(
        windowTitle: 'Выйти из аккаунта?',
        text: '',
        positiveButtonTitle: 'Да',
        negativeButtonTitle: 'Нет',
        // alertStyle: AlertButtonStyle.yesNoCancel,
        iconStyle: IconStyle.information,
        windowPosition: AlertWindowPosition.screenCenter);
    if (clickedButton == CustomButton.positiveButton) {
      provider.signOutUser();

      setState(() {
        _loadData = false;
        _addressController.text = 'Нажмите, чтобы выбрать адрес.';
        _nameController.text = '';
        _phoneController.text = '';
        _roomController.text = '';
        _entranceController.text = '';
        _floorController.text = '';
      });
      MyFlushbar.showFlushbar(context, 'Успешно.', 'Данные были удалены.');
    }
  }

  Future<void> putUserData(DataProvider provider) async {
    if (_nameController.text == '') {
      MyFlushbar.showFlushbar(context, 'Ошибка.', 'Укажите имя.');
      return;
    }
    if (_phoneController.text == '') {
      MyFlushbar.showFlushbar(context, 'Ошибка.', 'Укажите номер телефона.');
      return;
    }
    if (_phoneController.text.length < 19) {
      MyFlushbar.showFlushbar(
          context, 'Ошибка.', 'Номер телефона указан неверно.');
      return;
    }
    if (_addressController.text == '' ||
        _addressController.text == 'Нажмите, чтобы выбрать адрес.') {
      MyFlushbar.showFlushbar(context, 'Ошибка.', 'Укажите адрес доставки.');
      return;
    }
    print(provider.hasUser);
    if (provider.user.id == '') {
      var result = await NetHandler(context).auth(
        _nameController.text,
        _phoneController.text,
        '',
        '',
        Platform.isIOS ? 'Ios' : 'Android',
        _addressController.text,
        _roomController.text,
        _entranceController.text,
        _floorController.text,
      );

      if (result != null) {
        provider.setUser(
          User(
            id: result.userId,
            name: result.userName,
            phone: result.phone,
            address: result.address,
            room: result.room,
            entrance: result.entrance,
            floor: result.floor,
            latLng: _latLng,
          ),
        );
        MyFlushbar.showFlushbar(context, 'Успешно.', 'Данные были сохранены.');
      } else {
        MyFlushbar.showFlushbar(context, 'Ошибка.', 'Данные не сохранены.');
      }
    } else {
      var result = await NetHandler(context).updateUser(
        provider.user.id,
        _nameController.text,
        _phoneController.text,
        '',
        '',
        Platform.isIOS ? 'Ios' : 'Android',
        _addressController.text,
        _roomController.text,
        _entranceController.text,
        _floorController.text,
      );

      if (result != null) {
        provider.setUser(User(
            id: result.userId,
            name: result.userName,
            phone: result.phone,
            address: result.address,
            room: result.room,
            entrance: result.entrance,
            floor: result.floor,
            latLng: _latLng));
        MyFlushbar.showFlushbar(context, 'Успешно.', 'Данные были сохранены.');
        Timer(Duration(seconds: 3), () {
          Navigator.pop(context);
        });
      } else {
        MyFlushbar.showFlushbar(context, 'Ошибка.', 'Данные не сохранены.');
      }
    }
  }

  @override
  void initState() {
    print('init');
    super.initState();
  }

  @override
  void dispose() {
    print('dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DataProvider>(context);

    if (!_loadData) {
      setUserData(provider);
    }

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                // elevation: 0,
                foregroundColor: red,
                // expandedHeight: 210,
                title: Text(
                  'Аккаунт',
                  style: GoogleFonts.rubik(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: red,
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      onPressed: () {
                        showAlert(provider);
                        // provider.signOutUser();
                        // setState(() {
                        //   _loadData = false;
                        // });
                        // MyFlushbar.showFlushbar(
                        //     context, 'Успешно.', 'Данные были удалены.');
                      },
                      icon: const Icon(
                        FontAwesomeIcons.trashAlt,
                        size: 20,
                      ),
                    ),
                  )
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 10),
                  child: Image.asset(
                    'assets/avatar.png',
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
                  child: TextFieldCustom(
                    controller: _nameController,
                    title: 'Ваше имя',
                    keyboardType: TextInputType.text,
                    needPhoneMask: false,
                    needCodeMask: false,
                    enabled: true,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 25, 15, 0),
                  child: GestureDetector(
                    onTap: () {
                      context
                          .nextPage(const PhonePage())
                          .then((value) => setUserPhone(provider));
                    },
                    child: TextFieldCustom(
                        controller: _phoneController,
                        title: 'Ваш телефон',
                        keyboardType: TextInputType.phone,
                        needPhoneMask: true,
                        needCodeMask: false,
                        enabled: false),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 25, 15, 0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _search = true;
                      });
                    },
                    child: TextFieldCustom(
                        controller: _addressController,
                        title: 'Адрес доставки',
                        keyboardType: TextInputType.text,
                        needPhoneMask: false,
                        needCodeMask: false,
                        enabled: false),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 16.0, left: 15, right: 15, top: 40),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextFieldCustom(
                          controller: _roomController,
                          needCodeMask: false,
                          keyboardType: TextInputType.text,
                          title: "Кв. / Офис",
                          needPhoneMask: false,
                          enabled: true,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        child: TextFieldCustom(
                          controller: _entranceController,
                          needCodeMask: false,
                          keyboardType: TextInputType.text,
                          title: "Подъезд",
                          needPhoneMask: false,
                          enabled: true,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        child: TextFieldCustom(
                          controller: _floorController,
                          needCodeMask: false,
                          keyboardType: TextInputType.text,
                          title: "Этаж",
                          needPhoneMask: false,
                          enabled: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: ScaleButton(
                  onTap: () => putUserData(provider),
                  duration: const Duration(milliseconds: 150),
                  bound: 0.05,
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      color: red,
                      boxShadow: shadow,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Center(
                      child: Text(
                        "Сохранить",
                        style: GoogleFonts.rubik(
                          fontSize: 15,
                          color: Colors.white,
                          height: 1.2,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              )
            ],
          ),
          if (_search)
            SearchPage(
              close: () {
                setState(() {
                  _search = false;
                });
              },
              onSelect: (address, latLng) {
                debugPrint(address);
                setState(() {
                  _latLng = latLng;
                  _search = false;
                  provider.setUserLatLng(latLng);
                  provider.setUserAddress(address);
                  provider.user.address = address;
                  _addressController.text =
                      address.substring(0, 1).toUpperCase() +
                          address.substring(1, address.length);
                });
              },
            ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
