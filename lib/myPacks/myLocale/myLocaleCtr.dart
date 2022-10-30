import 'package:belaaraby/main.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class MyLocaleCtr extends GetxController {
  //Locale? initlang = sharedPrefs!.getString('lang') == null ? Get.deviceLocale : Locale(sharedPrefs!.getString('lang')!);
  Locale? initlang = sharedPrefs!.getString('lang') == null ? Locale('ar') : Locale(sharedPrefs!.getString('lang')!);



  void changeLang(String codeLang) {
    sharedPrefs!.setString('lang', codeLang);
    Locale locale = Locale(codeLang);
    Get.updateLocale(locale);
    print('## current lang => ${currLang}');
  }
}
