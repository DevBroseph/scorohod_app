import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:scorohod_app/objects/category.dart';
import 'package:scorohod_app/objects/city_coordinates.dart';
import 'package:scorohod_app/objects/coordinates.dart';
import 'package:scorohod_app/objects/courier_location.dart';
import 'package:scorohod_app/objects/delivery.dart';
import 'package:scorohod_app/objects/error.dart';
import 'package:scorohod_app/objects/group.dart';
import 'package:scorohod_app/objects/info.dart';
import 'package:scorohod_app/objects/order.dart';
import 'package:scorohod_app/objects/order_element.dart';
import 'package:scorohod_app/objects/product.dart';
import 'package:scorohod_app/objects/shop.dart';
import 'package:scorohod_app/objects/user.dart' as object;
import 'package:scorohod_app/services/app_data.dart';
import 'package:scorohod_app/services/constants.dart';
import 'package:scorohod_app/services/extensions.dart';

import '../objects/courier_info.dart';

enum Method { get, post, put, delete, patch }

class NetHandler {
  const NetHandler(this.context);
  final BuildContext context;

  Future<String?> _request({
    required String url,
    required Method method,
    Map<String, String>? params,
  }) async {
    // var token = await FirebaseAuth.instance.currentUser?.getIdToken();
    var headers = {"authorization": "Bearer", "version": "1"};
    var uri = Uri.parse(apiUrl + url);

    late Response response;

    switch (method) {
      case Method.get:
        response = await get(uri, headers: headers);
        break;
      case Method.post:
        response = await post(uri, body: params, headers: headers);
        break;
      case Method.put:
        response = await put(uri, body: params, headers: headers);
        break;
      case Method.patch:
        response = await patch(uri, body: params, headers: headers);
        break;
      case Method.delete:
        response = await delete(uri, body: params, headers: headers);
        break;
    }

    switch (response.statusCode) {
      case 200:
        return response.body;
      case 400:
        // context.showSnackBar(
        //   SnackBar(
        //     content: Text(answerErrorFromJson(response.body).message),
        //   ),
        // );
        break;
      default:
        // context.changeMainPage(const NoInternet());
        break;
    }

    return null;
  }

  Future<List<Category>?> getCategories() async {
    var data = await _request(
      url: "categories",
      method: Method.get,
    );
    // print(data);
    return data != null ? categoriesFromJson(data) : null;
  }

  Future<List<Shop>?> getShops() async {
    var data = await _request(
      url: "shops",
      method: Method.get,
    );
    // print(data);

    return data != null ? shopsFromJson(data) : null;
  }

  Future<List<Shop>?> getCityShops(city) async {
    print(city);
    var data = await _request(
      url: 'shops/$city',
      method: Method.get,
    );
    print(data);

    return data != null ? shopsFromJson(data) : null;
  }

  Future<List<CityCoordinates>?> getCoordinates() async {
    var data = await _request(url: "coordinates", method: Method.get);
    print(data);

    return data != null ? cityCoordinatesFromJson(data) : null;
  }

  Future<List<Group>?> getGroups() async {
    var data = await _request(
      url: "groups",
      method: Method.get,
    );

    return data != null ? groupsFromJson(data) : null;
  }

  Future<List<Group>?> getCurrentGroup(String currentGroup) async {
    var data = await _request(
      url: "groups/$currentGroup",
      method: Method.get,
    );

    return data != null ? groupsFromJson(data) : null;
  }

  Future<List<Product>?> getProducts() async {
    var data = await _request(
      url: "nomenclatures",
      method: Method.get,
    );
    // print(data);
    return data != null ? productsFromJson(data) : null;
  }

  Future<List<Product>?> getProductsByShop(String shopId) async {
    var data = await _request(
      url: "nomenclatures/$shopId",
      method: Method.get,
    );
    // print(data);
    return data != null ? productsFromJson(data) : null;
  }

  Future<Order?> createOrder(
    List<OrderElement> orderElements,
    String clientId,
    double price,
    String address,
    LatLng userLatLng,
    double discount,
    String shopId,
    String fcmToken,
    String city,
  ) async {
    var data = await _request(
      url: "order",
      params: {
        'status': 'new_order',
        'products': ordersElementsToJson(orderElements),
        'total_price': price.toString(),
        'client_id': clientId,
        'address': address,
        'user_lat_lng': coordinatesToJson(Coordinates(
            latitude: userLatLng.latitude, longitude: userLatLng.longitude)),
        'discount': discount.toString(),
        'receipt_id': 'null',
        'shop_id': shopId,
        'fcm_token': fcmToken,
        'city': city,
      },
      method: Method.post,
    );
    print(fcmToken);
    return data != null ? orderFromJson(data) : null;
  }

  Future<List<Order>?> getOrders(String clientId) async {
    var data = await _request(
      url: "order/$clientId",
      method: Method.get,
    );
    return data != null ? ordersFromJson(data) : null;
  }

  Future<CourierLocation?> getCourierLocation(String orderId) async {
    var data = await _request(
      url: "order/0/$orderId",
      method: Method.get,
    );
    return data != null ? courierLocationFromJson(data) : null;
  }

  Future<CourierInfo?> getCourierInfo(String id) async {
    var data = await _request(
      url: "couriers/17",
      method: Method.get,
    );
    return data != null ? courierInfoFromJson(data) : null;
  }

  Future<object.User?> auth(
      String name,
      String phone,
      String token,
      String uid,
      String os,
      String address,
      String room,
      String entrance,
      String floor) async {
    var data = await _request(
      url: "auth",
      params: {
        'user_name': name,
        'phone': phone,
        'token': token,
        'uid': uid,
        'os': os,
        'address': address,
        'room': room,
        'entrance': entrance,
        'floor': floor,
      },
      method: Method.post,
    );
    return data != null ? object.userFromJson(data) : null;
  }

  Future<object.User?> updateUser(
      String userId,
      String name,
      String phone,
      String token,
      String uid,
      String os,
      String address,
      String room,
      String entrance,
      String floor) async {
    var data = await _request(
      url: "auth/$userId",
      params: {
        'user_name': name,
        'phone': phone,
        'token': token,
        'uid': uid,
        'os': os,
        'address': address,
        'room': room,
        'entrance': entrance,
        'floor': floor,
      },
      method: Method.put,
    );
    return data != null ? object.userFromJson(data) : null;
  }

  Future<object.User?> getUser(String phone) async {
    print(phone);
    var data = await _request(
      url: "auth/$phone",
      method: Method.get,
    );
    print(data);
    try {
      return data != null ? object.userFromJson(data) : null;
    } catch (e) {
      return null;
    }
  }

  Future<Info?> getInfo() async {
    var data = await _request(
      url: "info",
      method: Method.get,
    );

    return data != null ? infoFromJson(data) : null;
  }

  Future<DeliveryInfo?> getDeliveryInfo() async {
    var data = await _request(
      url: "delivery",
      method: Method.get,
    );

    print(data);

    return data != null ? deliveryInfoFromJson(data) : null;
  }
}
