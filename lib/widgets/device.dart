import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class Device {
  final String name;
  final String icon;
  final List<TimePoint> production;

  Device({this.icon, this.production, this.name});

  factory Device.none() {
    return Device(name: "null", icon: "null", production: []);
  }

  double get current {
    return production[production.length - 1].value;
  }

  factory Device.load(Map<dynamic, dynamic> data) {    

    return Device(
      name: data["name"],
      icon: data["icon"] ?? "?",
      production: data["production"].where((e) => e != null)
          .map<TimePoint>(
            (p) => TimePoint(
              DateTime.fromMillisecondsSinceEpoch(p["timestamp"] * 1000),
              p["value"].toDouble(),
            )
          )
          .toList(),
    );
  }

  Widget inspect(BuildContext context) {
    production.sort((lhs, rhs) => lhs.time.compareTo(rhs.time));
    
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: charts.TimeSeriesChart(
                [
                  charts.Series<TimePoint, DateTime>(
                    id: 'Production',
                    colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
                    domainFn: (TimePoint sales, _) => sales.time,
                    measureFn: (TimePoint sales, _) => sales.value,
                    data: production
                  ),
                ],
                animate: true,
                dateTimeFactory: const charts.LocalDateTimeFactory(),
                domainAxis: charts.DateTimeAxisSpec(
                  tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                    day: charts.TimeFormatterSpec(
                      format: 'dd',
                      transitionFormat: 'dd MMM',
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }

  Widget card() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: FractionallySizedBox(
            widthFactor: 1 / 4,
            heightFactor: 1 / 4,
            child: Text(icon, textScaleFactor: 3),
          ),
        ),
        Text("$current kW"),
      ],
    );
  }
}

class TimePoint {
  final DateTime time;
  final double value;

  TimePoint(this.time, this.value);
}
