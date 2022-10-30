import 'package:belaaraby/addEditStore/addStore/addStoreCtr.dart';
import 'package:belaaraby/addEditStore/addStore/addStoreView.dart';
import 'package:belaaraby/addEditStore/components/productsPicker/productsView.dart';
import 'package:belaaraby/addEditStore/editStoreInfo/editStoreInfoView.dart';
import 'package:belaaraby/models/storeModel.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myVoids.dart';

import 'homeCtr.dart';

/// your own stores list depends on your stores IDs list in (cUser.stores)
class MyStoresView extends StatefulWidget {
  @override
  State<MyStoresView> createState() => _MyStoresViewState();
}

class _MyStoresViewState extends State<MyStoresView> {
  List myStoresIDs = authCtr.cUser.stores!;
  final HomeCtr homeCtr = Get.find<HomeCtr>();



  goEditInfo() {
    Get.to(() => EditStoreView());
  }

  goEditProducts() {
    Get.to(() => ProductsView());
  }

  goAdd() {
    Get.to(() => AddStoreView());
  }

  getExpenseItems(ctx, AsyncSnapshot<List<Store>> snapshot) {
    double width = MediaQuery.of(ctx).size.width;
    double height = MediaQuery.of(ctx).size.height;

    return snapshot.data!.map((store) {
      String acceptedState = '';

      switch (store.accepted) {
        case "yes":
          acceptedState = 'accepted'.tr;
          break;
        case "no":
          acceptedState = 'refused'.tr;
          break;
        default://'notYet'
          acceptedState = 'review'.tr;
      }
      return Stack(
        children: [
          GestureDetector(
            onTap: () {
              if(homeCtr.nearbyStoreMap.containsKey(store.id)){
                Get.back(result: {'tappedStPosition': LatLng(store.latitude!, store.longitude!)});

              }
            },
            child: SizedBox(
              height: 180,
              child: Card(
                color: blueColHex2,

                margin: const EdgeInsets.all(8.0),
                elevation: 3,
                child: ListTile(
                  /// name
                  title: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 3.0),
                    child: Text('${store.name}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),

                  /// info
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                    child: RichText(
                      //locale: Locale(currLang!),
                      textAlign: TextAlign.start,
                      softWrap: true,
                      text: TextSpan(children: [
                        WidgetSpan(
                            child: Text('${'address local'.tr}:  ${store.address}',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                height: 2,
                              ),
                            )
                        ),
                        const TextSpan(text: '\n'),

                        WidgetSpan(
                            child: Text('${'tax number'.tr}:  ${store.tax}',
                              style: const TextStyle(
                                fontSize: 13,
                                height: 1.5,
                              ),
                            )
                        ),
                        const TextSpan(text: '\n'),

                        WidgetSpan(
                            child: Text('${'State'.tr}:  $acceptedState',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                height: 1.5,
                              ),
                            )
                        ),

                      ]),
                    ),
                  ),

                  /// rating
                  trailing: Container(
                    //color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                      child: SizedBox(
                        width: 70,
                        height: 70,
                        child: Column(
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ///rating
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                //stars.toStringAsFixed(1)
                                Text('${store.stars}', style: const TextStyle(fontSize: 20)),
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 25,
                                ),
                              ],
                            ), //star
                            const SizedBox(
                              height: 7,
                            ),

                            ///_raters
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.person, color: Colors.white70, size: 13), //person

                                Text("(${store.raterCount})", style: const TextStyle(fontSize: 11)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          //buttons

          Positioned(
            bottom: 20,
            right: 20,
            child: Row(
              children: [
                SizedBox(
                  //width: width / 7,
                  child: TextButton(
                    style: ylwStyle,
                    onPressed: () {
                      homeCtr.selectStToModify(store);
                      goEditInfo();
                    },
                    child: Text("edit".tr,
                        style: GoogleFonts.almarai(
                          color: Theme.of(context).backgroundColor,
                          textStyle: const TextStyle(fontSize: 15),
                        )),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  //width: width / 4,
                  child: TextButton(
                    style: ylwStyle,
                    onPressed: () {
                      homeCtr.selectStToModify(store);
                      goEditProducts();
                    },
                    child: Text("products".tr,
                        style: GoogleFonts.almarai(
                          color: Theme.of(context).backgroundColor,
                          textStyle: const TextStyle(fontSize: 15),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }).toList();
  }

  Future<List<Store>> getOwnedStoresFromIDs(IDs) async {
    List<Store> ownedStores = [];
    for (var id in IDs) {
      final event = await storesColl.where('id', isEqualTo: id).get();
      var doc = event.docs.single;
      Map<String, dynamic> promos = doc.get("promo");
      Map<String, dynamic> categories = doc.get("categories");
      Map<String, dynamic> categImages = doc.get("categImages");
      List<String> allItemsList = [];
      for (Map<String, dynamic> categ in categories.values) {
        for (var item in categ.keys) {
          allItemsList.add(item.toString());
        }
      }
      List<String> images = listDynamicToString(doc.get('images'));
      String logo = doc.get('logo');
      GeoPoint pos = doc.get('coords');
      ownedStores.add(Store(
        id: doc.id,
        //
        name: doc.get("name"),
        tax: doc.get("tax"),
        website: doc.get("website"),

        phone: doc.get("phone"),
        address: doc.get("address"),
        jobDesc: doc.get("jobDesc"),
        latitude: pos.latitude,
        longitude: pos.longitude,
        //
        promos: promos,
        categories: categories,
        categImages: categImages,
        allItemsList: allItemsList,

        //
        jobType: doc.get("jobType"),
        //
        openHours: doc.get('openHours'),
        openDays: doc.get('openDays'),
        //
        logo: logo,
        images: images,
        //
        ownerID: doc.get('ownerID'),
        ownerName: doc.get('ownerName'),
        //
        raterCount: doc.get("raterCount"),
        stars: doc.get("stars"),
        //
        accepted: doc.get('accepted'),
        showLogo: doc.get('showLogo'),

        //raters: not-to-use-here
      ));

      print('## got owned store < $id >');
    }
    print('## ownedStores number < ${ownedStores.length} >');

    return ownedStores;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Stores'.tr),
        bottom: appBarUnderline(),
      ),
      ///streamed stores
      // body: StreamBuilder<QuerySnapshot>(
      //   stream: storesColl.where('ownerID', isEqualTo: authCtr.cUser.id!).snapshots(),
      //   builder: (
      //       BuildContext context,
      //       AsyncSnapshot<QuerySnapshot> snapshot,
      //       ) {
      //     if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
      //       if (snapshot.hasError) {
      //         return const Text('Error');
      //       } else if (snapshot.hasData) {
      //
      //         var store = snapshot.data!.docs.first;
      //         Map<String, dynamic> categs = store.get('categories');
      //         return Container();
      //       } else {
      //         return Container() ;
      //       }
      //     } else {
      //       return Container()
      //     }
      //   },
      // ),
      body: FutureBuilder<List<Store>>(
        future: getOwnedStoresFromIDs(myStoresIDs),
        builder: (BuildContext context, AsyncSnapshot<List<Store>> snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            print('## your stores were found');
            return Container(
              child: ListView(shrinkWrap: true, children: getExpenseItems(context, snapshot)),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            print('## loading you stores ...');

            return const Center(
              child: CircularProgressIndicator(
                color:yellowColHex,
              ),
            );
          } else {
            print('## no stores ...');

            return Center(
              child: Text(
                "you have no stores yet".tr,

                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white70
                ),
              ),
            );
          }
        },
      ),

      /// add new store
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          goAdd();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
