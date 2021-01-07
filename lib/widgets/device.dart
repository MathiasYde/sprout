import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class Device {
  final String name;
  final Widget icon;
  final List<TimePoint> production;

  Device({this.icon, this.production, this.name});

  factory Device.none() {
    return Device(name: "null", icon: null, production: []);
  }

  double get current {
    return production[production.length - 1].value;
  }

  factory Device.load(Map<dynamic, dynamic> data) {
    Widget icon;
    List<String> parts = (data["icon"] as String).split(";");
    String domain = parts[0];
    String source = parts[1];

    if (domain == "network") {
      icon = Image.network(source);
    }
    if (domain == "image") {
      icon = Image.asset("lib/assets/$source.png");
    }
    if (domain == "text") {
      icon = Text(source, textScaleFactor: 3);
    }

    return Device(
      name: data["name"],
      icon: icon,
      production: data["production"]
          .where((e) => e != null)
          .map<TimePoint>((p) => TimePoint(
                DateTime.fromMillisecondsSinceEpoch(p["timestamp"] * 1000),
                p["value"].toDouble(),
              ))
          .toList(),
    );
  }

  Widget inspect(BuildContext context) {
    production.sort((lhs, rhs) => lhs.time.compareTo(rhs.time));

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: Column(
            children: [
              Flexible(
                child: Row(
                  children: [
                    Transform.rotate(
                      angle: 3.14159265 * -0.5,
                      child: Text("MWh"),
                    ),
                    Flexible(
                      child: charts.TimeSeriesChart(
                        [
                          charts.Series<TimePoint, DateTime>(
                              id: 'Production',
                              colorFn: (_, __) =>
                                  charts.MaterialPalette.blue.shadeDefault,
                              domainFn: (TimePoint sales, _) => sales.time,
                              measureFn: (TimePoint sales, _) => sales.value,
                              data: production),
                        ],
                        animate: true,
                        dateTimeFactory: const charts.LocalDateTimeFactory(),
                        domainAxis: new charts.DateTimeAxisSpec(
                          tickFormatterSpec:
                              new charts.AutoDateTimeTickFormatterSpec(
                            day: new charts.TimeFormatterSpec(
                              format: 'yyyy',
                              transitionFormat: 'MM/dd/yyyy',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text("Time (days)"),
            ],
          ),
        ),
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
            child: icon,
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
