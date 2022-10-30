import 'package:belaaraby/main.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyNotifCtr extends GetxController {

  @override
  void onInit() {
    super.onInit();
    print('## init MyNotifCtr');
    getNotifStatus();
  }

  bool isNotifActive = false;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  saveNotifStatus() async {
    SharedPreferences pref = await _prefs;
    pref.setBool('notif', isNotifActive);
  }

  getNotifStatus() async {
    var isActive = _prefs.then((SharedPreferences prefs) {
      return prefs.getBool('notif') ?? true;
    }).obs;
    isNotifActive = await isActive.value;
  }


  onSwitch(val) {
    isNotifActive = val;
    print('## notif active <$isNotifActive>');
    saveNotifStatus();
    update();
  }
}
