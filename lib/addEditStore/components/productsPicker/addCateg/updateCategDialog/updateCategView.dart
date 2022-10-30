import 'dart:io';

import 'package:belaaraby/addEditStore/components/productsPicker/addCateg/updateCategDialog/updateCategCtr.dart';
import 'package:belaaraby/addEditStore/components/productsPicker/addItem/addItemDialog/addItemCtr.dart';
import 'package:belaaraby/addEditStore/components/productsPicker/addItem/updateItemDialog/updateItemCtr.dart';
import 'package:belaaraby/addEditStore/components/productsPicker/productsCtr.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

class UpdateCategView extends StatelessWidget {
  UpdateCategCtr gc = Get.find<UpdateCategCtr>();
  ProductsCtr pc = Get.find<ProductsCtr>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.height;
    return GetBuilder<UpdateCategCtr>(
        initState: (_) {
          print('## open UpdateCategView View');
        },
        dispose: (_) {
          print('## close UpdateCategView View');
          Get.delete<UpdateCategCtr>();
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
                    // categ_name
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        textInputAction: TextInputAction.done,
                        controller: gc.categNameController,
                        onEditingComplete: () {
                          fieldUnfocusAll();
                        },
                        onTap: () {
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding:  EdgeInsets.only(bottom: btmPaddingInput),
                          hintStyle: const TextStyle(fontSize: 13),
                          //icon: Icon(Icons.email),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          labelText: 'category name'.tr,
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

                    //categ_image
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
                                if (gc.oldCategImageUrl == '') {
                                  await gc.showChoiceDialog(context);
                                } else {
                                  gc.proposeDeleteImg(context);
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
                                        child: gc.oldCategImageUrl != ''
                                            ? Image.network(
                                                gc.oldCategImageUrl,
                                                fit: BoxFit.cover,
                                              )
                                            : gc.newCategImage != null
                                                ? Image.file(
                                                    File(gc.newCategImage!.path),
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.asset('assets/noImage.jpg'),
                                      ),
                                    ),
                                  ),

                                  ///delete
                                  gc.oldCategImageUrl != ''
                                      ? Positioned(
                                          top: -11,
                                          right: -11,
                                          child: IconButton(
                                              icon: const Icon(Ionicons.close_circle),
                                              color: Colors.red,
                                              splashRadius: 1,
                                              onPressed: () {
                                                gc.proposeDeleteImg(context);
                                              }),
                                        )
                                      : gc.newCategImage != null
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
                              await gc.updateCategInStore(context, pc.st.id!);
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
