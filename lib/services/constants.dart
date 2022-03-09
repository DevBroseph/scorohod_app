import 'package:flutter/material.dart';

const String apiUrl = "https://server.scorohod.shop/user/";

const Color grey = Color(0xFFF7F5Fa);
const Color red = Color(0xFFFE4539);

const BorderRadius radius = BorderRadius.all(
  Radius.circular(15),
);

final List<BoxShadow> shadow = [
  BoxShadow(
    color: Colors.black.withOpacity(0.1),
    spreadRadius: 1,
    blurRadius: 5,
  ),
];

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: red,
  backgroundColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  cardColor: Colors.grey[100],
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedIconTheme: IconThemeData(color: red),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: red,
  ),
  appBarTheme: AppBarTheme(
    centerTitle: true,
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    shadowColor: Colors.black.withOpacity(0.2),
    titleTextStyle: const TextStyle(
      color: Colors.black,
      fontSize: 18,
    ),
  ),
  textTheme: const TextTheme().apply(
    bodyColor: Colors.black,
    displayColor: Colors.black,
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: red,
  backgroundColor: Colors.black,
  scaffoldBackgroundColor: Colors.black,
  cardColor: Colors.grey[900],
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
    selectedIconTheme: IconThemeData(color: red),
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: red,
  ),
  appBarTheme: AppBarTheme(
    centerTitle: true,
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    shadowColor: Colors.black.withOpacity(0.2),
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 18,
    ),
  ),
  textTheme: const TextTheme().apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),
);
