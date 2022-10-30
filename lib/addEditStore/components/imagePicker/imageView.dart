import 'dart:io';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ionicons/ionicons.dart';
import 'imageCtr.dart';

class PickImagesView extends StatelessWidget {
  final ImagePickerCtr getCtrl = Get.find<ImagePickerCtr>();

  // @override
  // void dispose() {
  //   Get.delete<ImagePickerCtr>();
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImagePickerCtr>(
        builder: (ctr) => Column(
              children: [
                /// Logo
                // Row(
                //   children: [
                //     /// Logo
                //
                //     Padding(
                //       padding: const EdgeInsets.only(bottom: 8.0),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Container(
                //             padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                //             child: Text(
                //               'choose logo'.tr,
                //               style: const TextStyle(
                //                 fontSize: 25,
                //                 fontWeight: FontWeight.bold,
                //               ),
                //             ),
                //           ),
                //
                //           /// parcourir btn
                //           // SizedBox(
                //           //   width: 40,
                //           //   height: 40,
                //           //   child: FloatingActionButton.extended(
                //           //     heroTag: 'addLogo',
                //           //     onPressed: () {
                //           //       fieldUnfocusAll();
                //           //       if (getCtrl.logoDeleted) {
                //           //         getCtrl.showChoiceDialog(context, false);
                //           //       } else {
                //           //         getCtrl.proposeDeleteLogo(context);
                //           //       }
                //           //     },
                //           //     label: const Icon(Icons.image),
                //           //   ),
                //           // ),
                //         ],
                //       ),
                //     ),
                //     ///logo image
                //     Padding(
                //       padding: const EdgeInsets.symmetric(horizontal: 20.0),
                //       child: SizedBox(
                //           width: 100,
                //           height: 100,
                //           child: getCtrl.logoDeleted
                //               ? (getCtrl.imageFile != null)
                //               ?
                //
                //           /// new logo if added
                //           Stack(
                //             children: [
                //               CircleAvatar(
                //                 radius: 100.0,
                //                 backgroundColor: Colors.white,
                //                 foregroundImage: FileImage(File(getCtrl.imageFile!.path)),
                //               ),
                //               Positioned(
                //                 top: -6,
                //                 right: -6,
                //                 child: IconButton(
                //                   icon: Icon(Ionicons.close_circle),
                //                   color: Colors.grey,
                //                   splashRadius: 1,
                //                   onPressed: () {
                //                     getCtrl.clearImageFile();
                //                   },
                //                 ),
                //               ),
                //             ],
                //           )
                //               : GestureDetector(
                //             onTap: () {
                //               fieldUnfocusAll();
                //               if (getCtrl.logoDeleted) {
                //                 getCtrl.showChoiceDialog(context, false);
                //               } else {
                //                 getCtrl.proposeDeleteLogo(context);
                //               }
                //             },
                //             child: const CircleAvatar(
                //               radius: 100.0,
                //               backgroundColor: Colors.white,
                //               foregroundImage: AssetImage('assets/noImage.jpg'),
                //             ),
                //           )
                //
                //           /// old logo
                //               : Stack(
                //             children: [
                //               CircleAvatar(
                //                 radius: 100.0,
                //                 backgroundColor: Colors.white,
                //                 foregroundImage: NetworkImage(getCtrl.logoUrl),
                //               ),
                //               Positioned(
                //                 top: -6,
                //                 right: -6,
                //                 child: IconButton(
                //                   icon: Icon(Ionicons.close_circle),
                //                   color: Colors.redAccent,
                //                   splashRadius: 1,
                //                   onPressed: () {
                //                     getCtrl.proposeDeleteLogo(context);
                //                   },
                //                 ),
                //               ),
                //             ],
                //           )),
                //     ),
                //   ],
                // ),


                //SizedBox(height: 15.0),
                /// parcourir btn
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ///images text
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child:  Text(
                        'Images'.tr,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    /// parcourir btn
                    SizedBox(
                      width: 50,
                      height: 30,
                      child: TextButton(
                        style: ylwStyle,
                        onPressed: () async {
                          getCtrl.showChoiceDialog(context, true);
                        },
                        child: Text(
                          "Add".tr,
                          style: TextStyle(
                              color: Theme.of(context).backgroundColor,
                          fontSize: 10,
                            fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Divider(
                      thickness: 1,
                  color: Colors.grey,
                  ),
                ),

                ///images list
                Padding(
                  padding: const EdgeInsets.only(right: 20.0, left: 20.0, bottom: 0.0, top: 10.0),
                  child: SizedBox(
                    height: 100,
                    child: Container(
                      child: (getCtrl.imageFileList!.isNotEmpty || getCtrl.imagesUrl.isNotEmpty)
                          ? ListView.builder(
                              physics: const ClampingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: getCtrl.imageFileList!.length + getCtrl.imagesUrl.length,

                              itemBuilder: ( context, index) {
                                if (index < getCtrl.imagesUrl.length) {
                                  return getCtrl.singleImageSaved(context,getCtrl.imagesUrl, index);
                                } else {
                                  return getCtrl.singleImage(getCtrl.imageFileList!, index - (getCtrl.imagesUrl.length));
                                }
                              })
                          : Center(
                              child: Text('no chosen images'.tr),
                            ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Divider(thickness: 1,
                    color: Colors.grey,
                  ),
                ),
              ],
            ));
  }
}
