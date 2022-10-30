import 'dart:math';

import 'package:belaaraby/Home/admin/adminStoresList/adminStoresListView.dart';
import 'package:belaaraby/Home/homeMyStView.dart';
import 'package:belaaraby/Home/selectedStore/selectedStView.dart';
import 'package:belaaraby/myPacks/mapVoids.dart';
import 'package:belaaraby/models/brUserModel.dart';
import 'package:belaaraby/models/storeModel.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:belaaraby/myPacks/notifications/notificationCtr.dart';
import 'package:belaaraby/myPacks/storeVoids.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:belaaraby/myPacks/firebase/fireBase.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myVoids.dart';


class HomeCtr extends GetxController {
   final MyNotifCtr notifCtr = Get.find<MyNotifCtr>();

   bool kmVisibility =false;

   bool notifValue =false;
  Store selectedSt = Store();
  double minSliderVal = 1.0;
  double maxSliderVal = 100.0;
  List<String> allNearbyItemsList = [];
  Map<String, Store> storeMap = {};
  Map<String, Store> nearbyStoreMap = {};

  //Map<String, Store> filtredStoreMap = {};
  Map<String, MarkerData> grMarkers = {};
  Map<String, MarkerData> grNearbyMarkers = {};
  Map<String, MarkerData> stFiltredMarkers = {};
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController typeAheadController = TextEditingController();
  String selectedProduct = '';
  bool typing = false;
   Set<Circle> circles = {};

  double sliderVal = 60.0;

  late LatLng userPos = const LatLng(0.0, 0.0);
  Completer<GoogleMapController> gMapCtr = Completer();

  onMapCreated(controller) {
    //gMapCtr = Completer();
    if (!gMapCtr.isCompleted) {
      //updateMap();
      gMapCtr.complete(controller);
      setDarkMap(gMapCtr);

      updateMap();
    } else {
      //other calling, later is true,
      //don't call again completer()
    }
  }




  hideKmText(){
    Future.delayed(Duration(seconds: 3)).then((value) {
      kmVisibility=false;
      update(['km']);
    });
  }
  showTimedKm(){
    kmVisibility=true;
    kmVisibility=false;

    update(['km']);
    //hideKmText();
  }
  selectStToModify(store) {
    selectedSt = store;
  }

  BrUser cUser = BrUser();
  bool canLoadStores = true;
  bool loadingMarkers = false;

  @override
  onInit() {
    super.onInit();
    print('## init HomeCtr');
    getUserLocation();
  }

  @override
  void onClose() {
    super.onClose();
    print('## close HomeCtr');
  }

  getUserLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    userPos = await getCurrentLocation(gMapCtr);
    //user props
    cUser = authCtr.cUser;
  }

  changeSlider(val) {
    sliderVal = val;
    update(['slider']);
  }

  minusSlider() async{
    if(sliderVal>minSliderVal){
      sliderVal --;
      grNearbyMarkers = await loadNearbyMarkers(grMarkers,selectedProduct, sliderVal, printDet: true);

    }
    update(['slider']);
  }
  plusSlider() async{
    if(sliderVal<maxSliderVal){
      sliderVal ++;
      grNearbyMarkers = await loadNearbyMarkers(grMarkers,selectedProduct, sliderVal, printDet: true);

    }
    update(['slider']);
  }



  updateMap() {
    update(['map']);
  }

  updateAppBar() {
    update(['appBar']);
  }
  updateNotif() {
    update(['notif']);
  }

  appBarTyping(typ) {
    typing = typ;
    updateAppBar();
  }

  testPressed() {
    print('## ${grMarkers.length} MARKERS\n${storeMap.length} StoresMap\n${storeMap.length} StoresList');
    print('## curr_pos >${userPos.latitude} / ${userPos.longitude} <');
    print('## selected st >${selectedSt.name} <');
    print(
        '## cUSer >> email: ${cUser.email}\nname: ${cUser.name}\npwd: ${cUser.pwd}\nuser_id: ${cUser.id}\nstores_IDs:(${cUser.stores!.length}) ${cUser.stores}\nhas stores: ${cUser.hasStores}\nisAdmin: ${cUser.isAdmin}\njoinDate: ${cUser.joinDate}');
  }

  ///open store map
  openMyStoreList() {
    Get.to(() => MyStoresView())!.then((result) {
      print('## pos to go to => ${result['tappedStPosition']}');
      LatLng tappedStPosition = result['tappedStPosition'];
      moveCamPosTo(gMapCtr, animateZoom, tappedStPosition.latitude, tappedStPosition.longitude);
    }).ignore();
  }

  switchNotif(val){
    notifValue =val;
    print('## notif => $val');
    updateNotif();
  }
  onSuggestionSelected(suggestion) async {
    typeAheadController.text = suggestion.toString();
    selectedProduct = suggestion.toString();
    print('## selected $selectedProduct');
    grNearbyMarkers = await loadNearbyMarkers(grMarkers, selectedProduct, sliderVal, printDet: true);
    updateAppBar();
  }
  clearSelectedProduct() async {
    typeAheadController.clear();
    selectedProduct = '';
    grNearbyMarkers = await loadNearbyMarkers(grMarkers, selectedProduct, sliderVal, printDet: true);
    appBarTyping(false);
    updateAppBar();
  }

  // get data from firebase
  getStoresData(context, {bool printDet = false}) async {
    if (printDet) print('## downloading stores from fireBase...');
    List<DocumentSnapshot> storesData =  await getDocumentsByCollCondition(storesColl);

    // Remove any existing stores
    storeMap.clear();
    //fill store map
    storeMap = getStoreModelData(storesData);

    if (printDet) print('## < ${storeMap.length} > stores loaded from database');
    await loadMarkers(storeMap);

    grNearbyMarkers = await loadNearbyMarkers(grMarkers, selectedProduct, sliderVal, printDet: true);

    Future.delayed(const Duration(milliseconds: 20), () {
      updateMap();
    });
  }


  /// loadMarkers
  loadMarkers(Map<String, Store> stores) {

    // Remove any existing markers
    grMarkers.clear();

    stores.forEach((_, st) {
      grMarkers[st.id!] = MarkerData(
          marker: Marker(
            markerId: MarkerId(st.id!),
            position: LatLng(st.latitude!, st.longitude!),
            onTap: () {
              selectedSt = storeMap[st.id!]!;
              Get.to(()=>SelectedStView(), arguments: {'isAdmin':false} );
            },
          ),
          child: customMarkerImg(st.logo!, st.accepted!, st.jobType!,st.name!));
    });

    updateMap();
  }


   setCircle(double radius) {

     circles  = {Circle(
       circleId: CircleId('CircleId'),
       center: LatLng(userPos.latitude, userPos.longitude),
       radius: radius,
       strokeWidth: 0,
       fillColor: yellowColHex.withOpacity(.07)
     )};

     print('## ${circles.length}');

     updateMap();


   }
  /// loadNearbyMarkers
  Future<Map<String, MarkerData>> loadNearbyMarkers(Map<String, MarkerData> markers, enteredKeyword, double maxDist, {bool printDet = false}) async {
    if (printDet) print('## checking MARKERS <= $maxDist km');
    Map<String, MarkerData> nearbyMarkers = {};
    nearbyStoreMap.clear();
    allNearbyItemsList = [];

    //use location gps found (get latest user pos when he press gps_btn)
    //if (userPos.latitude * userPos.longitude != 0.0) {
    var location = Location();
    bool locEnabled = await location.serviceEnabled();
    if (locEnabled) {
      setCircle(maxDist*1000.8);
      double distanceToGr = maxDist + 1;

      markers.forEach((grID, mrk) {
        if (printDet) print('## checking (${storeMap[grID]!.name!})');

        //store has that marker
        Store st = storeMap[grID]!;
        LatLng posSt = LatLng(st.latitude!, st.longitude!);

        // dist between user and st
        distanceToGr = MyVoids().calculateDistance(userPos.latitude, userPos.longitude, posSt.latitude, posSt.longitude);

        /// st in range
        if (distanceToGr <= maxDist) {
          if (printDet) print(' store <${st.name}> IN RANGE ($distanceToGr)km');
          nearbyMarkers[grID] = mrk;
          nearbyStoreMap[grID] = st;
          //load all nearby items
          for (Map<String, dynamic> categ in st.categories!.values) {
            for (var item in categ.keys) {
              allNearbyItemsList.add(item.toString());
            }
          }
        }
        // st not in range
        else {
          if (printDet) print('store <${st.name}> NOT IN RANGE ($distanceToGr)km');
        }
      });
      //delete duplicated items
      allNearbyItemsList.toSet().toList();

      if (printDet) print('## found < ${nearbyMarkers.length} / ${markers.length} > MARKERS IN RANGE ($maxDist) km');
      if (printDet) print('## found < ${allNearbyItemsList.length} > ITEMS IN RANGE ($maxDist) km');

      //use location gps not found
    } else {
      MyVoids().showTos('please activate your GPS to get the locations of the nearest stores'.tr);
    }

    updateMap();
    // return nearbyMarkers;
    return await loadFiltredMarkers(nearbyMarkers, enteredKeyword, printDet: true);
  }

  /// loadFiltredMarkers
  Future<Map<String, MarkerData>> loadFiltredMarkers(Map<String, MarkerData> nearbyStoreMarkers, enteredKeyword, {bool printDet = false}) async {
    Map<String, MarkerData> filtredStoreMap = {};
    stFiltredMarkers = {};

    if (enteredKeyword.isEmpty) {
      filtredStoreMap = nearbyStoreMarkers;
    } else {
      ///search by items
      for (var stID in nearbyStoreMarkers.keys) {
        Store st = storeMap[stID]!;
        bool contain = false;
        for (var itemName in st.allItemsList) {
          if (itemName.toLowerCase().contains(enteredKeyword.toLowerCase())) {
            contain = true;
          }
        }
        //store has that item
        if (contain) {
          filtredStoreMap[stID] = nearbyStoreMarkers[stID]!;
          stFiltredMarkers[stID] = nearbyStoreMarkers[stID]!;
          if (printDet) print('## store <${st.name}> has <$enteredKeyword>');
        }
        //store hasn't that item
        else {
          if (printDet) print('## store <${st.name}> do not have <$enteredKeyword>');
        }
      }

      ///search by name
      // results = allStores.where((st) =>
      //     st.name!.toLowerCase().contains(enteredKeyword.toLowerCase())
      // ).toList();
    }

    updateMap();
    return filtredStoreMap;
  }




}
