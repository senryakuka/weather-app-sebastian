import 'package:intl/intl.dart';
import 'package:weather_app/api.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:weather_app/services/boxes.dart';
import 'package:weather_app/src/models/current_data.dart';
import 'package:weather_app/src/models/daily_data.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DailyCardWidget extends StatefulWidget {
  List<DailyData>? daily;

  @override
  _DailyCardWidgetState createState() => _DailyCardWidgetState();

  DailyCardWidget({Key? key, this.daily}) : super(key: key);
}

class _DailyCardWidgetState extends State<DailyCardWidget> {
  ApisService? get service => GetIt.I<ApisService>();
  var format = new DateFormat('dd MMMM');
  var abbrFormat = new DateFormat(DateFormat.ABBR_WEEKDAY);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: EdgeInsets.all(8),
            itemCount: widget.daily?.length,
            itemBuilder: (BuildContext context, int index) {
              final transaction = widget.daily?[index];

              return buildTransaction(context, transaction!);
            },
          ),
        ),
      ],
    );
  }

  Widget buildTransaction(
    BuildContext context,
    DailyData dailyData,
  ) {
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
                    '${abbrFormat.format(DateTime.fromMillisecondsSinceEpoch(dailyData.dt! * 1000))}',
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
                      "http://openweathermap.org/img/wn/${dailyData.weather![0].icon.toString()}@4x.png",
                      fit: BoxFit.fill),
                  Text(dailyData.weather![0].main.toString())
                ],
              )),
          trailing: Text(
              '${dailyData.temp!.max!.toStringAsFixed(0)}\u00B0/${dailyData.temp!.min!.toStringAsFixed(0)}\u00B0')),
    );
  }
}
