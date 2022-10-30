import 'dart:io';

import 'package:belaaraby/addEditStore/components/productsPicker/productsCtr.dart';
import 'package:belaaraby/models/itemModel.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:belaaraby/myPacks/storeVoids.dart';
import 'package:belaaraby/tutoCtr.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'itemCtr.dart';

class ItemView extends StatelessWidget {
  Item item = Get.find<ProductsCtr>().selectedItem;
  final TutoController ttr = Get.find<TutoController>();

  ItemCtr gc = Get.find<ItemCtr>();
  ProductsCtr pc = Get.find<ProductsCtr>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<ProductsCtr>(
            initState: (_) {
          print('## open Item View');
          ttr.showPromoteItemTuto(context);
        },
            builder: (ctr) {
          return Stack(
            children: [
              ///item_info
              itemInfo(item),
              ///buttons
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 25.0, top: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      //delete
                      SizedBox(
                        width: width / 8,
                        child: TextButton(
                          style: blueStyle,
                          onPressed: () {
                            ///delete item
                            gc.removeItemFromStore(pc.st.id!);
                          },
                          child: Text("delete".tr,
                              style: GoogleFonts.almarai(
                                color: Theme.of(context).primaryColor,
                                textStyle: const TextStyle(fontSize: 15),
                              )),
                        ),
                      ),
                      //promo
                      SizedBox(
                        key: ttr.promoteItemKey,
                        width: width / 6,
                        child: TextButton(
                          style: ylwStyle,
                          onPressed: () {
                            ///promo
                            if (item.promoted == 'true') {
                              gc.stopPromoteItem(pc.st.id!);
                            } else {
                              gc.promoDialog(context);
                            }
                          },
                          child: Text(item.promoted == 'true' ? "Stop Promo".tr : "Promo".tr,
                              style: GoogleFonts.almarai(
                                color: Theme.of(context).backgroundColor,
                                textStyle: const TextStyle(fontSize: 15),
                              )),
                        ),
                      ),
                      //modify
                      SizedBox(
                        width: width / 8,
                        child: TextButton(
                          style: item.promoted == 'true' ? greyStyle : ylwStyle,
                          onPressed: () {
                            if (item.promoted == 'true') {
                              MyVoids().showTos('you need to stop item promotion to modify it'.tr);
                            } else {
                              ///modify
                              gc.updateItemDialog(context);
                            }
                          },
                          child: Text("edit".tr,
                              style: GoogleFonts.almarai(
                                color: Theme.of(context).backgroundColor,
                                textStyle: const TextStyle(fontSize: 15),
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
