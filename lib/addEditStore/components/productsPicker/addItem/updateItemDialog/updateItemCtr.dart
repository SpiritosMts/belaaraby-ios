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

class UpdateItemCtr extends GetxController {
  final formkeyItem = GlobalKey<FormState>();

  final ProductsCtr pc = Get.find<ProductsCtr>();
  Item item = Get.find<ProductsCtr>().selectedItem;
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController itemPriceController = TextEditingController();
  final TextEditingController itemDescController = TextEditingController();
   String itemCurrency = '';
  PickedFile? newItemImage;
 late String oldItemImageUrl;



  void onInit() {
    super.onInit();
    print('## init AddItemCtr');
      itemNameController.text=item.name!;
      itemPriceController.text=item.price!;
      itemDescController.text=item.desc!;
      oldItemImageUrl=item.imageUrl!;
      itemCurrency = item.currency!;
    update();

  }
  proposeDeleteLogo(context) {
    MyVoids().shownoHeader(context).then((value) {
      if (value) {
        ///delete from cloud
        deleteOldItemImage(context,pc.st.id!);
      }
    });
  }
  deleteImage() {
    newItemImage = null;
    update();
  }
  deleteOldItemImage(ctx,id){
    storesColl.doc(id).get().then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        //get existing raters of garage
        Map<String, dynamic> categs = documentSnapshot.get('categories');

          categs[item.categ][item.name]['imageUrl'] = '';

          //add raters again map to cloud
          await storesColl.doc(id).update({
            'categories': categs,
          }).then((value) async {
            print('## image deleted from cloud');

            print('## bf $oldItemImageUrl');
            ///delete from storage
            deleteFileByUrlFromStorage(oldItemImageUrl);


            oldItemImageUrl = '';
            update();
            print('## af $oldItemImageUrl');

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

  Future<void> updateItemInStore(ctx,String id) async {

    String newItemName = itemNameController.text;
    String newItemPrice = itemPriceController.text;
    String newItemDesc = itemDescController.text;
    if (formkeyItem.currentState!.validate()) {
      showLoadingDia(ctx);



      storesColl.doc(id).get().then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        //get existing raters of garage
        Map<String, dynamic> categs = documentSnapshot.get('categories');
        //print('current categories: ${categs.length}');

        if(!categs[pc.selectedCategory]!.containsKey(newItemName) || newItemName==item.name) {

          //upload image
          String itemImageUrl = await uploadOneImgToFb('stores/${pc.st.id}/categories/${pc.selectedCategory}/$newItemName', newItemImage);


          categs[pc.selectedCategory]!.remove(item.name);
          //create item map
          Map<String, String> newItemToAdd = {
            'name': newItemName,
            'price': newItemPrice,
            'currency': item.currency!,
            'desc': newItemDesc,
            'imageUrl': oldItemImageUrl!='' ? oldItemImageUrl:itemImageUrl,
            'categ': pc.selectedCategory,
            'promoted': 'false',
            'newPrice': '',
          };
          //add or update rating of curr user
          categs[pc.selectedCategory][newItemToAdd['name']] = newItemToAdd;

          //add raters again map to cloud
          await storesColl.doc(id).update({
            'categories': categs,
          }).then((value) async {
            print('## item updated');

            update();
            Get.back();
            Get.back();
            Get.back();

            Get.delete<UpdateItemCtr>();
            MyVoids().showTos('item updated'.tr);
          }).catchError((error) async {
            Get.back();

            print('## failed to updated item');
            MyVoids().showTos('failed to updated item'.tr);
          });
        }else{
          Get.back();

          MyVoids().showTos("Item already exist".tr);
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
                      newItemImage = await ImagePicker().getImage(
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
                      newItemImage = await ImagePicker().getImage(
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
