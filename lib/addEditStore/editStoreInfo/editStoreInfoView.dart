import 'package:belaaraby/addEditStore/components/imagePicker/imageView.dart';
import 'package:belaaraby/addEditStore/components/mapNoAddrPicker/mapView.dart';
import 'package:belaaraby/addEditStore/components/radioPicker/radioView.dart';
import 'package:belaaraby/addEditStore/components/textFields/fieldsView.dart';
import 'package:belaaraby/addEditStore/components/timesPicker/timesView.dart';
import 'package:belaaraby/addEditStore/editStoreInfo/editStoreInfoCtr.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:belaaraby/myPacks/storeVoids.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import 'package:belaaraby/auth/login_screen.dart';
import 'package:belaaraby/myPacks/myConstants.dart';



class EditStoreView extends StatelessWidget {

  final EditStoreInfoCtr getCtrl = Get.find<EditStoreInfoCtr>();


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => fieldUnfocusAll(),

      child: Scaffold(
          appBar: AppBar(
            title: Text('Modify Store'.tr),
            bottom: appBarUnderline(),


          ),
          body: GetBuilder<EditStoreInfoCtr>(

            builder: (ctr)=>Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFieldsView(),
                    ylwDivider(),
                    //PickRadiosView(),
                    //  ylwDivider(),
                    PickMapView(),
                    ylwDivider(),
                    PickImagesView(),
                    ylwDivider(),
                    PickTimesView(),
                    ylwDivider(),
                    /// update
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15), // <-- Radius
                            ),
                            primary: Theme.of(context).colorScheme.primary,
                            onPrimary: Colors.white, // foreground
                          ),
                          //to make error appeear in the two boxs you must give code and stree input same formKey
                          onPressed: () {
                            getCtrl.updateStore(context);
                           // getCtrl.printProps();

                          },

                          child:  Text(
                            'Save'.tr,
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15), // <-- Radius
                            ),
                            primary: Colors.redAccent,
                            onPrimary: Colors.white, // foreground
                          ),
                          //to make error appeear in the two boxs you must give code and stree input same formKey
                          onPressed: () {
                            deleteStoreDialog(context,getCtrl.st);
                            //getCtrl.printProps();

                          },

                          child:  Text(
                            'delete'.tr,
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25,vertical: 15),

                    ),
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }


}
