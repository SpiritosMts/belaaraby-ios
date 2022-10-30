import 'dart:io';
import 'dart:math' as math;

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:belaaraby/models/storeModel.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:belaaraby/auth/verifyEmail.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/widgets.dart' as wig;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

showLoadingDia(ctx) {
  showDialog(

      barrierDismissible: false,
      context: ctx,
      builder: (ctx) {
        double width = MediaQuery.of(ctx).size.width;
        double height = MediaQuery.of(ctx).size.height;
        return AlertDialog(
          backgroundColor: blueColHex2,


          insetPadding: EdgeInsets.symmetric(horizontal: width/3,vertical: height/2.6),
          //contentPadding:EdgeInsets.symmetric(horizontal: width/3) ,


          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12.0),
            ),
          ),
          content: Container(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  SizedBox(
                    child: CircularProgressIndicator(),

                  ),

                ],
              ),
            ),
          ),
        );
      });
}
String todayToString(){
  //final formattedStr = formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy, ' ', HH, ':' nn]);

  // DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  return dateFormat.format(DateTime.now());
}
/// upload one file to fb
Future<String> uploadOneImgToFb(String filePath, PickedFile? imageFile) async {
  if (imageFile != null) {
    String fileName = path.basename(imageFile.path);
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/$filePath/$fileName');

    File img = File(imageFile.path);

    final metadata = firebase_storage.SettableMetadata(contentType: 'image/jpeg', customMetadata: {
      // 'picked-file-path': 'picked000',
      // 'uploaded_by': 'A bad guy',
      // 'description': 'Some description...',
    });
    firebase_storage.UploadTask uploadTask = ref.putFile(img, metadata);

    String url = await (await uploadTask).ref.getDownloadURL();
    print('  ## uploaded image: $url');

    return url;
  } else {
    print('  ## cant upload null image');
    return '';
  }
}

fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
}

fieldUnfocusAll() {
  FocusManager.instance.primaryFocus?.unfocus();
}

List<Store> mapToListStore(Map<String, Store> map) {
  return map.entries.map((entry) => entry.value).toList();
}

List<MarkerData> mapToListMarkerData(Map<String, MarkerData> map) {
  return map.entries.map((entry) => entry.value).toList();
}

//general
List mapToList(Map map) {
  List list = [];
  map.forEach((k, v) => list.add(v));

  return list;
  // return   map.entries.map( (entry) => entry.value).toList();
  // return   map.entries.map( (entry) => {entry.key , entry.value}).toList(); // you can use key or value of each element of that map
}

listDynamicToString(List<dynamic> list) {
  return list.map((e) => e as String).toList();
}

mapToString(mapToConvert) {
  return mapToConvert.map((key, value) => MapEntry(key, value.toString()));
}

TimeOfDay stringToTimeOfDay(stringTime) {
  String formattedTodayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  DateTime openTime = DateTime.parse('$formattedTodayDate $stringTime:00');
  return TimeOfDay.fromDateTime(openTime);
}

class MyVoids {
  FirebaseAuth auth = FirebaseAuth.instance;
  final usersColl = FirebaseFirestore.instance.collection(usersCollName);

  Future<dynamic> showLoading(ctx) {
    return AwesomeDialog(
      dialogBackgroundColor: blueColHex2,

      dismissOnBackKeyPress: true,
      //change later to false
      autoDismiss: true,
      customHeader: Transform.scale(
        scale: .7,
        child: const LoadingIndicator(
          indicatorType: Indicator.ballClipRotate,
          colors: [yellowColHex],
          strokeWidth: 10,
        ),
      ),

      context: ctx,
      dismissOnTouchOutside: false,
      animType: AnimType.SCALE,
      headerAnimationLoop: false,
      dialogType: DialogType.NO_HEADER,

      title: 'Loading'.tr,
      desc: 'Please wait'.tr,
    ).show();
  }

  Future<dynamic> showFailed(ctx, {String? faiText}) {
    return AwesomeDialog(
        dialogBackgroundColor: blueColHex2,

        autoDismiss: true,
        context: ctx,
        dismissOnTouchOutside: false,
        animType: AnimType.SCALE,
        headerAnimationLoop: false,
        dialogType: DialogType.ERROR,
        //showCloseIcon: true,
        title: 'Failure'.tr,
        btnOkText: 'Ok'.tr,
        descTextStyle: GoogleFonts.almarai(
          height: 1.8,
          textStyle: const TextStyle(fontSize: 14),
        ),
        desc: faiText,
        btnOkOnPress: () {},
        btnOkColor: Colors.red,
        btnOkIcon: Icons.check_circle,
        onDissmissCallback: (type) {
          debugPrint('Dialog Dissmiss from callback $type');
        }).show();
    ;
  }

  Future<dynamic> showSuccess(ctx, {String? sucText, Function()? btnOkPress}) {
    return AwesomeDialog(
      dialogBackgroundColor: blueColHex2,

      autoDismiss: true,
      context: ctx,
      dismissOnBackKeyPress: false,
      headerAnimationLoop: false,
      dismissOnTouchOutside: false,
      animType: AnimType.LEFTSLIDE,
      dialogType: DialogType.SUCCES,
      //showCloseIcon: true,
      //title: 'Success'.tr,

      descTextStyle: GoogleFonts.almarai(
        height: 1.8,
        textStyle: const TextStyle(fontSize: 14),
      ),
      desc: sucText,
      btnOkText: 'Ok'.tr,

      btnOkOnPress: () {
        btnOkPress!();
      },
      // onDissmissCallback: (type) {
      //   debugPrint('## Dialog Dissmiss from callback $type');
      // },
      //btnOkIcon: Icons.check_circle,
    ).show();
  }

  Future<dynamic> shouldVerify(ctx) {
    return AwesomeDialog(
      dialogBackgroundColor: blueColHex2,

      autoDismiss: true,
      context: ctx,
      showCloseIcon: true,
      dismissOnTouchOutside: true,
      animType: AnimType.SCALE,
      headerAnimationLoop: false,
      dialogType: DialogType.INFO,
      title: 'Verification'.tr,
      desc: 'Your email is not verified\nVerify now?'.tr,
      btnOkText: 'Verify'.tr,
      btnOkColor: Colors.blue,
      btnOkIcon: Icons.send,
      btnOkOnPress: () {
        Get.to(() => VerifyScreen());
      },
      padding: EdgeInsets.symmetric(vertical: 20.0),
    ).show();
  }

  Future<bool> shownoHeader(ctx, {String? txt,String? btnOkText='delete',Color btnOkColor=Colors.red}) async {
    bool shouldDelete = false;

    await AwesomeDialog(
      dialogBackgroundColor: blueColHex2,

      autoDismiss: true,
      context: ctx,
      dismissOnTouchOutside: true,
      animType: AnimType.SCALE,
      headerAnimationLoop: false,
      dialogType: DialogType.NO_HEADER,
      //showCloseIcon: true,
      title: 'Verification'.tr,
      desc: txt ?? 'Are you sure you want to delete this image'.tr,
      btnOkOnPress: () {
        shouldDelete = true;
      },

      isDense: true,
      btnCancelText: 'cancel'.tr,
      btnCancelIcon: Icons.cancel,
      btnCancelColor: Colors.grey,
      btnCancelOnPress: () {
        shouldDelete = false;
      },

      btnOkText: btnOkText!.tr,
      buttonsTextStyle: TextStyle(fontSize: 14),
      btnOkColor: btnOkColor,
      btnOkIcon: Icons.delete,
      // onDissmissCallback: (type) {
      //   debugPrint('Dialog Dissmiss from callback $type');
      // }
    ).show();
    print('### $shouldDelete ');
    return shouldDelete;
  }

  Future<void> openGoogleMapApp(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = math.cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * math.asin(math.sqrt(a));
  }

  showTos(txt, {color}) async {
    Fluttertoast.showToast(
        msg: txt,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: color ?? Colors.black38,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
