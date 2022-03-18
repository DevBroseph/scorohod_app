import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String name;
  String phone;
  String address;
  String room;
  String entrance;
  String floor;

  User({
    required this.name,
    required this.phone,
    required this.address,
    required this.room,
    required this.entrance,
    required this.floor,
  });
}

class AppData {
  AppData(this._preferences);

  final SharedPreferences _preferences;

  final String _userName = "userName";
  final String _userPhone = "userPhone";
  final String _userAddress = "userAddress";
  final String _userRoom = "userRoom";
  final String _userEntrance = "userEntrance";
  final String _userFloor = "userFloor";

  static Future<AppData> getInstance() async {
    var shared = await SharedPreferences.getInstance();
    return AppData(shared);
  }

  String getUserName() {
    return _preferences.getString(_userName) ?? "";
  }

  void setUserName(String value) {
    _preferences.setString(_userName, value);
  }

  String getUserPhone() {
    return _preferences.getString(_userPhone) ?? '';
  }

  void setUserPhone(String value) {
    _preferences.setString(_userPhone, value);
  }

  String getUserAddress() {
    return _preferences.getString(_userAddress) ?? "";
  }

  void setUserAddress(String value) {
    _preferences.setString(_userAddress, value);
  }

  String getUserRoom() {
    return _preferences.getString(_userRoom) ?? "";
  }

  void setUserRoom(String value) {
    _preferences.setString(_userRoom, value);
  }

  String getUserEntrance() {
    return _preferences.getString(_userEntrance) ?? '';
  }

  void setUserEnrance(String value) {
    _preferences.setString(_userEntrance, value);
  }

  String getUserFloor() {
    return _preferences.getString(_userFloor) ?? "";
  }

  void setUserFloor(String value) {
    _preferences.setString(_userFloor, value);
  }

  void setUser(User user) {
    _preferences.setString(_userName, user.name);
    _preferences.setString(_userPhone, user.phone);
    _preferences.setString(_userAddress, user.address);
    _preferences.setString(_userRoom, user.floor);
    _preferences.setString(_userEntrance, user.entrance);
    _preferences.setString(_userFloor, user.floor);
  }

  void setEmptyUser() {
    _preferences.setString(_userName, '');
    _preferences.setString(_userPhone, '');
    _preferences.setString(_userAddress, '');
    _preferences.setString(_userRoom, '');
    _preferences.setString(_userEntrance, '');
    _preferences.setString(_userFloor, '');
  }
}

class DataProvider extends ChangeNotifier {
  DataProvider(
    this._user,
  );

  User _user;

  User get user => _user;

  bool get hasUser => _user.name != '' ? true : false;

  static Future<DataProvider> getInstance() async {
    var userPrefs = await AppData.getInstance();

    return DataProvider(User(
      name: userPrefs.getUserName(),
      phone: userPrefs.getUserPhone(),
      address: userPrefs.getUserAddress(),
      room: userPrefs.getUserRoom(),
      entrance: userPrefs.getUserEntrance(),
      floor: userPrefs.getUserFloor(),
    ));
  }

  void setUser(User user) {
    _user = user;
    notifyListeners();
    AppData.getInstance().then(
      (value) {
        value.setUserName(user.name);
        value.setUserAddress(user.address);
        value.setUserPhone(user.phone);
        value.setUserRoom(user.room);
        value.setUserEnrance(user.entrance);
        value.setUserFloor(user.floor);
      },
    );
    changeUser(user);
  }

  void setUserName(String newName) {
    _user.name = newName;
    notifyListeners();
    AppData.getInstance().then(
      (value) => value.setUserName(newName),
    );
  }

  void setUserPhone(String newPhone) {
    _user.phone = newPhone;
    notifyListeners();
    AppData.getInstance().then(
      (value) => value.setUserPhone(newPhone),
    );
  }

  void setUserAddress(String newAddress) {
    _user.address = newAddress;
    notifyListeners();
    AppData.getInstance().then(
      (value) => value.setUserAddress(newAddress),
    );
  }

  void setUserRoom(String newRoom) {
    _user.room = newRoom;
    notifyListeners();
    AppData.getInstance().then(
      (value) => value.setUserRoom(newRoom),
    );
  }

  void setUserEntrance(String newEntrance) {
    _user.entrance = newEntrance;
    notifyListeners();
    AppData.getInstance().then(
      (value) => value.setUserEnrance(newEntrance),
    );
  }

  void setUserFloor(String newFloor) {
    _user.floor = newFloor;
    notifyListeners();
    AppData.getInstance().then(
      (value) => value.setUserFloor(newFloor),
    );
  }

  void signOutUser() {
    _user = User(
      name: '',
      phone: '',
      address: '',
      room: '',
      entrance: '',
      floor: '',
    );
    notifyListeners();

    AppData.getInstance().then((value) => value.setEmptyUser());
  }

  void changeUser(User user) {
    _user = user;
    notifyListeners();
    AppData.getInstance().then((value) {
      value.setUser(user);
    });
  }
}
