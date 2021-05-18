import 'package:airplane_tracker/airplanes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'networking.dart';
import 'package:get/get.dart';
import 'package:flutter_config/flutter_config.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final fixedUrl =
      "https://opensky-network.org/api/states/all?lamin=8.0666667&lomin=68.11666666666666&lamax=37.1&lomax=97.41666666666667";

  List<Marker> markers = new List();

  @override
  // ignore: missing_return
  Future<void> initState() {
    super.initState();
    updateUI();
  }

  Future<void> updateUI() async {
    NetworkHelper networkHelper = NetworkHelper();
    var data = await networkHelper.getData(fixedUrl);
    setState(() {
      markers.clear();
      for (var i = 0; i < data['states'].length; i++) {
        markers.add(
          Marker(
            width: 80.0,
            height: 80.0,
            point: LatLng(data['states'][i][6], data['states'][i][5]),
            builder: (ctx) => Container(
              child: Icon(
                Icons.airplanemode_active,
                size: 25.0,
                color: Colors.black,
              ),
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text("Airplane Tracker"),
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: PopupMenuButton(itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 1,
                  child: FlatButton(
                    onPressed: () {
                      Get.to(Airplane());
                    },
                    child: Text(
                      "All Available Airplanes",
                    ),
                  ),
                ),
              ];
            }),
          ),
        ],
      ),
      body: new FlutterMap(
        options: new MapOptions(
          center: new LatLng(20.593684, 78.96288),
        ),
        layers: [
          new TileLayerOptions(
              urlTemplate: FlutterConfig.get('MAP_BOX_STYLE'),
              additionalOptions: {
                'accessToken': FlutterConfig.get('MAP_BOX_TOKEN'),
                'id': 'mapbox.mapbox-streets-v7'
              }),
          MarkerLayerOptions(markers: markers),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
          elevation: 0.0,
          child: new Icon(Icons.refresh),
          backgroundColor: Colors.blueAccent,
          onPressed: () async {
            updateUI();
            print("Pressed!");
          }),
    );
  }
}
