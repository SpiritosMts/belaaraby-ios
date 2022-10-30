import 'package:belaaraby/Home/admin/adminHome/adminHomeCtr.dart';
import 'package:belaaraby/Home/homeCtr.dart';
import 'package:belaaraby/models/storeModel.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AdminStoresListCtr extends GetxController {

  late List<Store> storesAccepted;
  late List<Store> storesRequests;

  late List<Store> foundStoresAccepted;
  late List<Store> foundStoresRequests;

  late TabController tabController;

  final List<String> titleList = [
    "Approved Stores".tr,
    "Stores Requests".tr,
  ];

  String currentTitle = 'Approved Stores'.tr;



  @override
  void onInit() {
    super.onInit();
    print('## init AdminStoresListCtr');
    ///accepted
    storesAccepted = mapToListStore(Get
        .find<AdminHomeCtr>()
        .storeMap).where((st) => st.accepted=='yes').toList();
    foundStoresAccepted = storesAccepted;

    ///requests
    storesRequests = mapToListStore(Get
        .find<AdminHomeCtr>()
        .storeMap).where((st) => st.accepted=='notYet').toList();
    foundStoresRequests = storesRequests;

  }

  void runFilterAccepted(String enteredKeyword) {
    List<Store>? results = [];

    if (enteredKeyword.isEmpty) {
      results = storesAccepted;
    } else {
      results = storesAccepted.where((st) => st.name!.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
    }

    foundStoresAccepted = results;
    update();
  }
  void runFilterRequests(String enteredKeyword) {
    List<Store>? results = [];

    if (enteredKeyword.isEmpty) {
      results = storesRequests;
    } else {
      results = storesRequests.where((st) => st.name!.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
    }

    foundStoresRequests = results;
    update();
  }

  void changeTitle() {
    currentTitle = titleList[tabController.index];
    update();
  }
}
