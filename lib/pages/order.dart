import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scale_button/scale_button.dart';
import 'package:scorohod_app/bloc/orders_bloc/orders_bloc.dart';
import 'package:scorohod_app/bloc/orders_bloc/orders_event.dart';
import 'package:scorohod_app/objects/address.dart';
import 'package:scorohod_app/pages/order_info.dart';
import 'package:scorohod_app/pages/phone.dart';
import 'package:scorohod_app/pages/search.dart';
import 'package:scorohod_app/services/app_data.dart' as appData;
import 'package:scorohod_app/services/constants.dart';
import 'package:scorohod_app/services/extensions.dart';
import 'package:scorohod_app/services/network.dart';
import 'package:scorohod_app/widgets/address_modal.dart';
import 'package:scorohod_app/widgets/custom_text_field.dart';
import 'package:scorohod_app/widgets/deliver_widget.dart';
import 'package:scorohod_app/widgets/my_flushbar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../services/app_data.dart';

class OrderPage extends StatefulWidget {
  final Color color;
  final Function() onTap;
  const OrderPage({Key? key, required this.color, required this.onTap})
      : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _roomController = TextEditingController();
  final _entranceController = TextEditingController();
  final _floorController = TextEditingController();

  PanelController panelController = PanelController();

  bool visibleButton = true;

  LatLng _latLng = LatLng(0, 0);

  String _selectedPayment = 'Наличные';

  bool _loadData = false;
  bool _search = false;

  final List<String> _paymentImages = [
    "assets/payment_cash.png",
    "assets/payment_card.png",
    "assets/payment_card.png"
  ];
  List<String> _payment = ['Наличные', 'Картой'];

  void setUserData(appData.DataProvider provider) {
    if (provider.hasUser) {
      setState(() {
        _nameController.text = provider.user.name;
        _phoneController.text = provider.user.phone;
        if (provider.user.address != '') {
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
        if (provider.user.address != '') {
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
        _roomController.text = provider.user.room;
        _entranceController.text = provider.user.entrance;
        _floorController.text = provider.user.floor;
        _loadData = true;
      });
    }
  }

  void createOrder(OrdersBloc ordersBloc, appData.DataProvider provider) async {
    if (_nameController.text == '') {
      MyFlushbar.showFlushbar(context, 'Ошибка.', 'Укажите имя.');
      return;
    }
    if (provider.user.phone == '') {
      MyFlushbar.showFlushbar(
          context, 'Ошибка.', 'Необходимо подтвердить номер телефона.');
      return;
    }
    if (_phoneController.text.length < 19) {
      MyFlushbar.showFlushbar(
          context, 'Ошибка.', 'Номер телефона указан неверно.');
      return;
    }
    if (_addressController.text == '' ||
        _addressController.text == 'Нажмите, чтобы выбрать адрес.') {
      MyFlushbar.showFlushbar(context, 'Скороход.', 'Укажите адрес доставки.');
      return;
    }
    if (provider.hasUser == false) {
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
            _floorController.text);

        if (result != null) {
          provider.setUser(appData.User(
            id: result.userId,
            name: result.userName,
            phone: result.phone,
            address: provider.user.address,
            room: result.room,
            entrance: result.entrance,
            floor: result.floor,
            latLng: provider.user.latLng,
          ));
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
            _floorController.text);

        if (result != null) {
          provider.setUser(appData.User(
            id: result.userId,
            name: result.userName,
            phone: result.phone,
            address: provider.user.address,
            room: result.room,
            entrance: result.entrance,
            floor: result.floor,
            latLng: provider.user.latLng,
          ));
        }
      }
    }
    setState(() {
      visibleButton = false;
    });
    print(ordersBloc.deliveryPrice);
    var fcmToken = await FirebaseMessaging.instance.getToken();
    var answer = await NetHandler(context).createOrder(
      ordersBloc.products,
      provider.user.id,
      ordersBloc.totalPrice + ordersBloc.deliveryPrice,
      provider.user.address,
      provider.user.latLng,
      0.0,
      provider.currentShop.shopId,
      fcmToken!,
      ordersBloc.city ? '0' : ordersBloc.distance,
    );

    if (answer != null) {
      widget.onTap;
      BlocProvider.of<OrdersBloc>(context).add(RemoveProducts());
      MyFlushbar.showFlushbar(context, 'Успешно.', 'Заказ оформлен.');
      Timer(const Duration(seconds: 4), () {
        Navigator.pop(context);
        context.nextPage(
            OrderInfoPage(
              color: widget.color,
              order: answer,
              shop: provider.currentShop,
            ),
            fullscreenDialog: true);
      });
    } else {
      MyFlushbar.showFlushbar(context, 'Ошибка.', 'Не удалось оформить заказ.');
      setState(() {
        visibleButton = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<appData.DataProvider>(context);
    var bloc = BlocProvider.of<OrdersBloc>(context);

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
                foregroundColor: widget.color,
                // expandedHeight: 210,
                title: Text(
                  'Оформление заказа',
                  style: GoogleFonts.rubik(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: widget.color,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 16.0, left: 15, right: 15, top: 20),
                  child: _addressListTile(provider.user.address),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 16.0, left: 15, right: 15, top: 10),
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
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 16.0, left: 15, right: 15, top: 10),
                  child: TextFieldCustom(
                    needCodeMask: false,
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    title: "Ваше имя",
                    needPhoneMask: false,
                    enabled: true,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 16.0, left: 15, right: 15, top: 10),
                  child: GestureDetector(
                    onTap: () {
                      if (provider.user.phone == '') {
                        context
                            .nextPage(const PhonePage())
                            .then((value) => setUserData(provider));
                      } else {
                        MyFlushbar.showFlushbar(context, 'Внимание.',
                            'Номер телефона можно изменить только в настройках.');
                      }
                    },
                    child: TextFieldCustom(
                        isRequired: false,
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        needCodeMask: false,
                        title: "Номер телефона",
                        needPhoneMask: true,
                        enabled: false),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: _selectPayment(),
                ),
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
                  _addressController.text =
                      address.substring(0, 1).toUpperCase() +
                          address.substring(1, address.length);
                });
              },
            ),
          Align(
            child: DeliverWidget(
              price: 12,
              color: widget.color,
              onTap: () => createOrder(bloc, provider),
            ),
            alignment: Alignment.bottomCenter,
          ),
          SlidingUpPanel(
            controller: panelController,
            renderPanelSheet: false,
            isDraggable: true,
            collapsed: Container(),
            panel: const AddressModal(),
            onPanelClosed: () {},
            onPanelOpened: () {},
            onPanelSlide: (size) {},
            maxHeight: 700,
            minHeight: 0,
            defaultPanelState: PanelState.CLOSED,
          ),
        ],
      ),
    );
  }

  ScaleButton _addressListTile(String address) {
    setUserData(Provider.of<DataProvider>(context));
    return ScaleButton(
      duration: const Duration(milliseconds: 200),
      bound: 0.05,
      onTap: () => panelController.open(),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: shadow
            // border: Border.all(
            //   width: 1,
            //   color: Colors.grey[300]!,
            // ),
            ),
        child: ListTile(
          leading: SizedBox(
            width: 40,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: 25,
                width: 25,
                decoration: BoxDecoration(
                  color: address != '' ? Colors.green[200] : Colors.red[200],
                  shape: BoxShape.circle,
                ),
                child: address != ''
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 18,
                      )
                    : const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
              ),
            ),
          ),
          title: Text(
            address != '' ? address : 'Адрес не выбран',
            style: GoogleFonts.rubik(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: address != '' ? Colors.black : Colors.grey[500],
            ),
          ),
          // trailing: GestureDetector(
          //   onTap: () {},
          //   child: Icon(
          //     Icons.mode_edit_rounded,
          //     color: Colors.grey[300],
          //   ),
          // ),
        ),
      ),
    );
  }

  Widget _selectPayment() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: _payment.map((e) {
          return _paymentTypeContainer(index: _payment.indexOf(e));
        }).toList(),
      ),
    );
  }

  Widget _paymentTypeContainer({required int index}) {
    return Flexible(
      child: Padding(
        padding: EdgeInsets.only(left: index > 0 ? 16 : 0),
        child: InkWell(
          onTap: () {
            if (index != 0) {
              MyFlushbar.showFlushbar(context, 'Скороход.',
                  'К сожалению пока не доступна оплата картой.');
            }
            setState(() {});
          },
          borderRadius: const BorderRadius.all(Radius.circular(14)),
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 16, top: 16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      color: _selectedPayment == _payment[index]
                          ? widget.color
                          : Colors.white,
                      // widget.color,
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Image.asset(
                            _paymentImages[index],
                            width: 25,
                            color: _selectedPayment == _payment[index]
                                ? Colors.white
                                : Colors.black,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Text(
                              _payment[index],
                              style: GoogleFonts.rubik(
                                fontSize: 14,
                                color:
                                    // Colors.white,
                                    _selectedPayment == _payment[index]
                                        ? Colors.white
                                        : Colors.black,
                                height: 1.2,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // if (_selectedPayment == _payment[index])
              //   Align(
              //     alignment: Alignment.topRight,
              //     child: Image.asset(
              //       "assets/button_ok.png",
              //       width: 31,
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}
