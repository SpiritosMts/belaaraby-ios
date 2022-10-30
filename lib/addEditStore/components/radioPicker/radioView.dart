import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ionicons/ionicons.dart';
import 'radioCtr.dart';



class PickRadiosView extends StatelessWidget {
  final RadioPickerCtr getCtrl = Get.find<RadioPickerCtr>();



  @override
  Widget build(BuildContext context) {
   double height = MediaQuery.of(context).size.height;
    return GetBuilder<RadioPickerCtr>(
        builder: (ctr) => Column(
          children: [
            SizedBox(
              width: double.infinity,

              child: Container(
                padding:const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child:  Text(
                  textAlign: TextAlign.start,
                  'job type'.tr,
                  style:const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height/3,
              child: ListView(

               // shrinkWrap :true,
                children: [


                  Column(
              //mainAxisSize:MainAxisSize.min,
              children:
                    getCtrl.radioList.map((data) => RadioListTile(
                      title: Text(data.name),
                      groupValue: getCtrl.id,
                      value: data.index,
                      onChanged: (val) {

                        getCtrl.onChangeRadio(data, val);
                      },
                    )).toList(),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
