import 'package:belaaraby/addEditStore/components/productsPicker/addCateg/categ/categCtr.dart';
import 'package:belaaraby/addEditStore/components/productsPicker/addItem/item/itemView.dart';
import 'package:belaaraby/addEditStore/components/productsPicker/productsCtr.dart';
import 'package:belaaraby/models/itemModel.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:belaaraby/myPacks/storeVoids.dart';
import 'package:belaaraby/tutoCtr.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CategView extends StatefulWidget {
  @override
  State<CategView> createState() => _CategViewState();
}

class _CategViewState extends State<CategView> {
  final ProductsCtr pc = Get.find<ProductsCtr>();

  final TutoController ttr = Get.find<TutoController>();

  final CategCtr gc = Get.find<CategCtr>();

  final Map<String, dynamic> categs = Get.find<ProductsCtr>().categories;

  @override
  void initState() {
    super.initState();
    ttr.showItemsTuto(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pc.selectedCategory),
        bottom: appBarUnderline(),
        centerTitle: true,

      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ///edit categ 2 btns
              Padding(
                padding: const EdgeInsets.only(bottom: 15, top: 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: pc.selectedCategory != '' ? yellowColHex : Colors.grey,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                      ),
                      onPressed: () {
                        gc.updateCategDialog(context);
                      },
                      child: Text(
                        "edit category".tr,
                        style: TextStyle(color: Theme.of(context).backgroundColor),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: pc.selectedCategory != '' ? yellowColHex : Colors.grey,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                      ),
                      onPressed: () {
                        gc.removeCategDialog(context);
                      },
                      child: Text(
                        "remove category".tr,
                        style: TextStyle(color: Theme.of(context).backgroundColor),
                      ),
                    ),
                  ],
                ),
              ),
              ///items list
              StreamBuilder<QuerySnapshot>(
                stream: storesColl.where('id', isEqualTo: gc.st.id!).snapshots(),
                builder: (
                    BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot,
                    ) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    print('## snapshot.connectionState == ConnectionState.waiting');

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      print('## snapshot.hasError');
                      return  Container();
                    }
                    else if (snapshot.hasData) {
                      print('## snapshot.hasData');

                      var store = snapshot.data!.docs.first;
                      Map<String, dynamic> categs = store.get('categories');
                      return (categs.containsKey(pc.selectedCategory) && categs[pc.selectedCategory].isNotEmpty)
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

                            return itemGridCard(item, pc);
                          })
                          : Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Text('category has no items'.tr,
                            style: GoogleFonts.almarai(
                                fontSize: 20.sp
                            ),
                          ),
                        ),
                      );
                    }
                    else {
                      print('## else first');

                      return  Container();
                    }
                  }
                  else {
                    print('## else all');
                    return Container();

                  }

                },
              ),


            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

      floatingActionButton:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
        child: Row(
         // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            Container(
              key: ttr.addItemKey,

              height: 40.0,
              width: 130.0,
              child: FittedBox(
                child: FloatingActionButton.extended(

                  onPressed: () {
                    pc.addItemDialog(context);
                  },
                  heroTag: 'addItem',
                  backgroundColor: pc.selectedCategory != '' ? yellowColHex : Colors.grey,
                  label: Row(
                    children: [
                      Icon(Icons.add),
                      SizedBox(width: 5),
                      Text("Add Item".tr,
                        style: TextStyle(color: Theme.of(context).backgroundColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),

    );
  }
}
