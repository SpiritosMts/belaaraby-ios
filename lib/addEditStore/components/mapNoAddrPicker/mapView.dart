import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'mapCtr.dart';

class PickMapView extends StatelessWidget {
  final MapPickerCtr getCtrl = Get.find<MapPickerCtr>();


  @override
  Widget build(BuildContext context) {
    return    GetBuilder<MapPickerCtr>(
        builder: (ctr) => Row(children: [

          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child:  Text(
              'choose location'.tr,
              style:const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          /// marker button
          Center(
            child: Ink(
              decoration: const ShapeDecoration(
                color: yellowColHex,
                shape: CircleBorder(),
              ),
              child: IconButton(
                icon: const Icon(Icons.place_rounded),
                color: Colors.white,
                onPressed: () {
                  fieldUnfocusAll();
                  getCtrl.pushMarkerScreen(context);
                },
              ),
            ),
          ),
          //Text('Lat: ${getCtrl.lati}\nLng: ${getCtrl.lngi}\n'),


        ]),
    );
  }
}
