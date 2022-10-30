
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'dart:async';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:flutter/services.dart' show rootBundle;


void moveCamPosTo(gMapctr,double zoom,double lat, double lng) async {
  final CameraPosition newCameraPosition = CameraPosition(
    target: LatLng(lat, lng),
    zoom: zoom,
  );
  final  ctr = await gMapctr.future;

  ctr.animateCamera(CameraUpdate.newCameraPosition(newCameraPosition));
}
void setDarkMap( gMapctr) async {

  String  darkMapStyle  = await rootBundle.loadString('assets/map_styles/dark.json');

  final ctr = await gMapctr.future;

  ctr.setMapStyle(darkMapStyle);
}

Future<LatLng> getCurrentLocation(gMapCtr,{LatLng posOnLocErr =const LatLng(0.0, 0.0)}) async {
  //default position
  LatLng currUserPos =posOnLocErr;
  /// without initial LatLng
 await Geolocator.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.best).then((pos)  {
    // affect curr user pos
     currUserPos =LatLng(pos.latitude, pos.longitude);
    print('### curr_pos >${currUserPos.latitude}/${currUserPos.longitude} <');
     //animate cam
    moveCamPosTo(gMapCtr,animateZoom,currUserPos.latitude, currUserPos.longitude);
  }).catchError((err) {
    print("## Failed to get user current location : $err");
    MyVoids().showTos('can\'t found you location'.tr);
  });
  return currUserPos;
}
storeLogo(String logoUrl,double size){
  return Image.network(
    logoUrl,

    fit: BoxFit.scaleDown,
    color: yellowColHex,
    height: size,
    width: size,
  );
}

 jobTypeIcon(String jobType,double size) {
  String imagePath = '';
  switch (jobType) {
    case "متجر بقالة":
      imagePath = 'assets/jobType/grocery.png';
      break;
    case "مطعم":
      imagePath = 'assets/jobType/restaurant.png';
      break;
    case "حلويات":
      imagePath = 'assets/jobType/candy.png';
      break;
    case "تجارة جملة":
      imagePath = 'assets/jobType/jomla.png';
      break;
    case "سياحة وسفر":
      imagePath = 'assets/jobType/plane.png';
      break;
    case "صيدلية":
      imagePath = 'assets/jobType/pharmacy.png';
      break;
    case "طبیب":
      imagePath = 'assets/jobType/doctor.png';
      break;
    case "محامي":
      imagePath = 'assets/jobType/Attorney.png';
      break;
    case "محاسب":
      imagePath = 'assets/jobType/accountant.png';
      break;
    case "ترجمان":
      imagePath = 'assets/jobType/translator.png';
      break;
    case "نجار":
      imagePath = 'assets/jobType/carpenter.png';
      break;
    case "حداد":
      imagePath = 'assets/jobType/smith.png';
      break;
    case "لحام":
      imagePath = 'assets/jobType/solderer.png';
      break;
    case "مزارع":
      imagePath = 'assets/jobType/farmer.png';
      break;
    case "صاحب بنك":
      imagePath = 'assets/jobType/bank.png';
      break;
    case "بيطري":
      imagePath = 'assets/jobType/veterinary.png';
      break;
    case "صاحب تاكسي":
      imagePath = 'assets/jobType/taxi.png';
      break;
    case "صيانة":
      imagePath = 'assets/jobType/maintenance.png';
      break;
    case "بائع لحوم":
      imagePath = 'assets/jobType/meat.png';
      break;
    case "زراعة":
      imagePath = 'assets/jobType/plant.png';
      break;
    case "أساس منزلي":
      imagePath = 'assets/jobType/home.png';
      break;
    case "مكتب توظيف":
      imagePath = 'assets/jobType/office.png';
      break;
    case "تعليم":
      imagePath = 'assets/jobType/education.png';
      break;
    case "الكترونيات":
      imagePath = 'assets/jobType/electronics.png';
      break;
    case "معرض سيارة":
      imagePath = 'assets/jobType/car.png';
      break;
    case "طباعة وتصميم":
      imagePath = 'assets/jobType/design.png';
      break;
    case "حرفة يدوية":
      imagePath = 'assets/jobType/Handicraft.png';
      break;
    case "مواد بناء":
      imagePath = 'assets/jobType/Building.png';
      break;
    default:
      imagePath = 'assets/jobType/grocery.png';
  }

  return Image.asset(
    imagePath,

    //fit: BoxFit.scaleDown,
    color: yellowColHex,
     height: size,
     width: size,
  );
}