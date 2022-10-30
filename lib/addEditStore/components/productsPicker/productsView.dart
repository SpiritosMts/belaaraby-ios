import 'dart:io';

import 'package:belaaraby/addEditStore/components/productsPicker/addCateg/addCategDialog/addCategView.dart';
import 'package:belaaraby/addEditStore/components/productsPicker/addCateg/categ/categView.dart';
import 'package:belaaraby/addEditStore/components/productsPicker/addItem/item/itemView.dart';
import 'package:belaaraby/models/itemModel.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:belaaraby/myPacks/storeVoids.dart';
import 'package:belaaraby/tutoCtr.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';

import 'productsCtr.dart';

class ProductsView extends StatefulWidget {
  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> with TickerProviderStateMixin {
  final ProductsCtr gc = Get.find<ProductsCtr>();
  final TutoController ttr = Get.find<TutoController>();

  List<DropdownMenuItem<String>>? emptyList;
  late TabController _tcontroller;
  final List<String> titleList = [
    "Manage Products".tr,
    "Promote Products".tr,
  ];
  String currentTitle = 'Manage Products'.tr;

  @override
  void initState() {
    super.initState();

    currentTitle = titleList[0];
    _tcontroller = TabController(length: 2, vsync: this);
    _tcontroller.addListener(changeTitle);
    ttr.showProductsTuto(context);
  }

  @override
  void dispose() {
    _tcontroller.dispose();
    super.dispose();
  }

  void changeTitle() {
    setState(() {
      // get index of active tab & change current appbar title
      currentTitle = titleList[_tcontroller.index];
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            unselectedLabelColor: hintYellowColHex,
            labelColor: yellowColHex,
            controller: _tcontroller,
            isScrollable: false,
            indicatorColor: yellowColHex,
            indicatorWeight: 4,
            tabs:  [
              Tab(
                  key: ttr.manageKey,
                  icon: Icon(Ionicons.cart)
              ),
              Tab(
                  key: ttr.promoteKey,

                  icon: Icon(Ionicons.megaphone)
              ),
            ],
          ),
          title: Text(currentTitle),
          centerTitle: true,
        ),
        body: TabBarView(
          controller: _tcontroller,
          children: [
            /// manege screen
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20),

                    ///categories
                    StreamBuilder<QuerySnapshot>(
                      stream: storesColl.where('id', isEqualTo: gc.st.id!).snapshots(),
                      builder: (
                          BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot,
                          ) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return const Text('Error');
                          } else if (snapshot.hasData) {
                            var store = snapshot.data!.docs.first;
                            Map<String, dynamic> categs = store.get('categories');
                            Map<String, dynamic> categsImgs = store.get('categImages');
                            return categs.isNotEmpty
                                ? GridView.builder(
                                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 7),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 1,
                                  crossAxisCount: 2,
                                ),
                                itemCount: categs.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  String categName = categs.keys.elementAt(index);
                                  String categUrl = categsImgs[categName];

                                  return categGridCard(categName, categUrl, gc,context);
                                })
                                : Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Center(
                                child: Text('no categories found'.tr),
                              ),
                            );

                          } else {
                            return  Text('empty data'.tr);
                          }
                        } else {
                          return Container();

                        }

                      },
                    ),

                    SizedBox(height: 60),

                  ],
                ),
              ),
            ),

            ///promo screen
            SafeArea(
              child: SingleChildScrollView(
                child: Column(children: [
                  SizedBox(height: 20),

                  ///items list promoted
                  StreamBuilder<QuerySnapshot>(
                    stream: storesColl.where('id', isEqualTo: gc.st.id!).snapshots(),
                    builder: (
                        BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot,
                        ) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return const Text('Error');
                        } else if (snapshot.hasData) {
                          var store = snapshot.data!.docs.first;
                          Map<String, dynamic> promo = store.get('promo');
                         return promo.isNotEmpty
                              ? GridView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 7),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 0.9,
                                crossAxisCount: 2,
                              ),
                              itemCount: promo.length,
                              itemBuilder: (BuildContext ctx, index) {
                                String itemName = promo.keys.elementAt(index);
                                Map<String, dynamic> itemMap = promo[itemName]!;
                                Item item = itemFromMap(itemMap);

                                return itemGridCard(item, gc);
                              })
                              : Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              child: Text('no promoted items found'.tr),
                            ),
                          );
                        } else {
                          return  Text('empty data'.tr);
                        }
                      } else {
                        return Container();

                      }

                    },
                  ),


                ]),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

        floatingActionButton:Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[

              Container(
                key: ttr.addCategKey,

                height: 40.0,
                width: 130.0,
                child: FittedBox(
                  child: FloatingActionButton.extended(

                    onPressed: () {
                      gc.addCategDialog(context);
                    },
                    heroTag: 'addItem',
                    backgroundColor: yellowColHex ,
                    label: Row(
                      children: [
                        const Icon(Icons.add),
                        const SizedBox(width: 5),
                        Text("Add Category".tr,
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
      ),
    );
  }
}
