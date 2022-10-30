import 'dart:io';

import 'package:belaaraby/addEditStore/components/productsPicker/addItem/addItemDialog/addItemCtr.dart';
import 'package:belaaraby/addEditStore/components/productsPicker/addItem/updateItemDialog/updateItemCtr.dart';
import 'package:belaaraby/addEditStore/components/productsPicker/productsCtr.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:belaaraby/myPacks/storeVoids.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UpdateItemView extends StatelessWidget {
  UpdateItemCtr gc = Get.find<UpdateItemCtr>();
  ProductsCtr pc = Get.find<ProductsCtr>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.height;
    return GetBuilder<UpdateItemCtr>(
        initState: (_) {
          print('## open UpdateItemView View');
        },
        dispose: (_) {
          print('## close UpdateItemView View');
          Get.delete<UpdateItemCtr>();
        },
        builder: (ctr) => SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: gc.formkeyItem,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Modify Item'.tr,
                        style: GoogleFonts.almarai(
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    // item_name
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        textInputAction: TextInputAction.done,
                        controller: gc.itemNameController,
                        onEditingComplete: () {
                          fieldUnfocusAll();
                        },
                        onTap: () {
                          print('## newItem: ${gc.newItemImage}');
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding:  EdgeInsets.only(bottom: btmPaddingInput),
                          hintStyle: const TextStyle(fontSize: 13),
                          //icon: Icon(Icons.email),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          labelText: 'item name'.tr,
                          //hintText: 'Enter item name'.tr,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "name can\'t be empty".tr;
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    //item_price
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        textInputAction: TextInputAction.done,
                        controller: gc.itemPriceController,
                        onEditingComplete: () {
                          fieldUnfocusAll();
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding:  EdgeInsets.only(bottom: btmPaddingInputPrc),
                          hintStyle: const TextStyle(fontSize: 13),
                          suffix: Padding(
                            padding: const EdgeInsets.only(bottom: 0.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(0),
                                border: Border.all(color: hintYellowColHex, width: 1, style: BorderStyle.solid),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(5,2,5,2),
                                child: Text(currencySymbol(gc.itemCurrency),
                                    style: GoogleFonts.almarai(
                                      textStyle:  TextStyle(
                                        color: hintYellowColHex3,
                                        fontSize: 18.sp,
                                        //height: 1
                                      ),
                                    )),
                              ),
                            ),
                          ),
                          //icon: Icon(Icons.email),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          labelText: 'Price'.tr,
                          //hintText: 'Enter price'.tr,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "price can\'t be empty".tr;
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    //item_desc
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(200), // max length
                        ],
                        textInputAction: TextInputAction.done,
                        controller: gc.itemDescController,
                        onEditingComplete: () {
                          fieldUnfocusAll();
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding:  EdgeInsets.only(bottom: btmPaddingInput),
                          hintStyle: const TextStyle(fontSize: 13),
                          //icon: Icon(Icons.email),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          labelText: 'Description'.tr,
                          //hintText: 'Enter description'.tr,
                        ),
                      ),
                    ),

                    //item_image
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0, top: 40.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //add image
                          ButtonTheme(
                            minWidth: width / 9,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (gc.oldItemImageUrl == '') {
                                  await gc.showChoiceDialog(context);
                                } else {
                                  gc.proposeDeleteLogo(context);
                                }
                              },
                              child: Text('Change Image'.tr),
                            ),
                          ),

                          //image_display
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0.0),
                            child: SizedBox(
                              child: Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(color: yellowColHex, borderRadius: BorderRadius.circular(9)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(9),
                                      child: SizedBox(
                                        width: width / 8.5,
                                        height: width / 13,
                                        //size: Size.fromRadius(30),
                                        child: gc.oldItemImageUrl != ''
                                            ? Image.network(
                                                gc.oldItemImageUrl,
                                                fit: BoxFit.cover,
                                              )
                                            : gc.newItemImage != null
                                                ? Image.file(
                                                    File(gc.newItemImage!.path),
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.asset('assets/noImage.jpg'),
                                      ),
                                    ),
                                  ),

                                  ///delete
                                  gc.oldItemImageUrl != ''
                                      ? Positioned(
                                          top: -11,
                                          right: -11,
                                          child: IconButton(
                                              icon: const Icon(Ionicons.close_circle),
                                              color: Colors.red,
                                              splashRadius: 1,
                                              onPressed: () {
                                                gc.proposeDeleteLogo(context);
                                              }),
                                        )
                                      : gc.newItemImage != null
                                          ? Positioned(
                                              top: -11,
                                              right: -11,
                                              child: IconButton(
                                                  icon: const Icon(Ionicons.close_circle),
                                                  color: Colors.grey,
                                                  splashRadius: 1,
                                                  onPressed: () {
                                                    gc.deleteImage();
                                                  }),
                                            )
                                          : Container(),
                                ],
                              ),
                            ),
                          ),
                        ],
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
                          //add
                          TextButton(
                            style: ylwStyle,
                            onPressed: () async {
                              await gc.updateItemInStore(context, pc.st.id!);
                            },
                            child: Text(
                              "Update".tr,
                              style: TextStyle(color: Theme.of(context).backgroundColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
