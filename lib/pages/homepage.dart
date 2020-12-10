import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:greenleaf/pages/values_page.dart';
import 'package:greenleaf/widgets/device.dart';
import 'package:greenleaf/widgets/overview.dart';
import 'package:greenleaf/widgets/room.dart';
import 'package:greenleaf/widgets/seperate_builder.dart';

class Homepage extends StatefulWidget {
  Homepage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<Homepage> {
  DatabaseReference database;

  @override
  void initState() {
    super.initState();

    database = FirebaseDatabase.instance.reference();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
              icon: Icon(Icons.tune),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ValuesPage(database: database),
                  ),
                );
              },
            )
          ],
        ),
        body: StreamBuilder(
          stream: database.onValue,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            List<Device> devices = snapshot.data.snapshot.value["devices"]
                .map<Device>((d) => Device.load(d))
                .toList();

            List<Room> rooms = snapshot.data.snapshot.value["rooms"]
                .map<Room>(
                  (r) => Room(
                    name: r["name"],
                    devices: r["devices"]
                        .map<Device>(
                          (d) => devices.firstWhere(
                            (element) => element.name == d,
                            orElse: () => Device.none(),
                          ),
                        )
                        .toList(),
                  ),
                )
                .toList();

            return ListView(
              children: [
                Overview(rooms: rooms),
                const Divider(thickness: 1.5, indent: 20, endIndent: 20),
                SeperateBuilder(
                  itemCount: rooms.length,
                  itemBuilder: (context, index) {
                    return rooms[index];
                  },
                  separatorBuilder: (_, __) =>
                      const Divider(thickness: 1.5, indent: 20, endIndent: 20),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
