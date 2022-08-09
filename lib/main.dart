// @dart=2.9

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:scorohod_app/bloc/orders_bloc/orders_bloc.dart';
import 'package:scorohod_app/pages/home.dart';
import 'package:scorohod_app/services/app_data.dart';
import 'package:scorohod_app/services/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  var provider = await DataProvider.getInstance();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<OrdersBloc>(create: (context) {
          return OrdersBloc();
        }),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => provider,
          ),
        ],
        child: OverlaySupport.global(
          child: MaterialApp(
            title: 'Scorohod',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: const HomePage(),
          ),
        ),
      ),
    ),
  );
}
