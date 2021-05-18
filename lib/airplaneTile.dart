import 'package:airplane_tracker/locationOfSinglePlane.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AirplaneTile extends StatelessWidget {
  AirplaneTile({this.location, this.lon, this.lat, this.id, this.velocity});

  final String location;
  final double lon;
  final double lat;
  final id;
  final velocity;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Get.to(LocationOfSinglePlane(), arguments: [lat, lon, id]);
          },
          title: Padding(
            padding: EdgeInsets.only(top: 9.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "ICAO 24-bit address: $id",
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
                Text("Origin Country: $location")
              ],
            ),
          ),
          trailing: Padding(
            padding: const EdgeInsets.only(top: 9.0),
            child: Column(
              children: [
                Text("Velocity"),
                Text("$velocity m/s"),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 3.0,
          width: 400,
          child: Divider(
            indent: 40.0,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
