import 'dart:async';
import 'package:belaaraby/addEditStore/components/imagePicker/imageCtr.dart';
import 'package:belaaraby/addEditStore/components/mapNoAddrPicker/mapCtr.dart';
import 'package:belaaraby/addEditStore/components/productsPicker/productsCtr.dart';
import 'package:belaaraby/addEditStore/components/radioPicker/radioCtr.dart';
import 'package:belaaraby/addEditStore/components/textFields/fieldsCtr.dart';
import 'package:belaaraby/addEditStore/components/timesPicker/timesCtr.dart';
import 'package:belaaraby/models/brUserModel.dart';
import 'package:belaaraby/models/itemModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:belaaraby/myPacks/firebase/fireBase.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myVoids.dart';


class AddStoreCtr extends GetxController {


  final TextFieldsCtr pFields = Get.find<TextFieldsCtr>();
  final MapPickerCtr pLocation = Get.find<MapPickerCtr>();
  final ImagePickerCtr pImages = Get.find<ImagePickerCtr>();
  final TimesPickerCtr pTimes = Get.find<TimesPickerCtr>();
  final RadioPickerCtr pRadio = Get.find<RadioPickerCtr>();


  BrUser cUser = authCtr.cUser;

  @override
  void onInit() {
    super.onInit();
    print('## onInit AddStoreCtr');

  }



  goHome(){
    //Get.offAll(()=>GaragesMapView());
    Get.back();
    Get.back();
  }



  Future<void> addStore(ctx) async{


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

    //products
    //Map? categories = pProducts.categoriesToMap() as Map?;



    //user
    String? ownerID = cUser.id;
    String? ownerName = cUser.name;
    String? ownerEmail = cUser.email;

    //radio
    String jobType = pRadio.radioItem;


    // print('### common: $name _ $ciret _ $phone');
    // print('### coutry: $state _ $city');
    // print('### location<coords>: $lati _ $lngi | location<info>: $street//$postalCode//$addressDesc');
    // print('### hours<openDays>: $openDays | hours<openHours>: $openHoursString');


    if (pFields.formKeyCommon.currentState!.validate() || shouldNotVerifyInputs){
      if(lati*lngi != 0.0 || shouldNotVerifyInputs){
          MyVoids().showLoading(ctx);
          print('## Verified store formular inputs');

          storesColl.add({
            //
            'ownerID': ownerID,
            'ownerName': ownerName,
            'ownerEmail': ownerEmail,
            //
            'name': name,
            'tax': tax,
            'website': website,
            'phone': phone,
            'address': address,
            'jobDesc': jobDesc,
            'coords': GeoPoint(lati, lngi),
            //
            'jobType':jobType,
            //
            'categories':{},
            'categImages':{},
            'promo':{},
            //
            'accepted': 'notYet',
            'showLogo': true,
            //
            'openDays': openDays,
            'openHours': openHoursString ,
            //
            'raters': {},
            'stars': '0.0',
            'raterCount': '0',

            //'images': not-in-here
            //'logo': not-in-here
            //'id': not-in-here

            // add open hours
          }).then((value)async{
            print("### STORE ADDED");
            //add id
            String storeID = value.id;
            //add images & logo;
            await pImages.uploadAllImages(storeID);
            //set id
            storesColl.doc(storeID).update({
              'id': storeID,
            });
            //add id to user stores
            await addElementsToList([storeID],'stores',cUser.id!,usersCollName);
            //hide loading dialog
            Get.back();


            await MyVoids().showSuccess(
              ctx,
              sucText: 'your store will be verified\nas soon as possible'.tr,
              btnOkPress: () {
                print('# btn_Ok_Pressed');
                 //Get.back();
                goHome();

              },
            );
          }).catchError((error) async {
            // garage can't added
            print("## Failed to add store: $error");
            await MyVoids().showFailed(ctx,faiText:'Failed to add store'.tr);
          });

      } else{
        MyVoids().showTos('you need to pick a location'.tr);
        // no chosen marker...
      }
    } else{
      MyVoids().showTos('you must fill in the fields'.tr);
      // please complete filling fields...
    }
  }


  printProps(){
    print('### name: ${pFields.nameTextController.text} '
        '_phone: ${pFields.phoneTextController.text} '
        '_jobDesc: ${pFields.jobDescTextController.text} '
        '_address: ${pFields.addressTextController.text} '
        '_tax: ${pFields.taxTextController.text}'
        '_website: ${pFields.websiteTextController.text}');
    print('### location<coords>: ${pLocation.lati} _ ${pLocation.lngi} ');
    print('### hours<openDays>: ${pTimes.openDays} | hours<openHours>: ${pTimes.openHours}');

  }


}
