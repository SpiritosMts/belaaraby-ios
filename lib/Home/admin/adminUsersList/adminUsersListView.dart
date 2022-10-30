import 'package:belaaraby/Home/admin/adminHome/adminHomeCtr.dart';
import 'package:belaaraby/Home/admin/adminUsersList/adminUsersListCtr.dart';
import 'package:belaaraby/Home/news/readNews/readPosts/readPostView.dart';
import 'package:belaaraby/Home/news/readNews/readVideos/readVideoView.dart';
import 'package:belaaraby/models/brUserModel.dart';
import 'package:belaaraby/models/storeModel.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminUsersListView extends StatefulWidget {
  @override
  State<AdminUsersListView> createState() => _AdminUsersListViewState();
}

class _AdminUsersListViewState extends State<AdminUsersListView> {
  final AdminUsersListCtr gc = Get.find<AdminUsersListCtr>();
  final Map<String, Store> storeMap = Get.find<AdminHomeCtr>().storeMap;

  showUserStores(stores, name) {
    Get.defaultDialog(
        backgroundColor: blueColHex2,
        title: "${'stores of'.tr} \"$name\"",
        titlePadding: const EdgeInsets.only(top: 30, bottom: 10),
        contentPadding: const EdgeInsets.only(top: 10, bottom: 30, right: 25, left: 25),

        // buttonColor: Colors.,
        barrierDismissible: true,
        radius: 20,
        content: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemExtent: 25,
          shrinkWrap: true,
          itemCount: stores.length,
          itemBuilder: (context, index) => Container(
            child: Text('${index + 1}. ${storeMap[stores[index]]!.name}'),
          ),
        ));
  }

  Widget userCard(BrUser user, context) {
    gc.swicherMap[user.id] = user.isAdmin;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        if (user.stores!.length != 0) {
          showUserStores(user.stores!, user.name);
        }
      },
      child: SizedBox(
        height: 200,
        child: Stack(
          children: [
            Card(
              color: blueColHex2,

              //margin: const EdgeInsets.all(8.0),
              elevation: 3,
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text('${user.name}', style: const TextStyle(fontWeight: FontWeight.w800)),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(right: 4.0, bottom: 10.0),
                  child: RichText(
                    locale: Locale(currLang!),
                    textAlign: TextAlign.start,
                    //softWrap: true,
                    text: TextSpan(children: [
                      WidgetSpan(
                          child: Text(
                        '${'email'.tr}:  ${user.email}',
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 2,
                        ),
                      )),
                      const TextSpan(text: '\n'),

                      WidgetSpan(
                          child: Text(
                        '${'join date'.tr}:  ${user.joinDate}',
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.5,
                        ),
                      )),
                      const TextSpan(text: '\n'),
                      WidgetSpan(
                          child: Text(
                        '  ${user.stores!.length}',
                        maxLines: 1,
                        style: TextStyle(fontWeight: FontWeight.w600,fontSize: 13, height: 1.5, color: user.stores!.length != 0 ? yellowColHex : Colors.white),
                      )),
                      WidgetSpan(
                          child: Text(
                        '${'stores number'.tr}:',
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.5,

                        ),
                      )),

                      ///admin access
                      // WidgetSpan(
                      //     child:  Flexible(
                      //       child: Container(
                      //         padding: const EdgeInsets.symmetric(vertical:10.0),
                      //         width: MediaQuery.of(context).size.width * 0.6,
                      //         child: RichText(
                      //           locale: Locale(currLang!),
                      //           textAlign: TextAlign.start,
                      //           softWrap: true,
                      //           text: TextSpan(children: [
                      //             TextSpan(
                      //               text: '${'admin access'.tr}:',
                      //               style: TextStyle(fontSize: 10),
                      //             ),
                      //             const TextSpan(text: '  '),
                      //             WidgetSpan(
                      //               child:  SizedBox(
                      //                   height: 15,
                      //                   // color: Colors.redAccent,
                      //                   child:     Switch(
                      //                     value: gc.swicherMap[user.id],
                      //                     onChanged: (val){
                      //                       gc.onChangeAdmin(val,user.id,context);
                      //                     },
                      //                   )
                      //               ),
                      //             ),
                      //           ]),
                      //         ),
                      //       ),
                      //     ),
                      // ),
                    ]),
                  ),
                ),
              ),
            ),
            Positioned(
                top: 15,
                left: 15,
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: MaterialButton(
                    onPressed: () {
                      gc.deleteUser(context, user);
                    },
                    color: blueColHex,
                    textColor: yellowColHex,
                    // padding: EdgeInsets.all(16),
                    shape: CircleBorder(),
                    child: const Icon(
                      Icons.delete,
                      size: 20,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  searchAppBar() {
    return AppBar(
      toolbarHeight: 60.0,
      title: GetBuilder<AdminUsersListCtr>(
          //id: 'appBar',
          builder: (_) {
            return gc.typing
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 0.0),
                    child: SizedBox(
                      height: 40,
                      child: Container(
                          //margin: EdgeInsets.symmetric(vertical: 50),
                          decoration: BoxDecoration(
                            color: hintYellowColHex4,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          //margin: EdgeInsets.all(20.0),
                          //alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 0.0),

                            ///TextFormField
                            child:TextFormField(
                              autocorrect: true,
                              cursorColor: Colors.white54,
                              keyboardType: TextInputType.text,
                              style: const TextStyle(
                                fontSize: 18,
                                color: blueColHex,
                              ),
                              textAlign: TextAlign.start,
                              controller: gc.typeAheadController,
                              autofocus: true,
                              onChanged: (input){
                                gc.runFilterList(input);
                                },
                              decoration: InputDecoration(
                                //filled: true,

                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                fillColor: hintYellowColHex,
                                hintStyle: const TextStyle(
                                  color: blueColHex3,
                                ),

                                hintText: 'search for user'.tr,

                                contentPadding: EdgeInsets.only(right: 10.0, bottom: 10),
                              ),
                            ),
                          )),
                    ),
                  )
                : Text('Users List'.tr);
          }),
      actions: <Widget>[
        GetBuilder<AdminUsersListCtr>(
            //id: 'appBar',
            builder: (_) {
              return !gc.typing
                  ? IconButton(
                      padding: EdgeInsets.only(left: 15.0),
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        gc.appBarTyping(true);
                      },
                    )
                  : IconButton(
                      padding: EdgeInsets.only(left: 15.0),
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        gc.clearSelectedProduct();
                      },
                    );
            }),
      ],
      bottom: appBarUnderline(),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: searchAppBar(),
      body: SafeArea(
        child: GetBuilder<AdminUsersListCtr>(
          builder: (ctr) => (gc.foundUsersList.isNotEmpty)
              ? ListView.builder(
                  itemExtent: 130,
                  //physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  shrinkWrap: true,
                  itemCount: gc.foundUsersList.length,
                  itemBuilder: (BuildContext context, int index) {
                    //String key = gc.foundUsersMap.keys.elementAt(index);
                    return userCard(gc.foundUsersList[index], context);
                  })
              : gc.shouldLoad? Center(
            child: CircularProgressIndicator(),
          ):Center(
            child: Text('no users found'.tr,
            style: GoogleFonts.almarai(
              fontSize: 20
            ),
            ),
          ),
        ),
      ),
    );
  }
}
