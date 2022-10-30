import 'dart:io';

import 'package:belaaraby/Home/news/addNews/addVideoDialog/addVideoCtr.dart';
import 'package:belaaraby/addEditStore/components/productsPicker/addItem/addItemDialog/addItemCtr.dart';
import 'package:belaaraby/addEditStore/components/productsPicker/productsCtr.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';



class AddVideoView extends StatelessWidget {
  AddVideoCtr gc = Get.find<AddVideoCtr>();

  @override
  Widget build(BuildContext context) {
   double height = MediaQuery.of(context).size.height;
   double width = MediaQuery.of(context).size.height;
    return GetBuilder<AddVideoCtr>(
        initState: (_) {
          print('## open AddVideoView View');
        },
        dispose: (_) {
          print('## close AddVideoView View');
        },
        builder: (ctr) =>
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: gc.formkeyItem,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end ,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text('Add video'.tr,
                        style: GoogleFonts.almarai(
                          textStyle:const TextStyle(
                            fontSize: 20
                          ),
                        ),),
                    ),
                    // video_title
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        textInputAction: TextInputAction.done,
                        controller: gc.videoTitleController,
                        onEditingComplete: () {
                          fieldUnfocusAll();
                        },

                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          //icon: Icon(Icons.email),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          labelText: 'Title'.tr,
                          hintText: 'Enter title'.tr,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "title can\'t be empty".tr;
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),

                    //video_url
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(200),// max length

                        ],
                        textInputAction: TextInputAction.done,
                        controller: gc.videoUrlController,
                        onEditingComplete: () {
                          fieldUnfocusAll();
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          //icon: Icon(Icons.email),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          labelText: 'Url'.tr,
                          hintText: 'Enter url'.tr,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "url can\'t be empty".tr;
                          } else {
                            return null;
                          }
                        },

                      ),
                    ),

                    //buttons
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0,top: 25.0),
                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [


                          //cancel
                          TextButton(
                            style: blueStyle,
                            onPressed: () {
                             Get.back();
                            },
                            child: Text("Cancel".tr,
                              style: TextStyle(
                                  color:Theme.of(context).colorScheme.secondary),
                            ),
                          ),
                          //add
                          TextButton(
                            style: ylwStyle,
                            onPressed: () async{
                               await gc.addVideoToStore(context);
                            },
                            child: Text("Add".tr,
                              style: TextStyle(
                                  color:Theme.of(context).backgroundColor),
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            )
    );
  }
}
