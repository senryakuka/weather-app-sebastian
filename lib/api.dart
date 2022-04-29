import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class ApisService {
  //masterUrl
  final String dest = 'https://invent-integrasi.com/test_core/v1/';

  Future getProducts() async {
    String apiUrl = dest + "get_m_product";

    Response response;
    Dio dio = Dio();

    if (kDebugMode) {
      print("API Get Products");
    }

    response = await dio.get(apiUrl,
        options: Options(headers: {"Accept": "Application/json"}));

    // var items = json.decode(response.data);

    if (kDebugMode) {
      print(response);
    }
    return response.data;
  }

  Future getProductsPrices() async {
    String apiUrl = dest + "get_product_price";

    Response response;
    Dio dio = Dio();

    if (kDebugMode) {
      print("API Get Products Prices");
    }

    response = await dio.get(apiUrl,
        options: Options(headers: {"Accept": "Application/json"}));

    // var items = json.decode(response.data);

    if (kDebugMode) {
      print(response);
    }
    return response.data;
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    if (kDebugMode) {
      print("chekpoint1");
    }

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (kDebugMode) {
      print("chekpoint2");
    }

    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    if (kDebugMode) {
      print("chekpoint3");
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (kDebugMode) {
      print("chekpoint4");
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    if (kDebugMode) {
      print("chekpoint5");
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future getWeatherData() async {
    if (kDebugMode) {
      print("Start of get Weather Data");
    }

    Position currPos = await _getGeoLocationPosition();

    if (kDebugMode) {
      print("Getting Position");
    }

    if (kDebugMode) {
      print("Latitude: " +
          currPos.latitude.toString() +
          "\nLongitude: " +
          currPos.longitude.toString());
    }

    String apiUrl = "https://api.openweathermap.org/data/2.5/onecall?lat=" +
        currPos.latitude.toString() +
        "&lon=" +
        currPos.longitude.toString() +
        "&exclude=minutely&units=metric&appid=45865970ebbfbc127eb2a16dd7f753e7";

    Response response;
    Dio dio = Dio();

    if (kDebugMode) {
      print("API Get Weather Data");
    }

    response = await dio.get(apiUrl,
        options: Options(headers: {"Accept": "Application/json"}));

    // var items = json.decode(response.data);

    // if (kDebugMode) {
    //   print('${response.runtimeType} : $response');
    // }
    // if (kDebugMode) {
    //   print('${response.data.runtimeType} : ${response.data}');
    // }
    // if (kDebugMode) {
    //   print('${response.statusCode}');
    // }
    if (kDebugMode) {
      print("API Get Weather Data Complete");
    }

    return (response);
  }
}
