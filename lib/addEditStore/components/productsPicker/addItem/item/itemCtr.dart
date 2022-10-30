import 'package:belaaraby/addEditStore/components/productsPicker/addItem/item/itemView.dart';
import 'package:belaaraby/addEditStore/components/productsPicker/addItem/updateItemDialog/updateItemView.dart';
import 'package:belaaraby/addEditStore/components/productsPicker/productsCtr.dart';
import 'package:belaaraby/models/itemModel.dart';
import 'package:belaaraby/myPacks/firebase/fireBase.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:belaaraby/myPacks/storeVoids.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ItemCtr extends GetxController {
  Item item = Get.find<ProductsCtr>().selectedItem;
  ProductsCtr pc = Get.find<ProductsCtr>();
  final TextEditingController newPriceController = TextEditingController();

  promoDialog(ctx) {
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
              height: height / 3.5,
              width: width,
              child: Column(
                children: [
                  Text(
                    'Promo Item'.tr,
                    style: GoogleFonts.almarai(
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: RichText(
                      locale: Locale(currLang!),
                      textAlign: TextAlign.start,
                      softWrap: true,
                      text: TextSpan(children: [

                        TextSpan(
                          text: '${'current price'.tr}:',
                          style:  GoogleFonts.almarai(
                            fontSize: 16.sp,
                            height: 1.5,
                          ),
                        ), TextSpan(
                          text: ' ${item.price} ',
                          style:  GoogleFonts.almarai(
                            color: yellowColHex,
                            fontSize: 18.sp,
                            height: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: currencySymbol(item.currency!),
                          style:  GoogleFonts.almarai(
                            fontSize: 16.sp,
                            height: 1.5,
                          ),
                        ),
                      ]),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    textInputAction: TextInputAction.done,
                    controller: newPriceController,
                    onEditingComplete: () {
                      fieldUnfocusAll();
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      suffix: Text(currencySymbol(item.currency!),
                          style: GoogleFonts.almarai(
                            textStyle: const TextStyle(

                                //fontSize: 15
                                ),
                          )),
                      //icon: Icon(Icons.email),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      labelText: 'new price'.tr,
                      //hintText: 'Enter new price'.tr,
                    ),

                  ),
                  //buttons
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
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
                        //promo
                        TextButton(
                          style: ylwStyle,
                          onPressed: () {
                            promoteItem(pc.st.id!);
                          },
                          child: Text(
                            "Promo".tr,
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

    update();
  }

  void removeItemFromStore(String id) {
    storesColl.doc(id).get().then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        //get existing raters of garage
        Map<String, dynamic> categs = documentSnapshot.get('categories');
        Map<String, dynamic> promos = documentSnapshot.get('promo');
        Map<String, dynamic> itemsOfCateg = categs[pc.selectedCategory];
        itemsOfCateg.remove(item.name);
        if (promos.containsKey(item.name)) {
          promos.remove(item.name);
        }
        //print('## categories after remove: ${categs[pc.selectedCategory].length}');
        categs[pc.selectedCategory] = itemsOfCateg;

        //add raters again map to cloud
        await storesColl.doc(id).update({
          'categories': categs,
          'promo': promos,
        }).then((value) async {
          print('## item removed');
          //delete image from storage
          if (item.imageUrl! != '') {
            deleteFileByUrlFromStorage(item.imageUrl!);
          }
          update();
          Get.back();
          MyVoids().showTos('item removed'.tr);
        }).catchError((error) async {
          print('## failed to remove item');
          //MyVoids().showTos('failed to remove item'.tr);
        });
      } else {
        print('## store with id <$id> dont exist');
      }
    });
  }

  void promoteItem(String id) {
    String newPrice = newPriceController.text;
    storesColl.doc(id).get().then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        // add to promo list
        Map promos = documentSnapshot.get('promo');

        if (!promos.containsKey(item.name)) {
          //remove from categories
          Map<String, dynamic> categs = documentSnapshot.get('categories');

          Map<String, dynamic> itemsOfCateg = categs[pc.selectedCategory];

          Map<String, dynamic> itemToPromote = itemsOfCateg[item.name];
          itemToPromote['newPrice'] = newPrice;
          itemToPromote['promoted'] = 'true';
          promos[item.name] = itemToPromote;
          categs[pc.selectedCategory] = itemsOfCateg;

          //add raters again map to cloud
          await storesColl.doc(id).update({
            'categories': categs,
            'promo': promos,
          }).then((value) async {
            print('## item promoted');

            update();
            Get.back();
            Get.back();
            MyVoids().showTos('item promoted'.tr);
          }).catchError((error) async {
            print('## failed to promote item');
            MyVoids().showTos('failed to promote item'.tr);
          });
        } else {
          MyVoids().showTos('item already promoted'.tr);
        }
      } else {
        print('## store with id <$id> dont exist');
      }
    });
  }

  void stopPromoteItem(String id) {
    storesColl.doc(id).get().then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        // add to promo list
        Map promos = documentSnapshot.get('promo');

        //remove from categories
        Map<String, dynamic> categs = documentSnapshot.get('categories');

        Map<String, dynamic> itemToStopPromo = categs[item.categ][item.name];

        promos.remove(item.name);

        itemToStopPromo['newPrice'] = '';
        itemToStopPromo['promoted'] = 'false';
        categs[item.categ!][item.name] = itemToStopPromo;

        //add raters again map to cloud
        await storesColl.doc(id).update({
          'categories': categs,
          'promo': promos,
        }).then((value) async {
          print('## end promo');

          update();
          Get.back();
          MyVoids().showTos('end item promotion'.tr);
        }).catchError((error) async {
          print('## failed to end promoting item');
          //MyVoids().showTos('failed to end item promo'.tr);
        });
      } else {
        print('## store with id <$id> dont exist');
      }
    });
  }


  updateItemDialog(ctx) {
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
              height: height / 1.5, //This is the important part for you
              width: width, //This is the important part for you
              child: UpdateItemView(),
            );
          },
        ),
      ),
    );

    update();
  }

}
