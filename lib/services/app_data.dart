import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scorohod_app/objects/coordinates.dart';
import 'package:scorohod_app/objects/shop.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  String id;
  String name;
  String phone;
  String address;
  String room;
  String entrance;
  String floor;
  LatLng latLng;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.room,
    required this.entrance,
    required this.floor,
    required this.latLng,
  });
}

class City {
  String nameRU;
  String nameENG;

  City({
    required this.nameRU,
    required this.nameENG,
  });
}

class AppData {
  AppData(this._preferences);

  final SharedPreferences _preferences;

  final String _userId = "userId";
  final String _userName = "userName";
  final String _userPhone = "userPhone";
  final String _userAddress = "userAddress";
  final String _userRoom = "userRoom";
  final String _userEntrance = "userEntrance";
  final String _userFloor = "userFloor";
  final String _userCityRU = "userCityRU";
  final String _userCityENG = "userCityENG";

  final String _userLatitude = "userLatitude";
  final String _userLongitude = "userLongitude";

  static Future<AppData> getInstance() async {
    var shared = await SharedPreferences.getInstance();
    return AppData(shared);
  }

  String getUserId() {
    return _preferences.getString(_userId) ?? "";
  }

  void setUserId(String value) {
    _preferences.setString(_userId, value);
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

  String getCityRu() {
    return _preferences.getString(_userCityRU) ?? "";
  }

  void setCityRu(String value) {
    _preferences.setString(_userCityRU, value);
  }
  String getCityENG() {
    return _preferences.getString(_userCityENG) ?? "";
  }

  void setCityENG(String value) {
    _preferences.setString(_userCityENG, value);
  }

  double getUserLatitude() {
    return _preferences.getDouble(_userLatitude) ?? 0.0;
  }

  void setUserLatitude(double value) {
    _preferences.setDouble(_userLatitude, value);
  }

  double getUserLogitude() {
    return _preferences.getDouble(_userLongitude) ?? 0.0;
  }

  void setUserLogitude(double value) {
    _preferences.setDouble(_userLongitude, value);
  }

  void setUser(User user) {
    _preferences.setString(_userId, user.id);
    _preferences.setString(_userName, user.name);
    _preferences.setString(_userPhone, user.phone);
    _preferences.setString(_userAddress, user.address);
    _preferences.setString(_userRoom, user.room);
    _preferences.setString(_userEntrance, user.entrance);
    _preferences.setString(_userFloor, user.floor);
    _preferences.setDouble(_userLatitude, user.latLng.latitude);
    _preferences.setDouble(_userLongitude, user.latLng.longitude);
  }

  void setCity(City city) {
    _preferences.setString(_userCityRU, city.nameRU);
    _preferences.setString(_userCityENG, city.nameENG);
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

class ShopData {
  ShopData(this._preferences);

  final SharedPreferences _preferences;

  final String _shopId = "shopId";
  final String _shopName = "shopName";
  final String _shopLogo = "shopLogo";
  final String _categoryId = "categoryId";
  final String _shopDescription = "shopDescription";
  final String _shopMinSum = "shopMinSum";
  final String _shopPriceDelivery = "shopPriceDelivery";
  final String _shopWorkingHours = "shopWorkingHours";
  final String _shopStatus = "shopStatus";
  final String _shopAddress = "shopAddress";
  final String _shopLatLng = "shopLatLng";
  final String _city = "shopAddress";
  final String _cityLatLng = "shopLatLng";

  static Future<ShopData> getInstance() async {
    var shared = await SharedPreferences.getInstance();
    return ShopData(shared);
  }

  String getShopId() {
    return _preferences.getString(_shopId) ?? "";
  }

  void setShopId(String value) {
    _preferences.setString(_shopId, value);
  }

  String getShopName() {
    return _preferences.getString(_shopName) ?? '';
  }

  void setShopName(String value) {
    _preferences.setString(_shopName, value);
  }

  String getShopLogo() {
    return _preferences.getString(_shopLogo) ?? "";
  }

  void setShopLogo(String value) {
    _preferences.setString(_shopLogo, value);
  }

  String getCategoryId() {
    return _preferences.getString(_categoryId) ?? "";
  }

  void setCategoryId(String value) {
    _preferences.setString(_categoryId, value);
  }

  String getShopDescription() {
    return _preferences.getString(_shopDescription) ?? '';
  }

  void setShopDescription(String value) {
    _preferences.setString(_shopDescription, value);
  }

  String getShopMinSum() {
    return _preferences.getString(_shopMinSum) ?? "";
  }

  void setShopMinSum(String value) {
    _preferences.setString(_shopMinSum, value);
  }

  String getPriceDelivery() {
    return _preferences.getString(_shopPriceDelivery) ?? "";
  }

  void setPriceDelivery(String value) {
    _preferences.setString(_shopPriceDelivery, value);
  }

  String getWorkingHours() {
    return _preferences.getString(_shopWorkingHours) ?? '';
  }

  void setWorkingHours(String value) {
    _preferences.setString(_shopWorkingHours, value);
  }

  String getShopStatus() {
    return _preferences.getString(_shopStatus) ?? "";
  }

  void setShopStatus(String value) {
    _preferences.setString(_shopStatus, value);
  }

  String getShopAddress() {
    return _preferences.getString(_shopAddress) ?? '';
  }

  void setShopAddress(String value) {
    _preferences.setString(_shopAddress, value);
  }

  String getShopLatLng() {
    return _preferences.getString(_shopLatLng) ?? "";
  }

  void setShopLatLng(String value) {
    _preferences.setString(_shopLatLng, value);
  }

  String getCity() {
    return _preferences.getString(_city) ?? '';
  }

  void setCity(String value) {
    _preferences.setString(_city, value);
  }

  String getCityLatLng() {
    return _preferences.getString(_cityLatLng) ?? "";
  }

  void setCityLatLng(String value) {
    _preferences.setString(_cityLatLng, value);
  }

  void setShop(Shop shop) {
    _preferences.setString(_shopId, shop.shopId);
    _preferences.setString(_shopName, shop.shopName);
    _preferences.setString(_shopLogo, shop.shopLogo);
    _preferences.setString(_categoryId, shop.categoryId);
    _preferences.setString(_shopDescription, shop.shopDescription);
    _preferences.setString(_shopMinSum, shop.shopMinSum);
    _preferences.setString(_shopPriceDelivery, shop.shopPriceDelivery);
    _preferences.setString(_shopWorkingHours, shop.shopWorkingHours);
    _preferences.setString(_shopStatus, shop.shopStatus);
  }

  void setEmptyShop() {
    _preferences.setString(_shopId, '');
    _preferences.setString(_shopName, '');
    _preferences.setString(_shopLogo, '');
    _preferences.setString(_categoryId, '');
    _preferences.setString(_shopDescription, '');
    _preferences.setString(_shopMinSum, '');
    _preferences.setString(_shopPriceDelivery, '');
    _preferences.setString(_shopWorkingHours, '');
    _preferences.setString(_shopStatus, '');
  }
}

class DataProvider extends ChangeNotifier {
  DataProvider(this._user, this._currentShop, this._city);

  User _user;
  User get user => _user;
  bool get hasUser => _user.name != '' ? true : false;

  Shop _currentShop;
  Shop get currentShop => _currentShop;
  bool get hasCurrentShop => _currentShop.shopName != '' ? true : false;

  City _city;
  City get city => _city;
  bool get hasCity => _city.nameRU != '' ? true : false;

  static Future<DataProvider> getInstance() async {
    var userPrefs = await AppData.getInstance();
    var cityPrefs = await AppData.getInstance();
    var shopPrefs = await ShopData.getInstance();

    return DataProvider(
      User(
        id: userPrefs.getUserId(),
        name: userPrefs.getUserName(),
        phone: userPrefs.getUserPhone(),
        address: userPrefs.getUserAddress(),
        room: userPrefs.getUserRoom(),
        entrance: userPrefs.getUserEntrance(),
        floor: userPrefs.getUserFloor(),
        latLng:
            LatLng(userPrefs.getUserLatitude(), userPrefs.getUserLogitude()),
      ),
      Shop(
        categoryId: shopPrefs.getCategoryId(),
        shopDescription: shopPrefs.getShopDescription(),
        shopId: shopPrefs.getShopId(),
        shopLogo: shopPrefs.getShopLogo(),
        shopMinSum: shopPrefs.getShopMinSum(),
        shopName: shopPrefs.getShopName(),
        shopPriceDelivery: shopPrefs.getPriceDelivery(),
        shopStatus: shopPrefs.getShopStatus(),
        shopWorkingHours: shopPrefs.getWorkingHours(),
        shopAddress: shopPrefs.getShopAddress(),
        coordinates: Coordinates(latitude: 0, longitude: 0),
        city: shopPrefs.getCity(),
        cityCoordinates: Coordinates(latitude: 0, longitude: 0),
      ),
      City(
        nameRU: cityPrefs.getCityRu(),
        nameENG: cityPrefs.getCityENG()
      )
    );
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

  void setShop(Shop shop) {
    _currentShop = shop;
    notifyListeners();
    ShopData.getInstance().then(
      (value) {
        value.setShopId(shop.shopId);
        value.setShopName(shop.shopName);
        value.setShopLogo(shop.shopLogo);
        value.setCategoryId(shop.categoryId);
        value.setShopDescription(shop.shopDescription);
        value.setShopMinSum(shop.shopMinSum);
        value.setPriceDelivery(shop.shopPriceDelivery);
        value.setWorkingHours(shop.shopWorkingHours);
        value.setShopStatus(shop.shopStatus);
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

  void setUserLatLng(LatLng latLng) {
    _user.latLng = latLng;
    notifyListeners();
    AppData.getInstance().then((value) {
      value.setUserLatitude(latLng.latitude);
      value.setUserLogitude(latLng.longitude);
    });
  }

  void signOutUser() {
    _user = User(
        id: '',
        name: '',
        phone: '',
        address: '',
        room: '',
        entrance: '',
        floor: '',
        latLng: LatLng(0, 0));
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

  void changeCity(City city) {
    _city = city;
    notifyListeners();
    AppData.getInstance().then((value) {
      value.setCity(city);
    });
  }

  void changeShop(Shop shop) {
    _currentShop = shop;
    notifyListeners();
    ShopData.getInstance().then((value) {
      value.setShop(shop);
    });
  }
}
