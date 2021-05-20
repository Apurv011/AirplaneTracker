import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'airplaneDataController.dart';

class Airplane extends StatelessWidget {
  Airplane({this.lamin, this.lomin, this.lamax, this.lomax});
  double lamin;
  double lomin;
  double lamax;
  double lomax;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text(
          'Airplane Tracker',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: GetX<AirplaneDataController>(
          init: AirplaneDataController(
              lamin: lamin, lomin: lomin, lamax: lamax, lomax: lomax),
          builder: (controller) {
            return ModalProgressHUD(
              inAsyncCall: controller.showSpinner.value,
              child: Container(
                child: ListView(
                  children: [
                    Column(
                      children: controller.airplaneTiles,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
