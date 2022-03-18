import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:scale_button/scale_button.dart';
import 'package:scorohod_app/pages/search.dart';
import 'package:scorohod_app/services/app_data.dart';
import 'package:scorohod_app/services/constants.dart';
import 'package:scorohod_app/widgets/custom_text_field.dart';
import 'package:scorohod_app/widgets/my_flushbar.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _roomController = TextEditingController();
  final _entranceController = TextEditingController();
  final _floorController = TextEditingController();

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
        _addressController.text = 'Нажмите, чтобы выбрать адрес.';
        _nameController.text = '';
        _phoneController.text = '';
        _roomController.text = '';
        _entranceController.text = '';
        _floorController.text = '';
        _loadData = true;
      });
    }
  }

  void putUserData(DataProvider provider) {
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
    MyFlushbar.showFlushbar(context, 'Успешно.', 'Данные были сохранены.');
    provider.setUser(User(
        name: _nameController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        room: _roomController.text,
        entrance: _entranceController.text,
        floor: _floorController.text));
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
                title: const Text(
                  'Аккаунт',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: red,
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                        onPressed: () {
                          provider.signOutUser();
                          setState(() {
                            _loadData = false;
                          });
                          MyFlushbar.showFlushbar(
                              context, 'Успешно.', 'Данные были удалены.');
                        },
                        icon: const Icon(Icons.person_remove)),
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
                      enabled: true),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 25, 15, 0),
                  child: TextFieldCustom(
                      controller: _phoneController,
                      title: 'Ваш телефон',
                      keyboardType: TextInputType.phone,
                      needPhoneMask: true,
                      needCodeMask: false,
                      enabled: true),
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
                    child: const Center(
                      child: Text(
                        "Сохранить",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          height: 1.2,
                          fontFamily: 'SFUI',
                          fontWeight: FontWeight.w700,
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
              onSelect: (address) {
                debugPrint(address);
                setState(() {
                  _search = false;
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
}
