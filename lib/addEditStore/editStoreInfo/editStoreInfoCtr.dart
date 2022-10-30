import 'dart:async';
import 'package:belaaraby/addEditStore/components/imagePicker/imageCtr.dart';
import 'package:belaaraby/addEditStore/components/mapNoAddrPicker/mapCtr.dart';
import 'package:belaaraby/addEditStore/components/textFields/fieldsCtr.dart';
import 'package:belaaraby/addEditStore/components/timesPicker/timesCtr.dart';
import 'package:belaaraby/models/brUserModel.dart';
import 'package:belaaraby/models/storeModel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:belaaraby/Home/homeCtr.dart';
import 'package:belaaraby/Home/homeView.dart';

import 'package:belaaraby/myPacks/firebase/fireBase.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myVoids.dart';


class EditStoreInfoCtr extends GetxController {


  final TextFieldsCtr pFields = Get.find<TextFieldsCtr>();
  final MapPickerCtr pLocation = Get.find<MapPickerCtr>();
  final ImagePickerCtr pImages = Get.find<ImagePickerCtr>();
  final TimesPickerCtr pTimes = Get.find<TimesPickerCtr>();
  Store st =  Get.find<HomeCtr>().selectedSt;
  BrUser cUser = authCtr.cUser;
  bool isEdit=false;

  @override
  void onInit() {
    super.onInit();
    print('## onInit EditStoreInfoCtr');
    isEdit=true;
    editInitialize();

  }



  goHome(){
    //Get.offAll(()=>GaragesMapView());
    Get.back();
    Get.back();
  }





  editInitialize(){
    /// init Common
    pFields.nameTextController.text =st.name??'';
    pFields.taxTextController.text =st.tax??'';
    pFields.phoneTextController.text =st.phone??'';
    pFields.jobDescTextController.text =st.jobDesc??'';
    pFields.addressTextController.text =st.address??'';


    /// init PickLocation
    pLocation.lati =st.latitude??0.0;
    pLocation.lngi =st.longitude??0.0;
    pLocation.shouldGetFromAddress =false;


    /// init Images
    pImages.imagesUrl =st.images??[];
    pImages.logoUrl = st.logo!;
    pImages.logoDeleted = st.logo! !=''?false:true;
    pImages.stID =st.id??'';

    /// init OpenHours
    Map openDaysData = mapToString(st.openDays!);
    Map openHoursData = mapToString(st.openHours!);
    // Map<String, String> => Map<String, bool>
    Map<String, bool> openDays = {
      "mo": openDaysData['mo'] == 'true',
      "tu": openDaysData['tu'] == 'true',
      "we": openDaysData['we'] == 'true',
      "th": openDaysData['th'] == 'true',
      "fr": openDaysData['fr'] == 'true',
      "sa": openDaysData['sa'] == 'true',
      "su": openDaysData['su'] == 'true',
    };
    // Map<String, String> => Map<String, TimeOfDay>
    Map<String, TimeOfDay> openHours = {
      "mo_o": stringToTimeOfDay(openHoursData['mo_o']),
      "mo_c": stringToTimeOfDay(openHoursData['mo_c']),
      "tu_o": stringToTimeOfDay(openHoursData['tu_o']),
      "tu_c": stringToTimeOfDay(openHoursData['tu_c']),
      "we_o": stringToTimeOfDay(openHoursData['we_o']),
      "we_c": stringToTimeOfDay(openHoursData['we_c']),
      "th_o": stringToTimeOfDay(openHoursData['th_o']),
      "th_c": stringToTimeOfDay(openHoursData['th_c']),
      "fr_o": stringToTimeOfDay(openHoursData['fr_o']),
      "fr_c": stringToTimeOfDay(openHoursData['fr_c']),
      "sa_o": stringToTimeOfDay(openHoursData['sa_o']),
      "sa_c": stringToTimeOfDay(openHoursData['sa_c']),
      "su_o": stringToTimeOfDay(openHoursData['su_o']),
      "su_c": stringToTimeOfDay(openHoursData['su_c']),
    };

    pTimes.openHours = openHours;
    pTimes.openDays = openDays;

  }

  Future<void> updateStore(ctx) async {
    fieldUnfocusAll();

    String stID = st.id!;

    //info
    String name = pFields.nameTextController.text;
    String tax = pFields.taxTextController.text;
    String website = pFields.websiteTextController.text;
    String phone = pFields.phoneTextController.text;
    String address = pFields.addressTextController.text;
    String jobDesc = pFields.jobDescTextController.text;

    //location
    double lati = pLocation.lati;
    double lngi = pLocation.lngi;

    //hours
    Map<String, String> openHoursString = pTimes.openHoursString;
    Map<String, bool> openDays = pTimes.openDays!;
    //images
    //   PickedFile? logo = pImages.imageFile;
    //   List<PickedFile>? images = pImages.imageFileList;
    //user
    // String? ownerID = cUser.id;
    // String? ownerName = cUser.name;

    if (pFields.formKeyCommon.currentState!.validate() || shouldNotVerifyInputs) {
      print('## Verified store formular inputs');

        MyVoids().showLoading(ctx);

        storesColl.doc(stID).update({

          'name': name,
          'tax': tax,
          'website': website,
          'phone': phone,
          'address': address,
          'jobDesc': jobDesc,
          'coords': GeoPoint(lati, lngi),
          //
          'openDays': openDays,
          'openHours': openHoursString,


        }).then((value) async {

          //update images & logo;
          await pImages.uploadAllImages(stID);

          //hide loading dialog
          Get.back();

          await MyVoids().showSuccess(
            ctx,
            sucText: 'store updated successfully'.tr,
            btnOkPress: () {
              goHome();
            },
          );
          print("### STORE UPDATED");

        }).catchError((error) async {
          Get.back();

          // store can't updated
          print("## Failed to update store: $error");
          await MyVoids().showFailed(ctx,faiText: 'Failed to update store'.tr);
        });

    } else {
      MyVoids().showTos('you must fill in the fields'.tr);
    }
  }

  printProps(){
    print('### name: ${pFields.nameTextController.text} '
        '_phone: ${pFields.phoneTextController.text} '
        '_jobDesc: ${pFields.jobDescTextController.text} '
        '_address: ${pFields.addressTextController.text} '
        '_tax: ${pFields.taxTextController.text}');
    print('### location<coords>: ${pLocation.lati} _ ${pLocation.lngi} ');
    print('### hours<openDays>: ${pTimes.openDays} | hours<openHours>: ${pTimes.openHours}');

  }


}
