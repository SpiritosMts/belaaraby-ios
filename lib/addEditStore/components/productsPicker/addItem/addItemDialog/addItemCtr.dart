import 'package:belaaraby/addEditStore/components/productsPicker/productsCtr.dart';
import 'package:belaaraby/models/itemModel.dart';
import 'package:belaaraby/myPacks/firebase/fireBase.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:belaaraby/myPacks/storeVoids.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AddItemCtr extends GetxController {
  final formkeyItem = GlobalKey<FormState>();

  final ProductsCtr pc = Get.find<ProductsCtr>();
  Item item = Get.find<ProductsCtr>().selectedItem;
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController itemPriceController = TextEditingController();
  final TextEditingController itemDescController = TextEditingController();
  PickedFile? newItemImage;
  String oldItemImageUrl='';
  String currentCurrency = currencies[1];
  bool toModify =true;


  void onInit() async{
    super.onInit();
    print('## init AddItemCtr');
    currentCurrency= await getUserCurrency();

  }

 Future<String> getUserCurrency()async{
   String cr = 'euro';
   await usersColl.doc(authCtr.cUser.id).get().then((DocumentSnapshot documentSnapshot) async {
      String currency = documentSnapshot.get('currency');
      cr = currency;
    });
   Future.delayed(const Duration(milliseconds: 20), () {
     update();
   });
    print('## user currency: $cr');
    return cr;
  }

  deleteImage() {
    newItemImage = null;
    update();
  }

  Future<void> addItemToStore(ctx,String id) async {

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

        if(!categs[pc.selectedCategory]!.containsKey(newItemName)) {

          //upload image
          String itemImageUrl = await uploadOneImgToFb('stores/${pc.st.id}/categories/${pc.selectedCategory}/$newItemName', newItemImage);
          print('## item image added to storage');

          //create item map
          Map<String, String> newItemToAdd = {
            'name': newItemName,
            'price': newItemPrice,
            'desc': newItemDesc,
            'imageUrl': itemImageUrl,
            'categ': pc.selectedCategory,
            'currency': currentCurrency,
            'promoted': 'false',
            'newPrice': '',
          };

          //add or update rating of curr user
          categs[pc.selectedCategory][newItemToAdd['name']] = newItemToAdd;

          //add raters again map to cloud
          await storesColl.doc(id).update({
            'categories': categs,
          }).then((value) async {
            print('## New item added');

            update();
            Get.back();
            Get.back();

            Get.delete<AddItemCtr>();
            MyVoids().showTos('New item added'.tr);
          }).catchError((error) async {
            Get.back();

            print('## failed to add item');
           // MyVoids().showTos('failed to add item'.tr);
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

  currenciesList() {
  Widget  crncyWidget(index){
     return GestureDetector(
        onTap: () {
          updateDoc(usersColl,authCtr.cUser.id,
              {
                'currency':currencies[index],
              }
          );

          currentCurrency=currencies[index];
          Get.back();
          update();
        },
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(width: 2, color: yellowColHex.withOpacity(.3))),
          child: Center(
            child: Text(currencySymbol(currencies[index]),
              style: GoogleFonts.almarai(
                  color: yellowColHex
              ),
            ),
          ),
        )

      );
    }

    // return Column(
    //   children: [
    //     Padding(
    //       padding: const EdgeInsets.only(bottom: 35.0),
    //       child: Text(
    //         'choose currency'.tr,
    //         style: GoogleFonts.almarai(
    //           textStyle: const TextStyle(fontSize: 20),
    //         ),
    //       ),
    //     ),
    //     crncyWidget(0),
    //     const Divider(
    //       color: hintYellowColHex,
    //       thickness: 1,
    //     ),
    //     crncyWidget(1),
    //
    //     const Divider(
    //       color: hintYellowColHex,
    //       thickness: 1,
    //     ),
    //     crncyWidget(2),
    //
    //   ],
    // );

  return SingleChildScrollView(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Text('choose currency'.tr,
            style: GoogleFonts.almarai(
              textStyle:const TextStyle(
                  fontSize: 20
              ),
            ),),
        ),
        GridView.builder(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1,

              crossAxisCount: 3,
            ),
            itemCount: currencies.length,
            itemBuilder: (BuildContext ctx, index) {

              return (crncyWidget(index));
            }),
      ],
    ),
  );
  }

  currenciesDialog(ctx){
    showDialog(
      barrierDismissible: true,
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: blueColHex2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12.0),
          ),
        ),
        content: Builder(
          builder: (context) {

            var height = MediaQuery.of(context).size.height;
            var width = MediaQuery.of(context).size.width;

            return SizedBox(
              height: height /1.1,
              width: width,
              child: currenciesList(),
            );
          },
        ),
      ),
    );
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
