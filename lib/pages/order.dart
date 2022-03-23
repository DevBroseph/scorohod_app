import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:scorohod_app/bloc/orders_bloc/orders_bloc.dart';
import 'package:scorohod_app/bloc/orders_bloc/orders_event.dart';
import 'package:scorohod_app/pages/order_info.dart';
import 'package:scorohod_app/pages/search.dart';
import 'package:scorohod_app/services/app_data.dart';
import 'package:scorohod_app/services/extensions.dart';
import 'package:scorohod_app/services/network.dart';
import 'package:scorohod_app/widgets/custom_text_field.dart';
import 'package:scorohod_app/widgets/deliver_widget.dart';
import 'package:scorohod_app/widgets/my_flushbar.dart';

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

  String _selectedPayment = 'Наличные';

  bool _loadData = false;
  bool _search = false;

  final List<String> _paymentImages = [
    "assets/payment_cash.png",
    "assets/payment_card.png",
    "assets/payment_card.png"
  ];
  List<String> _payment = ['Наличные', 'Картой'];

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

  void createOrder(OrdersBloc ordersBloc, DataProvider provider) async {
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
      MyFlushbar.showFlushbar(context, 'Скороход.', 'Укажите адрес доставки.');
      return;
    }
    var result = await NetHandler(context).createOrder(
        ordersBloc.products,
        'test',
        ordersBloc.totalPrice,
        provider.user.address,
        0.0,
        provider.currentShop.shopId);

    if (result != null) {
      widget.onTap;
      BlocProvider.of<OrdersBloc>(context).add(RemoveProducts());
      MyFlushbar.showFlushbar(context, 'Успешно.', 'Заказ оформлен.');
      Timer(const Duration(seconds: 4), () {
        Navigator.pop(context);
        context.nextPage(
            OrderInfoPage(
              color: widget.color,
              order: result,
              shop: provider.currentShop,
            ),
            fullscreenDialog: true);
      });
    } else {
      MyFlushbar.showFlushbar(context, 'Ошибка.', 'Не удалось оформить заказ.');
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DataProvider>(context);
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
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: widget.color,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 16.0, left: 15, right: 15, top: 20),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _search = true;
                      });
                    },
                    child: TextFieldCustom(
                      controller: _addressController,
                      keyboardType: TextInputType.text,
                      needCodeMask: false,
                      title: "Адрес доставки",
                      needPhoneMask: false,
                      enabled: false,
                      isRequired: true,
                    ),
                  ),
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
                  child: TextFieldCustom(
                    isRequired: true,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    needCodeMask: false,
                    title: "Номер телефона",
                    needPhoneMask: true,
                    enabled: true,
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
          Align(
            child: DeliverWidget(
              price: 12,
              color: widget.color,
              onTap: () => createOrder(bloc, provider),
            ),
            alignment: Alignment.bottomCenter,
          ),
        ],
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
                              style: TextStyle(
                                fontSize: 14,
                                color:
                                    // Colors.white,
                                    _selectedPayment == _payment[index]
                                        ? Colors.white
                                        : Colors.black,
                                height: 1.2,
                                fontFamily: 'SFUI',
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
