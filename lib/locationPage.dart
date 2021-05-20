import 'package:airplane_tracker/airplanes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'networking.dart';
import 'package:get/get.dart';
import 'package:flutter_config/flutter_config.dart';
import 'popupMenuItems.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  double lamin = 8.0666667;
  double lomin = 68.11666666666666;
  double lamax = 37.1;
  double lomax = 97.41666666666667;

  var fixedUrl = "https://opensky-network.org/api/states/all?";

  List<Marker> markers = [];
  List<PopupMenuItem> popupMenuItems = [];

  @override
  // ignore: missing_return
  Future<void> initState() {
    super.initState();
    int i = 0;
    popupMenuItems.add(
      PopupMenuItem(
        value: 0,
        child: Column(
          children: [
            Text(
              "Select Area",
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
        ),
      ),
    );
    for (String key in map.keys) {
      popupMenuItems.add(
        new PopupMenuItem(
          value: i++,
          child: TextButton(
            onPressed: () {
              setState(() {
                lamin = map[key][1];
                lomin = map[key][0];
                lamax = map[key][3];
                lomax = map[key][2];
              });
              updateUI();
              Navigator.pop(context);
            },
            child: Text(
              key,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
    popupMenuItems.add(
      PopupMenuItem(
        value: i,
        child: TextButton(
          onPressed: () {
            Get.to(Airplane(
                lamin: lamin, lomin: lomin, lamax: lamax, lomax: lomax));
          },
          child: Column(
            children: [
              SizedBox(
                height: 3.0,
                width: 400,
                child: Divider(
                  indent: 40.0,
                  color: Colors.black54,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  "Available Airplanes for selected Area",
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    updateUI();
  }

  Future<void> updateUI() async {
    NetworkHelper networkHelper = NetworkHelper();
    var data = await networkHelper.getData(
        "${fixedUrl}lamin=$lamin&lomin=$lomin&lamax=$lamax&lomax=$lomax");
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
              return popupMenuItems;
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
