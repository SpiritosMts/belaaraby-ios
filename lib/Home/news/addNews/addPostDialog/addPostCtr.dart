import 'package:belaaraby/addEditStore/components/productsPicker/productsCtr.dart';
import 'package:belaaraby/models/itemModel.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AddPostCtr extends GetxController {
  final formkeyItem = GlobalKey<FormState>();
  final TextEditingController postTitleController = TextEditingController();
  final TextEditingController postDescController = TextEditingController();
  PickedFile? newPostImage;


  void onInit() {
    super.onInit();
    print('## init AddPostCtr');


  }
  deleteImage() {
    newPostImage = null;
    update();
  }




  Future<void> addPostToStore(ctx) async {

    String title = postTitleController.text;
    String desc = postDescController.text;
    String date = todayToString();

    if (formkeyItem.currentState!.validate()) {
      showLoadingDia(ctx);

      Map<String,dynamic> postProps ={
        'title':title,
        'desc':desc,
        'date': date
      };
      await postsColl.add(
        postProps
      ).then((value) async {
        print('## New post added');
        //add id
        String postID = value.id;
        //add images & logo;
        String postImageUrl = await uploadOneImgToFb('posts/$postID', newPostImage);
        //set id
        postsColl.doc(postID).update({
          'image':postImageUrl,
          'id': postID,
        });
        update();
        Get.back();
        Get.back();

        Get.delete<AddPostCtr>();
        MyVoids().showTos('New post added'.tr);
      }).catchError((error) async {
        Get.back();

        print('## failed to add item');
        MyVoids().showTos('failed to add post'.tr);
      });

    }
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
                      newPostImage = await ImagePicker().getImage(
                        source: ImageSource.gallery,
                      );
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
                      newPostImage = await ImagePicker().getImage(
                        source: ImageSource.camera,
                      );
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
