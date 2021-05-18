import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'airplaneTile.dart';
import 'networking.dart';

final fixedUrl =
    "https://opensky-network.org/api/states/all?lamin=8.0666667&lomin=68.11666666666666&lamax=37.1&lomax=97.41666666666667";

class AirplaneDataController extends GetxController {
  var airplaneTiles = List<Widget>().obs;
  var location = "Location".obs;
  var showSpinner = true.obs;
  var id = "".obs;
  var lat = 0.0.obs;
  var lon = 0.0.obs;
  var velocity = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    updateUI();
  }

  Future<void> updateUI() async {
    NetworkHelper networkHelper = NetworkHelper();
    var data = await networkHelper.getData(fixedUrl);
    for (var i = 0; i < data['states'].length; i++) {
      id.value = data['states'][i][0];
      location.value = data['states'][i][2];
      lon.value = data['states'][i][5];
      lat.value = data['states'][i][6];
      velocity.value = data['states'][i][9].toDouble();

      airplaneTiles.add(
        new AirplaneTile(
          location: location.value,
          lon: lon.value,
          lat: lat.value,
          id: id.value,
          velocity: velocity.value,
        ),
      );
      showSpinner.value = false;
    }
  }
}
