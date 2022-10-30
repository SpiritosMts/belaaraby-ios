import 'dart:io';

import 'package:belaaraby/Home/homeCtr.dart';
import 'package:belaaraby/addEditStore/components/productsPicker/addCateg/addCategDialog/addCategView.dart';
import 'package:belaaraby/models/itemModel.dart';
import 'package:belaaraby/models/storeModel.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';

import 'addItem/addItemDialog/addItemCtr.dart';
import 'addItem/addItemDialog/addItemView.dart';

class ProductsCtr extends GetxController {
  Map<String, dynamic> promos = {};
  Map<String, dynamic> categories = {};
  Map<String, dynamic> categImages = {};
  Map<String, Map<String, Map<String, String>>> categToPureMap = {};
  Store st = Get.find<HomeCtr>().selectedSt;


  String selectedCategory='';
  Item selectedItem = Item();

  selectItem(item) {
    selectedItem = item;
  }


  printCategories() async {
    print('## Store has < ${categToPureMap.length} > categories');
    for (var categName in categToPureMap.keys) {
      print('  ## categogy < $categName > has < ${categToPureMap[categName]!.length} > items');
    }
  }


  changeCateg(categ) {
    selectedCategory = categ;
    print('## selected categ <$selectedCategory>');
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    print('## init ProductsCtr');
    categories=st.categories!;
    categImages=st.categImages!;
    promos=st.promos!;
  }








  ///new categ
  addCategDialog(ctx) {
    showDialog(
      barrierDismissible: false,
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: blueColHex2,

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        content: Builder(
          builder: (context) {
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;

            return SizedBox(
              height: height / 2.2,
              width: width,
              child: AddCategView(),
            );
          },
        ),
      ),
    );

    update();
  }

  ///new item
  addItemDialog(ctx) {
    showDialog(
      barrierDismissible: false,
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: blueColHex2,

        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        content: Builder(
          builder: (context) {
            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;

            return SizedBox(
              height: height / 1.7,
              width: width,
              child: AddItemView(),
            );
          },
        ),
      ),
    );

    update();
  }

// Future<void> updateStoreProducts(ctx) async {
//   MyVoids().showLoading(ctx);
//
//   //String stID = st.id!;
//   String stID = st.id!;
//
//
//   await categoriesToMap();
//
//   storesColl.doc(stID).update({
//     'categories': categToPureMap,
//   }).then((value) async {
//     print("### STORE CATEGORIES UPDATED");
//
//     //hide loading dialog
//     Get.back();
//
//     // await MyVoids().showSuccess(
//     //   ctx,
//     //   sucText: 'votre store a été mis à jour avec succès',
//     //   btnOkPress: () {
//     //     print('## btn_Ok_Pressed');
//     //   },
//     // );
//   }).catchError((error) async {
//     //hide loading dialog
//     Get.back();
//
//     // garage can't updated
//     print("Failed to update store: $error");
//    // await MyVoids().showFailed(ctx);
//   });
// }

}
