import 'package:belaaraby/addEditStore/components/timesPicker/timesCtr.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belaaraby/myPacks/myConstants.dart';


class PickTimesView extends StatelessWidget {

  final TimesPickerCtr getCtrl = Get.find<TimesPickerCtr>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// work hours
        SizedBox(
          width: double.infinity,

          child: Container(
            padding:const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child:  Text(
              textAlign: TextAlign.start,
              'Work Times'.tr,
              style:const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        GetBuilder<TimesPickerCtr>(
          builder: (ctr)=>SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  getCtrl.weekTimeRow(context, 'Mon'.tr, 'mo'),
                  getCtrl.weekTimeRow(context, 'Tue'.tr, 'tu'),
                  getCtrl.weekTimeRow(context, 'Wed'.tr, 'we'),
                  getCtrl.weekTimeRow(context, 'Thu'.tr, 'th'),
                  getCtrl.weekTimeRow(context, 'Fri'.tr, 'fr'),
                  getCtrl.weekTimeRow(context, 'Sat'.tr, 'sa'),
                  getCtrl.weekTimeRow(context, 'Sun'.tr, 'su'),
                ],
              ),
            ),
          ),
        ),),

      ],
    );
  }
}
