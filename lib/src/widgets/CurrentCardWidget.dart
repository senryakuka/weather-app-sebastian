import 'package:intl/intl.dart';
import 'package:weather_app/api.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:weather_app/services/boxes.dart';
import 'package:weather_app/src/models/current_data.dart';
import 'package:weather_app/src/models/daily_data.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CurrentCardWidget extends StatefulWidget {
  CurrentData? curr;
  DailyData? daily;

  @override
  _CurrentCardWidgetState createState() => _CurrentCardWidgetState();

  CurrentCardWidget({Key? key, this.curr, this.daily}) : super(key: key);
}

class _CurrentCardWidgetState extends State<CurrentCardWidget> {
  ApisService? get service => GetIt.I<ApisService>();
  var format = new DateFormat('dd MMMM');

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 6, vertical: 1),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).hintColor.withOpacity(0.15),
                  offset: Offset(0, 3),
                  blurRadius: 10)
            ],
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Column(
                children: [
                  FractionallySizedBox(
                    widthFactor: 0.5,
                    child: widget.curr != null
                        ? Image.network(
                            "http://openweathermap.org/img/wn/${widget.curr?.weather![0].icon.toString()}@4x.png",
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            "http://openweathermap.org/img/wn/${widget.daily?.weather![0].icon.toString()}@4x.png",
                            fit: BoxFit.cover,
                          ),
                  ),
                  widget.curr != null
                      ? Text(
                          '  ${widget.curr?.temp?.toStringAsFixed(0)}\u00B0',
                          style: TextStyle(fontSize: 60),
                        )
                      : Text(
                          '  ${widget.daily?.temp?.max!.toStringAsFixed(0)}\u00B0',
                          style: TextStyle(fontSize: 60),
                        ),
                  widget.curr != null
                      ? Text('${widget.curr?.weather![0].main.toString()}',
                          style: TextStyle(fontSize: 20))
                      : Text('${widget.daily?.weather![0].main.toString()}',
                          style: TextStyle(fontSize: 20)),
                  widget.curr != null
                      ? Text(
                          'Today, ${format.format(DateTime.fromMillisecondsSinceEpoch(widget.curr!.dt! * 1000))}')
                      : Text(
                          'Tomorrow, ${format.format(DateTime.fromMillisecondsSinceEpoch(widget.daily!.dt! * 1000))}'),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            FractionallySizedBox(
                                widthFactor: 0.2,
                                child: Image.asset('img/wind.png',
                                    fit: BoxFit.contain)),
                            widget.curr != null
                                ? Text(
                                    '   ${widget.curr?.windSpeed.toString()}%\n   Wind',
                                    style: TextStyle(fontSize: 10))
                                : Text(
                                    '   ${widget.daily?.windSpeed.toString()}%\n   Wind',
                                    style: TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            FractionallySizedBox(
                                widthFactor: 0.2,
                                child: Image.asset('img/droplet.png',
                                    fit: BoxFit.contain)),
                            widget.curr != null
                                ? Text(
                                    '     ${widget.curr?.humidity.toString()}%\nHumidity',
                                    style: TextStyle(fontSize: 10))
                                : Text(
                                    '     ${widget.daily?.humidity.toString()}%\nHumidity',
                                    style: TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            FractionallySizedBox(
                                widthFactor: 0.2,
                                child: Image.asset('img/rain.png',
                                    fit: BoxFit.contain)),
                            widget.curr != null
                                ? Text(
                                    '       ${(widget.curr?.dewPoint!)}%\nChance of rain',
                                    style: TextStyle(fontSize: 10),
                                  )
                                : Text(
                                    '       ${(widget.daily?.dewPoint!)}%\nChance of rain',
                                    style: TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              )),
            ],
          ),
        ),
      ],
    );
  }
}
