import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
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
// import 'package:weather_app/src/widgets/DailyCardWidget.dart';

class DailyPageWidget extends StatefulWidget {
  @override
  _DailyPageWidgetState createState() => _DailyPageWidgetState();
}

class _DailyPageWidgetState extends State<DailyPageWidget> {
  late DatabaseHandler handler;
  bool? _isLoading;

  CurrentWeatherData _currentData = CurrentWeatherData();
  ListHourlyData _listHourlyData = ListHourlyData();
  ListDailyData _listDailyData = ListDailyData();
  CurrentData curr = CurrentData();
  dynamic listHourlyData = <HourlyData>[];
  List<DailyData> listDailyData = <DailyData>[];
  var format = new DateFormat('EEEE');
  var abbrFormat = new DateFormat(DateFormat.ABBR_WEEKDAY);
  String timezone = "7 Days";
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

    listDailyData = await _listDailyData.getDailyWeatherData();

    if (kDebugMode) {
      print("end");
    }

    setState(() {
      _isLoading = false;
    });
  }

  Widget build(BuildContext context) {
    if (_isLoading == true) {
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
                  child: Image.asset('img/calendar.png'),
                ),
                SizedBox(
                  width: 7,
                ),
                Text(
                  '7 Days',
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                CurrentCardWidget(
                  daily: listDailyData[0],
                ),
                ValueListenableBuilder<Box<DailyData>>(
                    valueListenable: Boxes.getDailyData().listenable(),
                    builder: (context, box, _) {
                      final transactions =
                          box.values.toList().cast<DailyData>();

                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: (transactions.length),
                        itemBuilder: (BuildContext context, int index) {
                          final helper = transactions[index];
                          return Card(
                            child: ListTile(
                                leading: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minWidth: 44,
                                      minHeight: 44,
                                      maxWidth: 64,
                                      maxHeight: 64,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          '${abbrFormat.format(DateTime.fromMillisecondsSinceEpoch(helper.dt! * 1000))}',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    )),
                                contentPadding: EdgeInsets.all(8.0),
                                title: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 40,
                                        ),
                                        Image.network(
                                            "http://openweathermap.org/img/wn/${helper.weather![0].icon.toString()}@4x.png",
                                            fit: BoxFit.fill),
                                        Text(helper.weather![0].main.toString())
                                      ],
                                    )),
                                trailing: Text(
                                    '${helper.temp!.max!.toStringAsFixed(0)}\u00B0/${helper.temp!.min!.toStringAsFixed(0)}\u00B0')),
                          );
                        },
                      );
                    })
              ],
            ),
          )

          // floatingActionButton: FloatingActionButton(
          //   child: const Icon(Icons.search),
          //   onPressed: () {
          //     Navigator.of(context).pushNamed('/Search');
          //   },
          // ),
          );
    }
  }
}
