import 'package:airplane_tracker/airplanes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'locationOfSinglePlane.dart';
import 'networking.dart';
import 'package:get/get.dart';
import 'package:flutter_config/flutter_config.dart';
import 'data.dart';
import 'package:flag/flag.dart';
import 'dart:math' as math;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  double lamin = 8.0666667;
  double lomin = 68.11666666666666;
  double lamax = 37.1;
  double lomax = 97.41666666666667;
  bool showSpinner = true;

  var fixedUrl = FlutterConfig.get('SERVER_URL');

  List<Marker> markers = [];
  List<Widget> drawerItems = [];

  @override
  // ignore: missing_return
  Future<void> initState() {
    super.initState();
    updateUI();
    drawerItems.add(
      Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 60,
              backgroundImage: AssetImage("images/bg.png"),
            ),
            SizedBox(height: 20.0),
            Text(
              'Select Area',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
    drawerItems.add(
      Divider(
        height: 1,
        thickness: 1,
      ),
    );
    for (String key in map.keys) {
      drawerItems.add(
        ListTile(
          tileColor: Colors.white24,
          leading: Flag(
            map[key][0],
            height: 30,
            width: 50,
            fit: BoxFit.fill,
          ),
          title: Text(key),
          onTap: () {
            setState(() {
              lamin = map[key][2];
              lomin = map[key][1];
              lamax = map[key][4];
              lomax = map[key][3];
            });
            updateUI();
            Navigator.pop(context);
          },
        ),
      );
    }
  }

  Future<void> updateUI() async {
    showSpinner = true;
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
              child: Transform.rotate(
                angle: data['states'][i][10] * math.pi / 180,
                child: TextButton.icon(
                  onPressed: () {
                    return Alert(
                        context: context,
                        title: "",
                        content: Column(
                          children: [
                            Text(
                              "Origin Country: ${data['states'][i][2]}",
                            ),
                            Text(
                              "Velocity: ${data['states'][i][9]}",
                            ),
                          ],
                        ),
                        buttons: [
                          DialogButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Get.to(LocationOfSinglePlane(), arguments: [
                                lamin,
                                lomin,
                                lamax,
                                lomax,
                                data['states'][i][6],
                                data['states'][i][5],
                                data['states'][i][0],
                                data['states'][i][10]
                              ]);
                            },
                            child: Text(
                              "Track this Airplane",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            color: Colors.blue,
                          ),
                        ]).show();
                  },
                  icon: Icon(
                    Icons.airplanemode_active,
                    size: 25.0,
                    color: Colors.black,
                  ),
                  label: Text(
                    "",
                  ),
                ),
              ),
            ),
          ),
        );
      }
      showSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text("Airplane Tracker"),
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: PopupMenuButton(
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: 0,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Get.to(Airplane(
                            lamin: lamin,
                            lomin: lomin,
                            lamax: lamax,
                            lomax: lomax));
                      },
                      child: Text(
                        "Available Airplanes for selected Area",
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ];
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: drawerItems,
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: FlutterMap(
          options: new MapOptions(
            zoom: 2.0,
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
      ),
      floatingActionButton: new FloatingActionButton(
          elevation: 0.0,
          child: new Icon(Icons.refresh),
          backgroundColor: Colors.blue,
          onPressed: () async {
            updateUI();
            print("Pressed!");
          }),
    );
  }
}
