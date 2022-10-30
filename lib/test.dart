
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:belaaraby/myPacks/firebase/fireBase.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


////////////////////// TEST //////////////////////////////

 addToItems() async {

  List<DocumentSnapshot> storesData = await getDocumentsByColl(storesColl);

for( var store in storesData){
  String id = store.get('id');

  Map<String, dynamic> categories = store.get("categories");

  // Map<String, dynamic> promos = store.get("promo");
  //
  // for(var item in promos.values){
  //   item['currency']='euro';
  // }
  for(var categ in categories.values){
    for(var item in categ.values){
      item['currency']='euro';
    }  }
  await storesColl.doc(id).update({
    'categories': categories,
  });

}
}

Future<void> test() async {

   print('updating fb ...');

   List<DocumentSnapshot> storesData = await getDocumentsByColl(storesColl);
  print('## stores_num: ${storesData.length}');

for( var store in storesData){
  String id = store.get('id');

  //print('#upd=> $id');

   storesColl.doc(id).update({
    'website': '',
  });

}
}

TestDialogShow(context){
  AwesomeDialog(
    dialogBackgroundColor: blueColHex2,

    autoDismiss: true,
    context: context,
    dismissOnBackKeyPress: false,
    headerAnimationLoop: false,
    dismissOnTouchOutside: false,
    animType: AnimType.LEFTSLIDE,
    dialogType: DialogType.SUCCES,
    //showCloseIcon: true,
    // title: 'Success'.tr,

    descTextStyle: GoogleFonts.almarai(
      height: 1.8,
      textStyle: const TextStyle(fontSize: 14),
    ),
    desc: 'your store will be verified\nas soon as possible'.tr,
    btnOkText: 'Ok'.tr,

    btnOkOnPress: () {
    },
    // onDissmissCallback: (type) {
    //   debugPrint('## Dialog Dissmiss from callback $type');
    // },
    //btnOkIcon: Icons.check_circle,
  ).show();
}

