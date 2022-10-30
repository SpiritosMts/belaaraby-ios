import 'package:belaaraby/Home/selectedStore/selectedStCtr.dart';
import 'package:belaaraby/addEditStore/components/productsPicker/addCateg/categ/categCtr.dart';
import 'package:belaaraby/addEditStore/components/productsPicker/addItem/item/itemView.dart';
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

class CategViewRo extends StatelessWidget {
  final SelectedStCtr pc = Get.find<SelectedStCtr>();
  final Map<String, dynamic> categs = Get.find<SelectedStCtr>().st.categories!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pc.selectedCategory!),
        bottom: appBarUnderline(),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ///items list
              GetBuilder<CategCtr>(builder: (ctr) {
                return categs[pc.selectedCategory]!.isNotEmpty
                    ? GridView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 7),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 0.9,

                          crossAxisCount: 2,
                ),
                        itemCount: categs[pc.selectedCategory]!.length,
                        itemBuilder: (BuildContext ctx, index) {
                          Map<String, dynamic> itemsOfOneCateg = categs[pc.selectedCategory]!;
                          String itemName = itemsOfOneCateg.keys.elementAt(index);
                          Map<String, dynamic> itemMap = itemsOfOneCateg[itemName]!;
                          Item item = itemFromMap(itemMap);

                          return itemGridCard(item, pc,ro: true);
                        })
                    : Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: Center(
                          child: Text('category has no items'.tr,
                          style: GoogleFonts.almarai(
                            fontSize: 20.sp
                          ),
                          ),
                        ),
                      );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
