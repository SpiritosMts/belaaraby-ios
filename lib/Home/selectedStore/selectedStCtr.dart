import 'package:belaaraby/Home/admin/adminHome/adminHomeCtr.dart';
import 'package:belaaraby/models/itemModel.dart';
import 'package:belaaraby/models/storeModel.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belaaraby/Home/homeCtr.dart';

import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/services.dart';

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SelectedStCtr extends GetxController {
  Store st = Store();

  String? selectedCategory;
  bool localShowLogo = true;

  bool isAdmin =Get.arguments['isAdmin'];

  @override
  void onInit() {
    super.onInit();

    if(isAdmin){
       st = Get.find<AdminHomeCtr>().selectedSt;
    }else{
      st = Get.find<HomeCtr>().selectedSt;
    }
    print('## init SelectedStCtr');
    print('## open selected store: ${st.name}');

    images = st.images!;
    localShowLogo =  st.showLogo!;

  }
  Item selectedItem = Item();



  late TabController tabController;

  final List<String> titleList = [
    "overview".tr,
    "products".tr,
    "comments".tr,
  ];

  String currentTitle = 'overview'.tr;








  TextEditingController ratingController = TextEditingController(); //name
  double stars = defaultStarsNum;

  double dialogWidthScale = 1;
  double dialogheightScale = .8;
  double abrSize = 13;

  List<String> images = [];


  Map openHoursData = {};




  switchLogo(val){
    localShowLogo=val;
    update();

    storesColl.doc(st.id).update({
      'showLogo':localShowLogo
    }).then((value) async {
      //MyVoids().showTos('Store declined'.tr);
    }).catchError((error) => print("Failed to switch logo: $error"));
  }
  selectItem(item) {
    selectedItem = item;
  }
  void changeTitle() {
    currentTitle = titleList[tabController.index];
    update();
  }






  ///Rating send

  Future<dynamic> showRating(ctx, id) {
    return AwesomeDialog(
      dialogBackgroundColor: blueColHex2,

      isDense: false,
      dismissOnBackKeyPress: true,
      context: ctx,
      showCloseIcon: true,
      dismissOnTouchOutside: true,
      animType: AnimType.SCALE,
      customHeader: Image.asset(
        'assets/star.png',
        scale: 6.0,
        color:Colors.amber[700],
      ),
      btnOkText: 'Send'.tr,
      //rate btn
      btnOkOnPress: () {
        sendRating(ctx, id);
      },
      btnOkIcon: Icons.send,
      btnOkColor: Colors.amber[700],


      body: Center(
        child: Column(
          children: [
             Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Rate'.tr,
                style: TextStyle(fontSize: 30),


              ),
            ),
            const SizedBox(
              height: 5.0,
            ),
             Text('Share your opinion'.tr),
            const SizedBox(
              height: 18.0,
            ),
            //stars
            RatingBar.builder(
              unratedColor: Colors.white24,
              initialRating: stars,
              minRating: 1,
              direction: Axis.horizontal,
              //allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                stars = rating;
              },
            ),
            //comment
            Padding(
              padding: const EdgeInsets.only(
                top: 30.0,
                bottom: 15.0,
                right: 20.0,
                left: 20.0,
              ),
              child: TextFormField(
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(200),
                ],
                controller: ratingController,
                style: const TextStyle(
                  fontSize: 18,
                ),
                decoration:  InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  border: UnderlineInputBorder(),
                  labelText: 'comment'.tr,
                ),
              ),
            )
          ],
        ),
      ),
    ).show();
  }

  void sendRating(ctx, id) {
    storesColl.doc(id).get().then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        //get existing raters of garage
        Map<String, dynamic> raters = documentSnapshot.get('raters');
        //add or update rating of curr user
        raters[authCtr.cUser.name!] = {
          'stars': stars.toString(),
          'comment': ratingController.text,
        };

        int raterCount = raters.length;
        double storeStars = 0.0;
        double starsSum = 0.0;
        raters.forEach((user, rateNDcmnt) {
          starsSum += double.parse(rateNDcmnt['stars']);
        });
        if (raterCount != 0) {
          storeStars = starsSum / raterCount;
        }
        //add raters again map to cloud
        await storesColl.doc(id).update({
          'raters': raters,
          'stars': storeStars.toStringAsFixed(1),
          'raterCount': '$raterCount',
        }).then((value) async {
          //success to add rating
          await MyVoids().showSuccess(ctx,
              sucText: 'your review has been successfully sent'.tr,
          btnOkPress: ()=>{}
          );
          //restore rating stars and comment
          ratingController.clear();
          stars = defaultStarsNum;
        }).catchError((error) async {
          //failed to add rating
          await MyVoids().showFailed(ctx, faiText: 'failed to send review'.tr);
          print('## failed to add rating');
        });
      }
    });
  }

  onPressRate(context)async{
    if (authCtr.cUser.name! != 'no-name') {
      //owner cannot rate other garages
      if (!ownerCanRateOthers) {
        if (!authCtr.cUser.hasStores!) {
          await showRating(context, st.id);
        } else {
          MyVoids().showTos('you can\'t rate stores while you have at least one'.tr);
          // you cant rate garages while you have at least one
        }
      }
      //owner can rate other garages
      else {
        await showRating(context, st.id);
      }
    } else {
      MyVoids().showTos('you cannot rate stores until you are registered'.tr);
      // you cant rate garages while ur anony
    }
  }

  ///



}
