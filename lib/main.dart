import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scorohod_app/bloc/orders_bloc/orders_bloc.dart';
import 'package:scorohod_app/pages/home.dart';
import 'package:scorohod_app/services/constants.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<OrdersBloc>(create: (context) {
          return OrdersBloc();
        }),
      ],
      child: MaterialApp(
        title: 'Scorohod',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      ),
    ),
  );
}
