import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'networking.dart';
import 'package:get/get.dart';
import 'package:flutter_config/flutter_config.dart';
import 'dart:math' as math;

class LocationOfSinglePlane extends StatefulWidget {
  @override
  _LocationOfSinglePlaneState createState() => _LocationOfSinglePlaneState();
}

class _LocationOfSinglePlaneState extends State<LocationOfSinglePlane> {
  final fixedUrl =
      "${FlutterConfig.get('SERVER_URL')}lamin=${Get.arguments[0]}&lomin=${Get.arguments[1]}&lamax=${Get.arguments[2]}&lomax=${Get.arguments[3]}";

  var lat = Get.arguments[4];
  var lon = Get.arguments[5];
  var id = Get.arguments[6];
  var angle = Get.arguments[7];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text("Airplane Tracker"),
      ),
      body: new FlutterMap(
        options: new MapOptions(
          center: new LatLng(lat, lon),
        ),
        layers: [
          new TileLayerOptions(
              urlTemplate: FlutterConfig.get('MAP_BOX_STYLE'),
              additionalOptions: {
                'accessToken': FlutterConfig.get('MAP_BOX_TOKEN'),
                'id': 'mapbox.mapbox-streets-v7'
              }),
          MarkerLayerOptions(markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(lat, lon),
              builder: (ctx) => Container(
                child: Transform.rotate(
                  angle: angle * math.pi / 180,
                  child: Icon(
                    Icons.airplanemode_active,
                    size: 25.0,
                    color: Colors.black,
                  ),
                ),
              ),
            )
          ]),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
          elevation: 0.0,
          child: new Icon(Icons.refresh),
          backgroundColor: Colors.blueAccent,
          onPressed: () async {
            NetworkHelper networkHelper = NetworkHelper();
            var data = await networkHelper.getData(fixedUrl);

            for (var i = 0; i < data['states'].length; i++) {
              if (id == data['states'][i][0]) {
                setState(() {
                  lon = data['states'][i][5];
                  lat = data['states'][i][6];
                  angle = data['states'][i][10];
                });
              }
            }
            print("Pressed!");
          }),
    );
  }
}
