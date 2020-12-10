import 'package:flutter/material.dart';
import 'device.dart';

class Room extends StatelessWidget {
  final String name;
  final List<Device> devices;

  Room({this.name, this.devices});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(name),
        Text("${devices.length} devices"),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(), // disable scroll within gridview
          shrinkWrap: true,
          itemCount: devices.length,
          gridDelegate:
              new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => devices[index].inspect(context)));
              },
              child: Center(
                child: devices[index].card(),
              ),
            );
          },
        ),
      ],
    );
  }
}
