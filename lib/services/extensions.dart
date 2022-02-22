import 'package:flutter/material.dart';
import 'package:scorohod_app/services/formater.dart';

extension StringExtension on String {
  String capitalLetter() {
    if (isEmpty) {
      return this;
    } else {
      return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
    }
  }

  String typePhone() {
    var phone = replaceAll("+", "")
        .replaceAll("(", "")
        .replaceAll(")", "")
        .replaceAll("-", "")
        .replaceAll(" ", "");

    if (phone[0] == "8") {
      return "7${phone.substring(1)}";
    } else {
      return phone;
    }
  }

  String getPhoneFormatedString() {
    return MaskTextInputFormatter("+_ (___) ___-__-__").getMaskedText(
      typePhone(),
    );
  }
}

extension Contexts on BuildContext {
  Future<dynamic> nextPage(
    Widget page, {
    bool fullscreenDialog = false,
  }) {
    return Navigator.push(
      this,
      MaterialPageRoute(
        fullscreenDialog: fullscreenDialog,
        builder: (context) {
          return page;
        },
      ),
    );
  }

  Future<dynamic> changeMainPage(Widget page) {
    return Navigator.pushAndRemoveUntil(
      this,
      MaterialPageRoute(
        builder: (context) {
          return page;
        },
      ),
      (route) => false,
    );
  }

  void back<T extends Object?>([T? result]) {
    return Navigator.of(this).pop(result);
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    SnackBar snackBar,
  ) {
    return ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }
}
