import 'package:flutter/material.dart';
import 'package:weather_app/route_generator.dart';
import 'package:get_it/get_it.dart';
import 'package:weather_app/src/models/current_data.dart';
import 'package:weather_app/src/models/daily_data.dart';
import 'package:weather_app/src/models/hourly_data.dart';
import 'package:weather_app/src/models/temp.dart';
import 'package:weather_app/src/models/weather.dart';
import 'package:weather_app/src/screens/main_page.dart';
import 'api.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void setupLocator() {
  GetIt.I.registerLazySingleton(() => ApisService());
}

void main() async {
  setupLocator();
  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(CurrentDataAdapter());
  Hive.registerAdapter(DailyDataAdapter());
  Hive.registerAdapter(HourlyDataAdapter());
  Hive.registerAdapter(WeatherAdapter());
  Hive.registerAdapter(TempAdapter());
  await Hive.openBox<CurrentData>('current_datas');
  await Hive.openBox<DailyData>('daily_datas');
  await Hive.openBox<HourlyData>('hourly_datas');
  await Hive.openBox<Weather>('weathers');
  await Hive.openBox<Weather>('temps');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MainPageWidget(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
