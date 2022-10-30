import 'dart:async';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/widgets.dart' as wig;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:belaaraby/myPacks/firebase/fireBase.dart';
import 'package:ionicons/ionicons.dart';

class ImagePickerCtr extends GetxController {
  //for add garage
  PickedFile? imageFile;
  List<PickedFile>? imageFileList = [];

  //for edit garage
  String stID = '';
  String logoUrl = '';
  List<String> imagesUrl = [];

  //if logo found 'false'
  bool logoDeleted = true;

  @override
  void onInit() {
    print('## onInit ImagePickerCtr');
    // if (logoUrl != '') {
    //   logoDeleted = false;
    //   update();
    // }

  }

  clearImageFile() {
    imageFile = null;
    update();
  }

  singleImage(List imageFileList, index) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Stack(
        children: [
          Card(
            color: blueColHex2,

            child: imageFileList.isNotEmpty
                ? Center(
                    child: wig.Image.file(
                      File(imageFileList[index].path),
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(),
          ),
          Positioned(
            top: -4,
            right: -4,
            child: IconButton(
              icon: const Icon(Ionicons.close_circle),
              color: Colors.grey,
              splashRadius: 1,
              onPressed: () {
                imageFileList.removeAt(index);
                update();
              },
            ),
          ),
        ],
      ),
    );
  }

  singleImageSaved(context, List imageFileList, index) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Stack(
        children: [
          Card(
            color: blueColHex2,

            child: imageFileList.isNotEmpty
                ? Center(
                    child: Image.network(imageFileList[index]),
                  )
                : Container(),
          ),
          Positioned(
            top: -4,
            right: -4,
            child: IconButton(
              icon: const Icon(Ionicons.close_circle),
              color: Colors.redAccent,
              splashRadius: 1,
              onPressed: () {
                proposeDeleteImgFromImages(context, imageFileList, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  proposeDeleteLogo(context) {
    MyVoids().shownoHeader(context).then((value) {
      if (value) {
        logoDeleted = true;

        ///delete from storage
        deleteFileByUrlFromStorage(logoUrl);

        ///delete from cloud
        emptyItemStringFromCloud('logo', stID, 'stores');
        update();
      }
    });
  }

  proposeDeleteImgFromImages(context, imageFileList, index) {
    MyVoids().shownoHeader(context).then((value) async {
      if (value) {
        ///delete from storage
        deleteFileByUrlFromStorage(imageFileList[index]);

        ///delete from cloud
        removeElementsFromList([imageFileList[index]], 'images', stID, 'stores');

        ///delete image from dialog
        imageFileList.remove(imageFileList[index]);
        update();
      }
    });
  }



  /// upload logo if added & images to fb
  Future<void> uploadAllImages(uniqueID) async {
    // add empty string if logo not chosen
     String url = await uploadOneImgToFb('stores/$uniqueID/logo', imageFile);
    if (logoDeleted) {
      storesColl.doc(uniqueID).update(
        {
          'logo': url,
          //'images':[],
        },
        // SetOptions(merge: true),
      );
    }
    ///images

    List<String>? urls = [];
    if (imageFileList!.isNotEmpty) {
      print('### found new images to add');
      for (int i = 0; i < imageFileList!.length; i++) {
        var url = await uploadOneImgToFb('stores/$uniqueID/images', imageFileList![i]);
        urls.add(url);
      }
    }
    //if there is saved images zid alehom sinn add new
    if (imagesUrl.isNotEmpty) {
      print('### found old images to merge with new if found');
      addElementsToList(urls, 'images', stID, 'stores');
    } else {
      storesColl.doc(uniqueID).update(
        {
          'images': urls,
        },
        //SetOptions(merge: true),
      );
    }
  }

  selectImage(ImageSource source, bool multi, BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
      source: source,
    );
    multi ? imageFileList!.add(pickedFile!) : imageFile = pickedFile!;

    //Navigator.pop(context);
    Get.back();
    update();
  }

  showChoiceDialog(BuildContext context, bool multi) {
    return showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            backgroundColor: blueColHex2,

            title:  Text(
              "Choose source".tr,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  const Divider(
                    height: 1,
                  ),
                  ListTile(
                    onTap: () {
                      selectImage(ImageSource.gallery, multi, ctx);
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
                    onTap: () {
                      selectImage(ImageSource.camera, multi, ctx);
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
