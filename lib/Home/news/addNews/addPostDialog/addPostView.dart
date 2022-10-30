import 'dart:io';

import 'package:belaaraby/Home/news/addNews/addPostDialog/addPostCtr.dart';
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



class AddPostView extends StatelessWidget {
  AddPostCtr gc = Get.find<AddPostCtr>();



  @override
  Widget build(BuildContext context) {
   double height = MediaQuery.of(context).size.height;
   double width = MediaQuery.of(context).size.height;
    return GetBuilder<AddPostCtr>(
        initState: (_) {
          print('## open AddPostView View');
        },
        dispose: (_) {
          print('## close AddPostView View');
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
                      child: Text('Add New Post'.tr,
                        style: GoogleFonts.almarai(
                          textStyle:const TextStyle(
                            fontSize: 20
                          ),
                        ),),
                    ),
                    // post_title
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        textInputAction: TextInputAction.done,
                        controller: gc.postTitleController,
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
                    //post_desc
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextFormField(
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(200),// max length

                        ],
                        textInputAction: TextInputAction.done,
                        controller: gc.postDescController,
                        onEditingComplete: () {
                          fieldUnfocusAll();
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          //icon: Icon(Icons.email),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          labelText: 'Description'.tr,
                          hintText: 'Enter description'.tr,
                        ),

                      ),
                    ),

                    //item_image
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0,top: 40.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //add image
                        ButtonTheme(
                        minWidth: width/9,
                          child: ElevatedButton(
                          onPressed: () async {
                            await gc.showChoiceDialog(context);
                          },
                          child: Text('Add Image'.tr),
                        ),
                      ),


                          //image_display
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 0.0),
                            child: SizedBox(

                                child:
                                Stack(
                                  children: [

                                    ///image box
                                    Container(

                                      padding: EdgeInsets.all(2),
                                      decoration: BoxDecoration(color: yellowColHex, borderRadius: BorderRadius.circular(9)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(9),
                                        child: SizedBox(
                                          width: width/8.5,
                                          height: width/13,
                                          //size: Size.fromRadius(30),
                                          child:gc.newPostImage !=null?
                                          Image.file(File(gc.newPostImage!.path),
                                            fit: BoxFit.cover,)
                                              :Image.asset('assets/noImage.jpg'),
                                        ),
                                      ),
                                    ),
                                    ///delete
                                    if(gc.newPostImage != null)  Positioned(
                                      top: -11,
                                      right: -11,
                                      child: IconButton(
                                          icon: const Icon(Ionicons.close_circle),
                                          color: Colors.grey,
                                          splashRadius: 1,
                                          onPressed: () {
                                           gc.deleteImage();
                                          }
                                      ),
                                    ),
                                  ],
                                ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    //buttons
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0,top: 15.0),
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
                               await gc.addPostToStore(context);
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
            ));
  }
}
