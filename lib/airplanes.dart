import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'airplaneDataController.dart';

class Airplane extends StatelessWidget {
  final airplaneQuakeDataController = Get.put(AirplaneDataController());

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
          init: AirplaneDataController(),
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
