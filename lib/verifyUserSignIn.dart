



import 'dart:async';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:belaaraby/Home/homeView.dart';
import 'package:belaaraby/main.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:belaaraby/auth/login_screen.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'models/brUserModel.dart';
import 'myPacks/myVoids.dart';

class VerifySigningIn extends StatefulWidget {
  const VerifySigningIn({Key? key}) : super(key: key);

  @override
  State<VerifySigningIn> createState() => _VerifySigningInState();
}

class _VerifySigningInState extends State<VerifySigningIn> {

  // StreamSubscription<User?>? user;
  //BrUser cUser = BrUser();

  bool isGuest = sharedPrefs!.getBool('isGuest') == null ? false : sharedPrefs!.getBool('isGuest')!;

  late bool canShowCnxFailed;
  late Timer timer;

  @override
  void initState() {
    super.initState();
     canShowCnxFailed =true ;

    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      checkCnx();
    });
  }



  checkCnx() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('## connected');
        //MyVoids().showTos('Connecté',color: Colors.green[500]);
        timer.cancel();
        if(isGuest){
          Get.offAll(()=> StoresMapView());

        }else{
          authCtr.fetchUser();

        }
      }
    } on SocketException catch (_) {
      print('## not connected');
      if(canShowCnxFailed){
        AwesomeDialog(
          dialogBackgroundColor: blueColHex2,



          autoDismiss: true,
          dismissOnTouchOutside: true,
          animType: AnimType.SCALE,
          headerAnimationLoop: false,
          dialogType: DialogType.INFO,
          btnOkColor: Colors.blueAccent,
           // btnOkColor: yellowColHex

            //showCloseIcon: true,
          padding: EdgeInsets.symmetric(vertical: 15.0),

            title: 'Failed to Connect'.tr,
          desc: 'please verify network'.tr,

          btnOkOnPress: () {

          },
          onDissmissCallback: (type) {
            print('Dialog Dissmiss from callback $type');
          },
          //btnOkIcon: Icons.check_circle,
          context: context,

        ).show();

        if(this.mounted){
          setState((){
            canShowCnxFailed=false;
          });
        }

      }
    }
  }



  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children:  [
              SizedBox(
                height: _height/15,
              ),
              /// belaaraby Image
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Image.asset(
                  'assets/V.0001.png',
                  fit: BoxFit.cover,
                  width: 250,
                  height: 200,
                ),
              ),
              // text
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(),
                  child: Text(
                    'دليلك للمنتجات والخدمات\nفي أوروبا',
                      textAlign: TextAlign.center,

                      style:TextStyle(
                          fontSize: 21.sp,
                          color: Colors.white,
                        height: 1.5

                      )

                  ),
                ),
              ),
              // check your cnx
              !canShowCnxFailed? Column(
                children: [
                   Text('please verify network'.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: yellowColHex.withOpacity(0.7),
                  ),),
                  SizedBox(height: _height*.1,),

                ],
              ):Container(),

             ///loading
             Padding(
               padding: const EdgeInsets.only(top: 20.0),
               child: Center(
                 child: SizedBox(
                   width: _width * .3 ,
                   height: _width  * .3 ,
                   child:const LoadingIndicator(
                   indicatorType: Indicator.circleStrokeSpin,
                   colors: [yellowColHex],
                   strokeWidth: 3,
                   ),
                 ),
               ),
             ),

            ],
           ),
      ///network img
      // FutureBuilder<QuerySnapshot>(
      //   future: adsColl.get(),
      //   builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
      //     if (snapshot.hasData) {
      //
      //       var ad = snapshot.data!.docs.first;
      //       String adUrl = ad.get('adUrl');
      //
      //       return  adUrl!=''? Positioned(
      //         bottom: -4,
      //         child: Image.network(adUrl,
      //           width: _width,
      //           fit: BoxFit.cover,
      //         ),
      //       ):Container();
      //     } else {
      //       return  Container();
      //     }
      //   },
      // ),
          ///local img
      Positioned(
                bottom: -4,
                child: Image.asset('assets/adImage.png',
                  width: _width,
                  fit: BoxFit.cover,
                ),
              )

        ],
      ),
    );
  }
}
