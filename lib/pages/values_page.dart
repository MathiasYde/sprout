import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:greenleaf/widgets/device.dart';

class ValuesPage extends StatefulWidget {
  ValuesPage({this.database});

  final DatabaseReference database;

  ValuesPageState createState() => ValuesPageState();
}

class ValuesPageState extends State<ValuesPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Values page"),
        ),
        body: StreamBuilder(
          stream: widget.database.child("devices").onValue,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            List<Device> devices = snapshot.data.snapshot.value
                .map<Device>((d) => Device.load(d))
                .toList();

            return ListView(
              children: [
                for (int i = 0; i < devices.length; ++i)
                  ListTile(
                    leading: devices[i].icon,
                    title: Text(devices[i].name),
                    trailing: FractionallySizedBox(
                      widthFactor: 0.25,
                      child: TextField(
                        decoration: InputDecoration(
                            // devices[i].production[devices[i].production.length - 1].y
                            hintText: devices[i].current.toString()),
                        onSubmitted: (String input) {
                          try {
                            double value = double.parse(input);

                            widget.database
                                .child("devices")
                                .child("$i")
                                .child("production")
                                .child("${devices[i].production.length}")
                                .set({
                              "timestamp": DateTime.now().millisecond,
                              "value": value
                            });
                          } catch (e) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Failed to set value"),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: [
                                        Text(
                                            "Maybe you put in letters or symbols in a number field?"),
                                        Text(e.toString()),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  )
              ],
            );
          },
        ),
      ),
    );
  }
}
