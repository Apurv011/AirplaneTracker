import 'package:airplane_tracker/locationOfSinglePlane.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AirplaneTile extends StatelessWidget {
  AirplaneTile(
      {this.lamin,
      this.lomin,
      this.lamax,
      this.lomax,
      this.location,
      this.lon,
      this.lat,
      this.id,
      this.velocity,
      this.angle});

  final double lamin;
  final double lomin;
  final double lamax;
  final double lomax;
  final String location;
  final double lon;
  final double lat;
  final double angle;
  final id;
  final velocity;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Get.to(LocationOfSinglePlane(),
                arguments: [lamin, lomin, lamax, lomax, lat, lon, id, angle]);
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
