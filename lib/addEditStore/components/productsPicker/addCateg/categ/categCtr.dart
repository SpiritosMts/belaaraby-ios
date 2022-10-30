
import 'package:belaaraby/Home/homeCtr.dart';
import 'package:belaaraby/addEditStore/components/productsPicker/addCateg/updateCategDialog/updateCategView.dart';
import 'package:belaaraby/addEditStore/components/productsPicker/productsCtr.dart';
import 'package:belaaraby/models/itemModel.dart';
import 'package:belaaraby/models/storeModel.dart';
import 'package:belaaraby/myPacks/firebase/fireBase.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:belaaraby/tutoCtr.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CategCtr extends GetxController {
  final ProductsCtr gc = Get.find<ProductsCtr>();

  Store st = Get.find<ProductsCtr>().st;


  void removeCategoryFromStore(String id, categoryToRemove) {
    print('## selectedCategory: ${gc.selectedCategory}');

    storesColl.doc(id).get().then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        //get existing raters of garage
        Map<String, dynamic> categs = documentSnapshot.get('categories');
        Map<String, dynamic> categsImgs = documentSnapshot.get('categImages');
        Map<String, dynamic> promos = documentSnapshot.get('promo');
        Map<String, dynamic> categ = categs[categoryToRemove];

        categs.remove(categoryToRemove);
        if(categsImgs[categoryToRemove]!=''){
          deleteFileByUrlFromStorage(categsImgs[categoryToRemove]);
        }
        if(categsImgs.containsKey(categoryToRemove)){
          categsImgs.remove(categoryToRemove);
        }

        for (var itemName in categ.keys) {
          if (promos.containsKey(itemName)) {
            promos.remove(itemName);
          }
        }

        //add raters again map to cloud
        await storesColl.doc(id).update({
          'categories': categs,
          'categImages': categsImgs,
          'promo': promos,
        }).then((value) async {
          Get.back();
          Get.back();

          gc.selectedCategory='';
          update();
          print('## category removed');
          MyVoids().showTos('category removed'.tr);
        }).catchError((error) async {
          print('## failed to remove category');
          MyVoids().showTos('failed to remove category'.tr);
        });
      } else {
        print('## store with id <$id> dont exist');
      }
    });
  }

  removeCategDialog(ctx) {
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
              height: height / 4.5,
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 13.0),
                    child: Text(
                        "Are you sure you want to remove this category".tr,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.almarai(
                        textStyle:  TextStyle(
                            fontSize: 19.sp,
                          height: 1.6
                        ),
                      ),
                    ),
                  ),
                  //buttons
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0, top: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //cancel
                        TextButton(
                          style: blueStyle,
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            "Cancel".tr,
                            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                          ),
                        ),
                        //remove
                        TextButton(
                          style: ylwStyle,
                          onPressed: ()  {
                            removeCategoryFromStore(st.id!, gc.selectedCategory);
                          },
                          child: Text(
                            "Remove".tr,
                            style: TextStyle(color: Theme.of(context).backgroundColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  updateCategDialog(ctx) {
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
              height: height / 2.4,
              width: width,
              child: UpdateCategView(),
            );
          },
        ),
      ),
    );

    update();
  }


}