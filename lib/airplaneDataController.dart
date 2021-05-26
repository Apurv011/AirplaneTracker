import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'airplaneTile.dart';
import 'networking.dart';

final fixedUrl = "https://opensky-network.org/api/states/all?";

class AirplaneDataController extends GetxController {
  AirplaneDataController({this.lamin, this.lomin, this.lamax, this.lomax});
  double lamin;
  double lomin;
  double lamax;
  double lomax;

  var airplaneTiles = List<Widget>().obs;
  var location = "Location".obs;
  var showSpinner = true.obs;
  var id = "".obs;
  var lat = 0.0.obs;
  var lon = 0.0.obs;
  var velocity = 0.0.obs;
  var angle = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    updateUI();
  }

  Future<void> updateUI() async {
    NetworkHelper networkHelper = NetworkHelper();
    var data = await networkHelper.getData(
        "${fixedUrl}lamin=$lamin&lomin=$lomin&lamax=$lamax&lomax=$lomax");
    for (var i = 0; i < data['states'].length; i++) {
      id.value = data['states'][i][0];
      location.value = data['states'][i][2];
      lon.value = data['states'][i][5];
      lat.value = data['states'][i][6];
      velocity.value = data['states'][i][9].toDouble();
      angle.value = data['states'][i][10];

      airplaneTiles.add(
        new AirplaneTile(
            lamin: lamin,
            lomin: lomin,
            lamax: lamax,
            lomax: lomax,
            location: location.value,
            lon: lon.value,
            lat: lat.value,
            id: id.value,
            velocity: velocity.value,
            angle: angle.value),
      );
      showSpinner.value = false;
    }
  }
}
