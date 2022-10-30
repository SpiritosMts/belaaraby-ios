import 'package:belaaraby/addEditStore/components/imagePicker/imageView.dart';
import 'package:belaaraby/addEditStore/components/mapNoAddrPicker/mapView.dart';
import 'package:belaaraby/addEditStore/components/productsPicker/productsView.dart';
import 'package:belaaraby/addEditStore/components/textFields/fieldsView.dart';
import 'package:belaaraby/addEditStore/components/timesPicker/timesView.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import '../components/radioPicker/radioView.dart';
import 'addStoreCtr.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';

class AddStoreView extends StatelessWidget {
  final AddStoreCtr getCtrl = Get.find<AddStoreCtr>();



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => fieldUnfocusAll(),
      child: Scaffold(
          appBar: AppBar(
            title: Text('Add your own store'.tr),
            bottom: appBarUnderline(),
          ),
          body: GetBuilder<AddStoreCtr>(
            builder: (ctr) => SingleChildScrollView(
              child: Column(
                children: [
                  TextFieldsView(),
                  ylwDivider(),
                  PickRadiosView(),
                  ylwDivider(),
                  PickMapView(),
                   ylwDivider(),
                   PickImagesView(),
                  ylwDivider(),
                  PickTimesView(),
                  ylwDivider(),
                  ///add
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      fieldUnfocusAll();
                      getCtrl.addStore(context);
                      getCtrl.printProps();
                    },
                    child: Text(
                      'Add'.tr,
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
