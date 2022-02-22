import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:scorohod_app/objects/error.dart';
import 'package:scorohod_app/objects/group.dart';
import 'package:scorohod_app/objects/product.dart';
import 'package:scorohod_app/objects/shop.dart';
import 'package:scorohod_app/services/constants.dart';
import 'package:scorohod_app/services/extensions.dart';

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
        context.showSnackBar(
          SnackBar(
            content: Text(answerErrorFromJson(response.body).message),
          ),
        );
        break;
      default:
        // context.changeMainPage(const NoInternet());
        break;
    }

    return null;
  }

  Future<List<Shop>?> getShops() async {
    var data = await _request(
      url: "shops",
      method: Method.get,
    );

    return data != null ? shopsFromJson(data) : null;
  }

  Future<List<Group>?> getGroups() async {
    var data = await _request(
      url: "groups",
      method: Method.get,
    );

    return data != null ? groupsFromJson(data) : null;
  }

  Future<List<Product>?> getProducts() async {
    var data = await _request(
      url: "nomenclatures",
      method: Method.get,
    );

    return data != null ? productsFromJson(data) : null;
  }
}
