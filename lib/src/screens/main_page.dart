import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_app/api.dart';
import 'package:weather_app/services/boxes.dart';
import 'package:weather_app/services/database_handler.dart';
import 'package:weather_app/src/models/current_data.dart';
import 'package:weather_app/src/models/daily_data.dart';
import 'package:weather_app/src/models/hourly_data.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/src/widgets/CurrentCardWidget.dart';

class MainPageWidget extends StatefulWidget {
  @override
  _MainPageWidgetState createState() => _MainPageWidgetState();
}

class _MainPageWidgetState extends State<MainPageWidget> {
  late DatabaseHandler handler;
  bool? _isLoading;

  CurrentWeatherData _currentData = CurrentWeatherData();
  ListHourlyData _listHourlyData = ListHourlyData();
  ListDailyData _listDailyData = ListDailyData();
  CurrentData curr = CurrentData();
  dynamic listHourlyData = <HourlyData>[];
  dynamic listDailyData = <DailyData>[];
  var format = new DateFormat('dd MMMM');
  var hourFormat = new DateFormat('HH:mm');
  String timezone = "Location";
  ApisService get service => GetIt.I<ApisService>();

  void initState() {
    _fetchDatas();
    super.initState();
    handler = DatabaseHandler();
  }

  _fetchDatas() async {
    setState(() {
      _isLoading = true;
    });

    if (kDebugMode) {
      print("start");
    }
    listHourlyData = await _listHourlyData.getHourlyWeatherData();
    curr = await _currentData.getCurrentWeatherData();
    Response data = await service.getWeatherData();
    String all = data.data['timezone'];
    String last = all.split("/").last;
    timezone = last;

    if (kDebugMode) {
      print("end");
    }

    setState(() {
      _isLoading = false;
    });
  }

  Widget build(BuildContext context) {
    if (curr.weather == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue,
          elevation: 0,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 23,
                child: Image.asset('img/location.png'),
              ),
              SizedBox(
                width: 7,
              ),
              Text(
                '${timezone}',
              ),
            ],
          ),
          leading: new IconButton(
            icon: new Icon(Icons.dashboard),
            onPressed: () {},
          ),
          actions: [
            PopupMenuButton(
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text("First"),
                        value: 1,
                      ),
                      PopupMenuItem(
                        child: Text("Second"),
                        value: 2,
                      )
                    ])
          ],
        ),
        body: Column(
          children: [
            ValueListenableBuilder<Box<CurrentData>>(
              valueListenable: Boxes.getCurrentData().listenable(),
              builder: (context, box, _) {
                final transactions = box.values.toList().cast<CurrentData>();

                return CurrentCardWidget(
                  curr: transactions[0],
                );
              },
            ),
            SizedBox(
              height: 60,
              child: Row(children: [
                SizedBox(
                  width: 20,
                ),
                Container(
                  child: Text(
                    'Today',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  alignment: Alignment.centerLeft,
                ),
                SizedBox(
                  width: 200,
                ),
                TextButton(
                  onPressed: () async {
                    await Navigator.of(context).pushNamed('/Daily');
                  },
                  child: Text(
                    '7 Days >',
                    style: TextStyle(fontSize: 15),
                  ),
                )
              ]),
            ),
            ValueListenableBuilder<Box<HourlyData>>(
                valueListenable: Boxes.getHourlyData().listenable(),
                builder: (context, box, _) {
                  final transactions = box.values.toList().cast<HourlyData>();

                  return Expanded(
                      child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: transactions.length,
                    itemBuilder: (BuildContext context, int index) {
                      final helper = transactions[index];
                      return SizedBox(
                          width: 80,
                          height: 60,
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(top: 5.0),
                                child: Column(
                                  children: [
                                    Text(
                                        '  ${helper.temp?.toStringAsFixed(0)}\u00B0'),
                                    SizedBox(
                                      height: 40,
                                      child: Image.network(
                                          "http://openweathermap.org/img/wn/${helper.weather![0].icon.toString()}@4x.png",
                                          fit: BoxFit.fill),
                                    ),
                                    Text(
                                        '${hourFormat.format(DateTime.fromMillisecondsSinceEpoch(helper.dt! * 1000))}'),
                                  ],
                                ),
                              )));
                    },
                  ));
                })
          ],
        ),
      );
    }
  }
}
