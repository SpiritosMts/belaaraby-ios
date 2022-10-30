import 'package:belaaraby/addEditStore/components/productsPicker/productsCtr.dart';
import 'package:belaaraby/models/itemModel.dart';
import 'package:belaaraby/myPacks/firebase/fireBase.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class UpdateCategCtr extends GetxController {
  final formkeyItem = GlobalKey<FormState>();

  final ProductsCtr pc = Get.find<ProductsCtr>();
  String categName = Get.find<ProductsCtr>().selectedCategory;
  final TextEditingController categNameController = TextEditingController();

  PickedFile? newCategImage;
  String oldCategImageUrl='';



  void onInit() {
    super.onInit();
    print('## init AddItemCtr');
    getSavedCategProps();
  }

  getSavedCategProps(){
    categNameController.text=categName;
    storesColl.doc(pc.st.id!).get().then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        Map<String, dynamic> categsImgs = documentSnapshot.get('categImages');
        oldCategImageUrl=categsImgs[categName];
        update();

      }
      else{
        print('## categ url not found');
      }
    });
    update();

  }

  proposeDeleteImg(context) {
    MyVoids().shownoHeader(context).then((value) {
      if (value) {
        ///delete from cloud
        deleteOldCategImage(context,pc.st.id!);
      }
    });
  }
  deleteImage() {
    newCategImage = null;
    update();
  }
  deleteOldCategImage(ctx,id){
    storesColl.doc(id).get().then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        //get existing raters of garage
        Map<String, dynamic> categsImgs = documentSnapshot.get('categImages');
        //categsImgs.remove(categName!);
        categsImgs[categName]='';

          //add raters again map to cloud
          await storesColl.doc(id).update({
            'categImages': categsImgs,
          }).then((value) async {
            print('## image deleted from cloud');

            print('## bf $oldCategImageUrl');
            ///delete from storage
            deleteFileByUrlFromStorage(oldCategImageUrl);


            oldCategImageUrl = '';
            update();
            MyVoids().showTos('image deleted'.tr);

          }).catchError((error) async {
            Get.back();

            print('## failed to delete image');
            MyVoids().showTos('failed to delete image'.tr);
          });

      }
      else{
        Get.back();

        print('## store with id <$id> dont exist');
      }
    });
  }

  Future<void> updateCategInStore(ctx,String id) async {

    String newCategName = categNameController.text;

    if (formkeyItem.currentState!.validate()) {
      showLoadingDia(ctx);



      storesColl.doc(id).get().then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        //get existing raters of garage
        Map<String, dynamic> categs = documentSnapshot.get('categories');
        Map<String, dynamic> categsImgs = documentSnapshot.get('categImages');
        Map<String, dynamic> promo = documentSnapshot.get('promo');

        //print('current categories: ${categs.length}');

        if(!categs.containsKey(newCategName) || newCategName==categName) {

          //upload image
          String categImageUrl = await uploadOneImgToFb('stores/${pc.st.id}/categoriesImages/$newCategName', newCategImage);
          Map<String, dynamic> categItems = categs[categName];
          categs.remove(categName);
          for(var item in categItems.values){
            item['categ']=newCategName;
          }
          for(var item in promo.values){
            if(item['categ']==categName){
              item['categ']=newCategName;

            }
          }
          categs[newCategName] = categItems;
          String categImg = categsImgs[categName];
          categsImgs.remove(categName);
          if(categImageUrl !=''){
            categsImgs[newCategName] = categImageUrl ;

          }else{
            categsImgs[newCategName] = categImg ;

          }


          //add raters again map to cloud
          await storesColl.doc(id).update({
            'categories': categs,
            'categImages': categsImgs,
            'promo': promo,
          }).then((value) async {
            print('## categ updated');

            update();
            Get.back();
            Get.back();
            Get.back();

            Get.delete<UpdateCategCtr>();
            MyVoids().showTos('category updated'.tr);
          }).catchError((error) async {
            Get.back();

            print('## failed to updated item');
            MyVoids().showTos('failed to updated category'.tr);
          });
        }else{
          Get.back();

            MyVoids().showTos("category already exist".tr);
        }
      }
      else{
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
