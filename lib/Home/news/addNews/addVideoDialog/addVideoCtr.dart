import 'package:belaaraby/addEditStore/components/productsPicker/productsCtr.dart';
import 'package:belaaraby/models/itemModel.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AddVideoCtr extends GetxController {
  final formkeyItem = GlobalKey<FormState>();
  final TextEditingController videoTitleController = TextEditingController();
  final TextEditingController videoUrlController = TextEditingController();


  void onInit() {
    super.onInit();
    print('## init AddVideoCtr');


  }


  deleteVideo(){

  }
  Future<void> addVideoToStore(ctx) async {

    String title = videoTitleController.text;
    String url = videoUrlController.text;
    String date = todayToString();
    if (formkeyItem.currentState!.validate()) {
      showLoadingDia(ctx);

      Map<String,dynamic> videoProps ={
        'title':title,
        'url':url,
        'date': date
      };
      await videosColl.add(
          videoProps
      ).then((value) async {
        print('## New video added');
        //add id
        String storeID = value.id;

        //set id
        videosColl.doc(storeID).update({
          'id': storeID,
        });
        update();
        Get.back();
        Get.back();

        Get.delete<AddVideoCtr>();
        MyVoids().showTos('New video added'.tr);
      }).catchError((error) async {
        Get.back();

        print('## failed to add item');
        MyVoids().showTos('failed to add video'.tr);
      });

    }
  }

}
