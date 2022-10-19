import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:scorohod_app/objects/coordinates.dart';
import 'package:scorohod_app/objects/courier_info.dart';
import 'package:scorohod_app/objects/order.dart';
import 'package:scorohod_app/objects/shop.dart';
import 'package:scorohod_app/services/app_data.dart';
import 'package:scorohod_app/services/constants.dart';
import 'package:scorohod_app/services/directions_model.dart';
import 'package:scorohod_app/services/directions_repository.dart';
import 'package:scorohod_app/services/network.dart';
import 'package:scorohod_app/widgets/order_element.dart';

class OrderInfoPage extends StatefulWidget {
  const OrderInfoPage({
    Key? key,
    required this.color,
    required this.order,
    required this.shop,
  }) : super(key: key);

  final Color color;
  final Order order;
  final Shop shop;

  @override
  State<OrderInfoPage> createState() => _OrderInfoPageState();
}

class _OrderInfoPageState extends State<OrderInfoPage> {
  GoogleMapController? _mapController;

  Coordinates? _courierCoordinates;

  Marker? _courierMarker;
  Marker? _userMarker;
  Marker? _shopMarker;

  BitmapDescriptor? _shopIcon;
  BitmapDescriptor? _courierIcon;
  BitmapDescriptor? _userIcon;

  Directions? _info;
  CourierInfo? _courierInfo;

  bool _mapInit = false;

  void setMarks(DataProvider provider) async {
    var userLatLng = LatLng(
        widget.order.userLatLng.latitude, widget.order.userLatLng.longitude);
    var shopLatLng = LatLng(
        widget.shop.coordinates.latitude, widget.shop.coordinates.longitude);
    setState(() {
      _userMarker = Marker(
        markerId: const MarkerId('userMarker'),
        icon: _userIcon!,
        position: userLatLng,
      );
      _shopMarker = Marker(
        markerId: const MarkerId('shopMarker'),
        icon: _shopIcon!,
        position: shopLatLng,
      );
      if (_courierCoordinates != null) {
        _courierMarker = Marker(
          markerId: const MarkerId('courierMarker'),
          icon: _courierIcon!,
          position: LatLng(
              _courierCoordinates!.latitude, _courierCoordinates!.longitude),
        );
      }
    });
    final directions = await DirectionsRepository(dio: null)
        .getDirections(origin: userLatLng, destination: shopLatLng);
    setState(() {
      _info = directions;
      _mapInit = true;
    });
  }

  @override
  void dispose() {
    if (_mapController != null) {
      _mapController!.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _getCourierLocation();
    _getIcons();
    _getCourierInfo();
    super.didChangeDependencies();
  }

  void _getCourierInfo() async {
    var result = await NetHandler(context).getCourierInfo('17');
    if (result != null) {
      setState(() {
        _courierInfo = result;
      });
      print(result.courierPhone);
    }
  }

  void _getIcons() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(devicePixelRatio: 3.2), 'assets/bag.png')
        .then((d) {
      setState(() {
        _shopIcon = d;
      });
    });

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(devicePixelRatio: 3.2),
            'assets/courier.png')
        .then((d) {
      setState(() {
        _courierIcon = d;
      });
    });

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(devicePixelRatio: 3.2),
            'assets/location.png')
        .then((d) {
      setState(() {
        _userIcon = d;
      });
    });
  }

  void _getCourierLocation() async {
    var result =
        await NetHandler(context).getCourierLocation(widget.order.orderId);
    if (result != null && result.courierLocation != null) {
      setState(() {
        _courierCoordinates = result.courierLocation!.courierLocation;
      });
    }
    setMarks(Provider.of<DataProvider>(context, listen: false));
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DataProvider>(context);
    if (_userMarker == null &&
        _shopMarker == null &&
        _courierIcon != null &&
        _shopIcon != null &&
        _userIcon != null) {
      setMarks(provider);
      // print(widget.order.userLatLng);
    }
    return Scaffold(
      body: Stack(
        children: [
          if (_info != null && _courierInfo != null)
            CustomScrollView(slivers: [
              SliverAppBar(
                pinned: true,
                // elevation: 0,
                foregroundColor: widget.color,
                // expandedHeight: 210,
                title: Text(
                  'Ваш заказ',
                  style: GoogleFonts.rubik(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: widget.color,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 15),
                  child: Text(
                    getStatus(widget.order.status),
                    style: GoogleFonts.rubik(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 15, left: 15, right: 15),
                  child: ClipRRect(
                    borderRadius: radius,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: radius, boxShadow: shadow),
                      child: LinearProgressBar(
                        maxSteps: 5,
                        progressType: LinearProgressBar.progressTypeLinear,
                        currentStep: getIntStatus(widget.order.status),
                        minHeight: 8,
                        progressColor: red,
                        dotsSpacing: EdgeInsets.all(20),
                        backgroundColor: Colors.grey[200],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                  child: ClipRRect(
                    borderRadius: radius,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                          borderRadius: radius, boxShadow: shadow),
                      child: Align(
                        child: GoogleMap(
                            myLocationButtonEnabled: false,
                            zoomControlsEnabled: false,
                            initialCameraPosition: CameraPosition(
                              target: getCenterLatLng(provider),
                              zoom: 11.5,
                            ),
                            markers: {
                              if (_userMarker != null) _userMarker!,
                              if (_shopMarker != null) _shopMarker!,
                              if (_courierMarker != null) _courierMarker!
                            },
                            polylines: {
                              if (_info != null && _mapInit)
                                Polyline(
                                  polylineId: PolylineId('route'),
                                  color: red,
                                  width: 5,
                                  points: _info!.polylinePoints
                                      .map((e) =>
                                          LatLng(e.latitude, e.longitude))
                                      .toList(),
                                )
                            },
                            onMapCreated: (controller) {
                              _mapController = controller;
                              _mapController!.animateCamera(
                                  CameraUpdate.newLatLngBounds(
                                      _info!.bounds, 50.0));
                            }
                            ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context, index) => OrderElementCard(
                        orderElement: widget.order.products[index]),
                    childCount: widget.order.products.length),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),
              SliverToBoxAdapter(
                child: Column(children: [
                  Text(
                    'Итого',
                    style: GoogleFonts.rubik(
                        fontSize: 15, color: Colors.grey[500]),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    double.parse(widget.order.totalPrice).toStringAsFixed(2) +
                        ' ₽',
                    style: GoogleFonts.rubik(
                        color: Colors.grey[900],
                        fontWeight: FontWeight.w500,
                        fontSize: 22),
                  )
                ]),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),
              SliverToBoxAdapter(
                child: Column(children: [
                  _bottomCard('Номер заказа', widget.order.orderId, height: 70),
                  _bottomCard(
                    'Дата заказа',
                    DateFormat('dd.MM.yyyy в HH:mm').format(
                      DateTime.fromMillisecondsSinceEpoch(
                          int.parse(widget.order.date) * 1000),
                    ),
                  ),
                  _bottomCard(
                    'Магазин',
                    widget.shop.shopName,
                  ),
                  _bottomCard(
                    'Адрес доставки',
                    widget.order.address,
                  ),
                  _bottomCard(
                    'Номер курьера',
                    _courierInfo!.courierPhone == '' ? 'Номер не указан' : _courierInfo!.courierPhone,
                  ),
                ]),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 50),
              ),
            ]),
          if (_info == null || _courierInfo == null)
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Align(
                alignment: Alignment.center,
                child: LoadingAnimationWidget.horizontalRotatingDots(
                  color: Theme.of(context).primaryColor,
                  size: 50,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _bottomCard(String title, String subtitle, {double? height}) {
    return SizedBox(
      height: height ?? 80,
      child: ListTile(
        title: Text(
          title,
          style: GoogleFonts.rubik(
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
              fontSize: 15),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            subtitle,
            style: GoogleFonts.rubik(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 15),
          ),
        ),
      ),
    );
  }

  LatLng getCenterLatLng(DataProvider provider) {
    var userLatLng = LatLng(
        widget.shop.coordinates.latitude, widget.shop.coordinates.longitude);
    var shopLatLng =
        LatLng(provider.user.latLng.latitude, provider.user.latLng.longitude);
    var betweenPolylineLatLng = LatLng(
        _info!.polylinePoints[_info!.polylinePoints.length ~/ 2].latitude,
        _info!.polylinePoints[_info!.polylinePoints.length ~/ 2].longitude);
    return LatLng(
        (userLatLng.latitude +
                shopLatLng.latitude +
                betweenPolylineLatLng.latitude) /
            3,
        (userLatLng.longitude +
                shopLatLng.longitude +
                betweenPolylineLatLng.longitude) /
            3);
  }
}
