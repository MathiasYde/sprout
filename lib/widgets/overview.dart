import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:greenleaf/widgets/animated_value.dart';
import 'package:greenleaf/widgets/room.dart';

import 'device.dart';

class Overview extends StatefulWidget {
  Overview({Key key, this.rooms}) : super(key: key);

  final List<Room> rooms;

  @override
  OverviewState createState() => OverviewState();
}

class OverviewState extends State<Overview> {
  FlareControls logoController;
  bool charging = false;
  ColorTween colorTween;

  Timer timer;

  @override
  void initState() {
    super.initState();
    logoController = new FlareControls();

    timer = Timer.periodic(Duration(milliseconds: 2000),
        (Timer t) => logoController.play("Charge"));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double totalProduction = widget.rooms.fold(0, (value, Room room) => value += room.devices.fold(0, (value, Device device) => value += device.current));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              logoController.play("SmallWiggle");
            },
            child: SizedBox(
              width: 100,
              height: 100,
              // I don't like using TweenAnimationBuilder for this,
              // but I don't know what else I could do to improve it
              child: FlareActor(
                "lib/assets/leaf_logo.flr",
                controller: logoController,
              ),
            ),
          ),
          AnimatedValue(value: totalProduction, builder: (value) => Text("${value.toStringAsFixed(2)} kW", textScaleFactor: 3),),
          Text("current production"),
        ],
      ),
    );
  }
}
