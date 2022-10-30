import 'dart:io';

import 'package:belaaraby/Home/selectedStore/selectedStCtr.dart';
import 'package:belaaraby/addEditStore/components/productsPicker/productsCtr.dart';
import 'package:belaaraby/models/itemModel.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:belaaraby/myPacks/storeVoids.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../addEditStore/components/productsPicker/addItem/item/itemCtr.dart';

class ItemViewRo extends StatelessWidget {
  Item item = Get.find<SelectedStCtr>().selectedItem;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<SelectedStCtr>(initState: (_) {
          print('## open Item View');
        }, builder: (ctr) {


          return Stack(
            children: [
              itemInfo(item),

            ],
          );
        }),
      ),
    );
  }
}
