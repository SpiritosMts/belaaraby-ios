import 'package:belaaraby/addEditStore/components/productsPicker/productsCtr.dart';
import 'package:belaaraby/models/itemModel.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AddCategCtr extends GetxController {

  final ProductsCtr pc = Get.find<ProductsCtr>();
  final TextEditingController categController = TextEditingController();
  final formkeyCateg = GlobalKey<FormState>();

  PickedFile? newCategImage;
  String oldItemImageUrl='';
  bool toModify =true;



  void onInit() {
    super.onInit();
    print('## init AddCategCtr');


  }

  deleteImage() {
    newCategImage = null;
    update();
  }


  void addCategoryToStore(ctx,String id) {
    String newCategName = categController.text;

    if (formkeyCateg.currentState!.validate()) {
      showLoadingDia(ctx);

      storesColl.doc(id).get().then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          Map<String, dynamic> categs = documentSnapshot.get('categories');
          Map<String, dynamic> categsImgs = documentSnapshot.get('categImages');

          if (!categs.containsKey(newCategName)) {

            String categImageUrl = await uploadOneImgToFb('stores/${pc.st.id}/categoriesImages/$newCategName', newCategImage);

            //add or update rating of curr user
            categs[newCategName] = {};
            categsImgs[newCategName] = categImageUrl ;

            //add raters again map to cloud
            await storesColl.doc(id).update({
              'categories': categs,
              'categImages': categsImgs,
            }).then((value) async {
              //selectedCategory = newCategName;

              categController.clear();
              update();
              Get.back();
              Get.back();
              Get.delete<AddCategCtr>();

              print('## New category added');
              MyVoids().showTos('New category added'.tr);
            }).catchError((error) async {
              Get.back();

              print('## failed to add category');
              MyVoids().showTos('failed to add category'.tr);
            });
          } else {
            Get.back();

            MyVoids().showTos("Category already exist".tr);
          }
        } else {
          Get.back();

          print('## store with id <$id> dont exist');
        }
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
                      newCategImage = await ImagePicker().getImage(
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
                      newCategImage = await ImagePicker().getImage(
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
