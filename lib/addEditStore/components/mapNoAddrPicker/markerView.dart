import 'dart:async';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; //import from pub.dev
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; //import from pub.dev
import 'package:geocoding/geocoding.dart' as geocod;

import 'mapCtr.dart';
import '../../../myPacks/mapVoids.dart';

class GoogleMapMarker extends StatelessWidget {
  final MapPickerCtr getCtrlOnNext = Get.find<MapPickerCtr>();

  //final Completer<GoogleMapController> gMapctr = Completer();


  @override
  Widget build(BuildContext context) {
    return GetBuilder<MapPickerCtr>(

         //init: MapPickerCtr(),
        initState: (_) {
          getCtrlOnNext.getSavedLocation();
        },
        builder: (ctr) => Scaffold(
              body: Container(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    ///map
                    GoogleMap(
                      zoomControlsEnabled: false,
                      onTap: (p) {
                        ctr.setMarker(p.latitude, p.longitude);
                        moveCamPosTo(getCtrlOnNext.gMapctr,animateZoom,p.latitude, p.longitude);
                      },
                      onMapCreated: (GoogleMapController controller) {
                        getCtrlOnNext.gMapctr.complete(controller);
                        setDarkMap(getCtrlOnNext.gMapctr);

                      },
                      initialCameraPosition: (ctr.lati * ctr.lngi != 0.0) ?
                           CameraPosition(target: LatLng(ctr.lati, ctr.lngi), zoom: 16.0)
                          : belgiumPos,
                      markers: ctr.markers.values.toSet(),
                    ),

                    ///save
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          ctr.save();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text('Save'.tr),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
