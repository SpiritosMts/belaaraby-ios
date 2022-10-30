import 'package:belaaraby/addEditStore/components/textFields/fieldsCtr.dart';
import 'package:belaaraby/addEditStore/editStoreInfo/editStoreInfoCtr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class TextFieldsView extends StatelessWidget {

  final TextFieldsCtr getCtrl = Get.find<TextFieldsCtr>();

  @override
  Widget build(BuildContext context) {

    return   GetBuilder<TextFieldsCtr>(
      //init:TextFieldsCtr(),
        builder:(ctr)=> Column(
          children: [
            /// name,ciret...input

            SizedBox(
              width: double.infinity,

              child: Container(
                padding:const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child:  Text(
                  textAlign: TextAlign.start,
                  'general info'.tr,
                  style:const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Form(
                key: getCtrl.formKeyCommon,
                child: Column(
                  children: [
                    // name_input
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                      child: TextFormField(
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(40),// max length

                        ],
                        //keyboardType: TextInputType.text,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'enter store name'.tr;
                          }
                          return null;
                        },

                        controller: getCtrl.nameTextController,
                        style:const TextStyle(
                          fontSize: 18,
                        ),
                        decoration:  InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          border: UnderlineInputBorder(),
                          labelText: 'store name'.tr,
                        ),
                      ),
                    ),
                    // N°tax_input
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                      child: TextFormField(
                        //readOnly: Get.find<EditStoreInfoCtr>()==null?   false:true,
                        readOnly: Get.isPrepared<EditStoreInfoCtr>()?   false:true,


                        //inputFormatters: <TextInputFormatter>[
                          //FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        //],
                        keyboardType: TextInputType.text,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'enter tax number'.tr;
                          }
                          return null;
                        },

                        controller: getCtrl.taxTextController,
                        style:const TextStyle(
                          fontSize: 18,
                        ),
                        decoration:  InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          border: UnderlineInputBorder(),
                          labelText: 'tax number'.tr,
                        ),
                      ),
                    ),
                    // N°telephone_input
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                      child: TextFormField(
                        inputFormatters: <TextInputFormatter>[
                          //LengthLimitingTextInputFormatter(10),// max length
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        keyboardType: TextInputType.number,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'enter phone number'.tr;
                          }
                          return null;
                        },
                        controller: getCtrl.phoneTextController,
                        style:const TextStyle(
                          fontSize: 18,
                        ),
                        decoration:  InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          border: UnderlineInputBorder(),
                          labelText: 'phone number'.tr,
                        ),
                      ),
                    ),
                    // address_input
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                      child: TextFormField(
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(40),
                        ],
                        keyboardType: TextInputType.text,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'enter address local'.tr;
                          }
                          return null;
                        },
                        controller: getCtrl.addressTextController,
                        style:const TextStyle(
                          fontSize: 18,
                        ),
                        decoration:  InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          border: UnderlineInputBorder(),
                          labelText: 'address local'.tr,
                        ),
                      ),
                    ),
                    // jobDesc_input
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                      child: TextFormField(
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(200),
                        ],
                        keyboardType: TextInputType.text,

                        controller: getCtrl.jobDescTextController,
                        style:const TextStyle(
                          fontSize: 18,
                        ),
                        decoration:  InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          border: UnderlineInputBorder(),
                          labelText: 'description'.tr,
                        ),
                      ),
                    ),
                    // website_input
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                      child: TextFormField(
                        inputFormatters: <TextInputFormatter>[
                          //LengthLimitingTextInputFormatter(200),
                        ],
                        keyboardType: TextInputType.url,

                        controller: getCtrl.websiteTextController,
                        style:const TextStyle(
                          fontSize: 18,
                        ),
                        decoration:  InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          border: UnderlineInputBorder(),
                          labelText: 'website'.tr,
                        ),
                      ),
                    ),
                  ],
                )
            ),
          ],
        ));

  }
}
