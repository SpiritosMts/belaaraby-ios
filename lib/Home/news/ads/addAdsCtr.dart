

import 'package:belaaraby/Home/news/addNews/addPostDialog/addPostView.dart';
import 'package:belaaraby/Home/news/addNews/addVideoDialog/addVideoView.dart';
import 'package:belaaraby/myPacks/firebase/fireBase.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AddAdsCtr extends GetxController{

  PickedFile? newItemImage;
  String adUrl='';
  bool canAffectUrl =true;

  @override
  void onInit() {
    super.onInit();
    print('## init AddAdsCtr');


  }

  @override
  void onClose() {
    super.onInit();
    print('## close AddAdsCtr');
  }


  proposeDeleteAd(context) {
    MyVoids().shownoHeader(context,txt: 'Are you sure you want to delete this Ad'.tr).then((value) async {
      if (value) {
        ///delete from cloud
        await adsColl.doc('adverID').update({
          'adUrl': '',
        }).then((value) async {

          MyVoids().showTos('ad deleted'.tr);
          ///delete from storage
          print('## gonna delete image with url <$adUrl>');
         await deleteFileByUrlFromStorage(adUrl);
          newItemImage=null;
          adUrl='';

          showChoiceDialog(context);
          update();

        }).catchError((error) async {
          Get.back();
          print('## failed to delete ad');
          MyVoids().showTos('failed to delete ad'.tr);
        });

      }
    });
  }

  Future<void> addAd() async {


      //showLoadingDia(ctx);
      String ImageUrl = await uploadOneImgToFb('ads', newItemImage);

      await adsColl.doc('adverID').update({
        'adUrl': ImageUrl,
      }).then((value) async {

        update();

        canAffectUrl=true;
        MyVoids().showTos('ad added'.tr);

      }).catchError((error) async {
        Get.back();

        print('## failed to delete ad');
        MyVoids().showTos('failed to upload ad'.tr);
      });


  }

  Future<PickedFile?> showChoiceDialog(BuildContext context) async {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            backgroundColor: blueColHex2,

            title: Text(
              "Choose source".tr,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  const Divider(
                    height: 1,
                  ),
                  ListTile(
                    onTap: () async {
                      newItemImage = await ImagePicker().getImage(
                        source: ImageSource.gallery,
                      );

                      if(newItemImage!=null){
                        addAd();
                      }
                      update();
                      Get.back();
                    },
                    title: Text("Gallery".tr),
                    leading: const Icon(
                      Icons.account_box,
                    ),
                  ),
                  const Divider(
                    height: 1,
                  ),
                  ListTile(
                    onTap: () async {
                      newItemImage = await ImagePicker().getImage(
                        source: ImageSource.camera,
                      );
                      if(newItemImage!=null){
                        addAd();
                      }
                      update();
                      Get.back();
                    },
                    title: Text("Camera".tr),
                    leading: const Icon(
                      Icons.camera,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }


}