import 'dart:ui';
import 'package:belaaraby/Home/admin/adminUsersList/adminUsersListView.dart';
import 'package:belaaraby/Home/news/newsView.dart';
import 'package:belaaraby/addEditStore/addStore/addStoreView.dart';
import 'package:belaaraby/main.dart';
import 'package:belaaraby/test.dart';
import 'package:belaaraby/tutoCtr.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:belaaraby/myPacks/mapVoids.dart';
import 'package:belaaraby/models/brUserModel.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:belaaraby/myPacks/notifications/notificationCtr.dart';
import 'package:belaaraby/settings.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:belaaraby/auth/login_screen.dart';
import 'package:belaaraby/auth/signup.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:url_launcher/url_launcher.dart';
import 'homeCtr.dart';

class StoresMapView extends StatelessWidget {
  final HomeCtr gc = Get.find<HomeCtr>();
  final TutoController ttr = Get.find<TutoController>();

  BrUser cUser = authCtr.cUser;

  Color textCol = yellowColHex;
  Color bgCol = blueColHex;

  appDrawer(width) {
    return Drawer(
      width: width * .7,
      child: Column(
        children: <Widget>[
          Expanded(
            // upper listTiles
            child: ListView(
              children: [
                ///header
                Container(
                  color: Color(0XFFe9d98e),
                  height: 140,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            color: Colors.white54,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: Offset(3, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: SizedBox(
                              //size: Size.fromRadius(30),
                              child: Image.asset('assets/user.png'),
                            ),
                          ),
                        ),

                        /// user name
                        title: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(cUser.name! != 'no-name' ? cUser.name! : 'Guest'.tr,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: blueColHex)),
                        ),

                        /// user info
                        subtitle: Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 3.0),
                          child: Container(
                            width: width * 0.6,
                            child: RichText(
                              locale: Locale(currLang!),
                              textAlign: TextAlign.start,
                              softWrap: true,
                              text: cUser.name! != 'no-name'
                                  ? TextSpan(children: [
                                      TextSpan(
                                        text: cUser.email!,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          height: 1.5,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ])
                                  : TextSpan(children: [
                                      TextSpan(
                                        text: '${'you have no account?'.tr}\n',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          height: 1.5,
                                          color: Colors.black38,
                                        ),
                                      ),
                                      TextSpan(
                                          text: 'Sign up now'.tr,
                                          style: const TextStyle(color: Colors.black87, fontSize: 14),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              sharedPrefs!.setBool('isGuest', false);
                                              Get.back();
                                              authCtr.signOut();
                                              Get.offAll(() => SignUp());

                                            }),
                                    ]),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// Add your own store
                ListTile(
                  key: ttr.addStoreKey,

                  leading: Icon(
                    Icons.add,
                    color: (cUser.name != 'no-name') ? yellowColHex : Colors.grey,
                  ),
                  title: Text('Add your store'.tr),
                  onTap: () {
                    Get.back();
                    if (cUser.name != 'no-name') {
                      Get.to(() => AddStoreView());
                    } else {
                      MyVoids().showTos('you must log in to your account to add new store'.tr);
                    }
                  },
                ),
                const Divider(
                  height: 10,
                  endIndent: 30,
                  indent: 30,
                ),

                /// my stores
                ListTile(
                  key: ttr.myStoresKey,
                  leading: Icon(
                    Icons.home,
                    color: (cUser.name != 'no-name') ? yellowColHex : Colors.grey,
                  ),
                  title: Text('My Stores'.tr),
                  onTap: () {
                    Get.back();

                    if (cUser.name != 'no-name') {
                      gc.openMyStoreList();
                    } else {
                      MyVoids().showTos('you must log in to your account to add or modify your stores'.tr);
                    }
                  },
                ),
                const Divider(
                  height: 10,
                  endIndent: 30,
                  indent: 30,
                ),

                /// News
                ListTile(
                  key: ttr.newsKey,

                  leading: const Icon(
                    Icons.newspaper,
                  ),
                  title: Text('News'.tr),
                  onTap: () {
                    Get.back();
                    Get.to(() => NewsView(), arguments: {'showButtons': false});
                  },
                ),
                const Divider(
                  height: 10,
                  endIndent: 30,
                  indent: 30,
                ),

                /// Notifications
                GetBuilder<MyNotifCtr>(
                  //id: 'notif',
                  builder: (ctr) => ListTile(
                    leading: const Icon(
                      Icons.notifications,
                    ),
                    title: Row(
                      children: [
                        Text('Notifications'.tr),
                        SizedBox(width: width / 18),
                        Switch(
                          inactiveThumbColor: Colors.white54,
                          inactiveTrackColor: Colors.grey[700],
                          value: ctr.isNotifActive,
                          onChanged: (val) {
                            //gc.switchNotif(val);
                            ctr.onSwitch(val);
                          },
                        ),
                      ],
                    ),
                    onTap: () {},
                  ),
                ),
                const Divider(
                  height: 10,
                  endIndent: 30,
                  indent: 30,
                ),

                /// Settings
                // ListTile(
                //   leading: const Icon(
                //     Icons.settings,
                //   ),
                //   title: Text('Settings'.tr),
                //   onTap: () {
                //     Get.back();
                //     Get.to(() => MyLocaleView());
                //   },
                // ),
                // const Divider(
                //   height: 10,
                //   endIndent: 30,
                //   indent: 30,
                // ),
              ],
            ),
          ),
          // downer listTiles

          Container(
              child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                      child: Column(
                    children: <Widget>[
                      const Divider(),

                      ///Terms and Policies
                      ListTile(
                        leading: const Icon(
                          Icons.policy,
                          //color: Colors.redAccent,
                        ),
                        title: Text(
                          'Terms and Policies'.tr,
                          //style: TextStyle(color: Colors.redAccent),
                        ),
                        onTap: () async {
                          Get.back();
                          const url = "https://inarabic.eu/privacy-policy/";
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url));
                          } else {
                            throw "Could not launch $url";
                          }
                        },
                      ),
                      const Divider(),
                      cUser.name! != 'no-name'
                          ? ListTile(
                              leading: const Icon(
                                Icons.logout,
                                color: Colors.redAccent,
                              ),
                              title: Text(
                                'Sign out'.tr,
                                style: TextStyle(color: Colors.redAccent),
                              ),
                              onTap: () async {
                                sharedPrefs!.setBool('isGuest', false);
                                Get.back();
                                authCtr.signOut();
                                Get.offAll(() => LoginScreen());
                              },
                            )
                          : ListTile(
                              leading: const Icon(
                                Icons.logout,
                                color: Colors.blueAccent,
                              ),
                              title: Text(
                                'Sign In'.tr,
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                ),
                              ),
                              onTap: () async {
                                sharedPrefs!.setBool('isGuest', false);
                                Get.back();
                                authCtr.signOut();
                                Get.offAll(() => LoginScreen());
                              },
                            ),
                    ],
                  ))))
        ],
      ),
    );
  }

  searchAppBar(context) {
    return AppBar(
      toolbarHeight: 60.0,
      title: GetBuilder<HomeCtr>(
          id: 'appBar',
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
                          child: Form(
                            key: gc.formKey,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 0.0),

                              /// TypeAheadFormField
                              child: TypeAheadFormField(
                                noItemsFoundBuilder: (_) {
                                  return SizedBox(
                                    height: 40,
                                    child: Center(
                                      child: Text(
                                        'no products found'.tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: yellowColHex),
                                      ),
                                    ),
                                  );
                                },
                                //animationDuration: const Duration(milliseconds: 1500),
                                textFieldConfiguration: TextFieldConfiguration(
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

                                    hintText: 'search for product'.tr,

                                    contentPadding: EdgeInsets.only(right: 10.0, bottom: 10),
                                  ),
                                ),
                                suggestionsCallback: (pattern) {
                                  return gc.allNearbyItemsList.where((String item) => item.toLowerCase().contains(pattern.toLowerCase())).toList();
                                },
                                itemBuilder: (context, suggestion) {
                                  return ListTile(
                                    title: Text(suggestion.toString()),
                                  );
                                },
                                transitionBuilder: (context, suggestionsBox, controller) {
                                  return suggestionsBox;
                                },
                                onSuggestionSelected: (suggestion) {
                                  gc.onSuggestionSelected(suggestion);
                                },
                              ),
                            ),
                          )),
                    ),
                  )
                : Text('Belaaraby'.tr);
          }),
      leading: Builder(
        builder: (context) => IconButton(
          key: ttr.drawedKey,
          icon: const Icon(
            Icons.list,
            color: yellowColHex,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
            ttr.showDrawerTuto(context);


          } ,
        ),
      ),
      actions: <Widget>[

        GetBuilder<HomeCtr>(
            id: 'appBar',
            builder: (_) {
              return !gc.typing
                  ? Row(
                mainAxisSize: MainAxisSize.min,

                    children: [
                      IconButton(
                        key:ttr.refreshKey,

                        padding: EdgeInsets.only(left: 0.0),
                        icon:const Icon(Icons.refresh),
                        onPressed: () {
                          authCtr.refreshCuser();
                          gc.getStoresData(context);

                        },
                      ),
                      IconButton(
                        key:ttr.searchKey,

                        padding: EdgeInsets.only(left: 0.0),
                          icon: Icon(Icons.search),
                          onPressed: () {
                            gc.appBarTyping(true);
                          },
                        ),
                      SizedBox(width: 10,)

                    ],
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

  //###################################################################################################################"
  //###################################################################################################################"
  @override
  Widget build(BuildContext context) {
    //super.build(context);
    double width = MediaQuery.of(context).size.width;
    //double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: searchAppBar(context),

      /// change later
      drawer: appDrawer(width),
      body: Stack(
        children: [
          /// map
          GetBuilder<HomeCtr>(
              initState: (_) {
                print('## init_map_View');


                Future.delayed(const Duration(seconds: 1), () {
                  gc.getStoresData(context);

                });
                Future.delayed(const Duration(seconds: 3), () {
                  ttr.showHomeTuto(context);

                });

              },
              dispose: (_) {
                print('## dispose_map_View');
                //Get.delete<HomeCtr>();
              },

              id: 'map',
              builder: (_) {
                gc.updateMap();
                print('## map updated');
                return CustomGoogleMapMarkerBuilder(
                  customMarkers: mapToListMarkerData(gc.grNearbyMarkers),
                  builder: (BuildContext context, Set<Marker>? markers) {
                    return Stack(
                      children: [
                        GoogleMap(
                            mapType: MapType.normal,
                            markers: markers ?? {},
                            circles: gc.circles,
                            initialCameraPosition: (gc.userPos.latitude * gc.userPos.latitude != 0.0)
                                ? CameraPosition(
                                    target: LatLng(gc.userPos.latitude, gc.userPos.longitude),
                                    zoom: 10,
                                  )
                                : belgiumPos,
                            mapToolbarEnabled: false,
                            trafficEnabled: false,
                            liteModeEnabled: false,
                            myLocationButtonEnabled: false,
                            myLocationEnabled: true,
                            zoomControlsEnabled: false,
                        gestureRecognizers: < Factory < OneSequenceGestureRecognizer >> {
                           Factory < OneSequenceGestureRecognizer > (
                                () =>  EagerGestureRecognizer(),
                          ),
                        },
                            onMapCreated: (controller) async {
                              gc.onMapCreated(controller);

                              // if (mounted) {
                              // }
                              //call curr user loc (req to activate gps)
                              //  gc.userLocation.onLocationChanged.listen((l) {});
                            }),

                        ///loading markers
                        markers == null
                            ? const Align(
                                alignment: Alignment.bottomCenter,
                                // bottom: 15,
                                // right: width*.5,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 70.0),
                                  child: CircularProgressIndicator(),
                                ))
                            : Container(),
                      ],
                    );
                  },
                );
              }),
          ///Slider BG
           Positioned(
            bottom: 0,
              child: Container(
                color: blueColHex,
                child: SizedBox(
                  width: width,
                  height: 50,

          ),
              )),
          ///km text
          GetBuilder<HomeCtr>(
              id: 'slider',
              builder: (_) {
                //print('slider updated');
                return Align(
                  alignment: Alignment.bottomCenter,

                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 37.0),
                    child: Container(
                      height: 27,
                      width: 54,
                      padding: EdgeInsets.all(0),

                      decoration:
                      BoxDecoration(
                        color: blueColHex,
                        borderRadius: BorderRadius.circular(8),
                        //border: Border.all(color: yellowColHex, width: 1)
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 2.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(0),
                            child: SizedBox(
                              child: RichText(
                                locale: Locale(currLang!),
                                textAlign: TextAlign.start,
                                //softWrap: true,
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: gc.sliderVal.round().toString(),
                                      style: GoogleFonts.almarai(
                                        textStyle: const TextStyle(color: yellowColHex, fontSize: 13, fontWeight: FontWeight.w600),
                                      )),
                                  const TextSpan(
                                    text: ' ',
                                  ),
                                  TextSpan(
                                      text: 'km'.tr,
                                      style: GoogleFonts.almarai(
                                        textStyle: const TextStyle(color: yellowColHex, fontSize: 10, fontWeight: FontWeight.w400),
                                      )),
                                ]),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
          ///Slider
          GetBuilder<HomeCtr>(

              id: 'slider',
              builder: (_) {
                //print('slider updated');
                return Positioned(
                  key: ttr.sliderKey,
                  right: width/20,
                  bottom: 0,
                  // right: 20,
                  // bottom: 20,
                  child: Stack(
                    children: [



                      ///slider
                      Positioned(

                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                         // height: ,
                          width: width/1.1,
                          child: RotatedBox(
                            quarterTurns: 2,
                            child: Slider(
                              inactiveColor: Colors.white.withOpacity(0.4),
                              divisions: 99,
                              min: gc.minSliderVal,
                              max: gc.maxSliderVal,
                              value: gc.sliderVal,
                              onChangeEnd: (val) async {
                                gc.grNearbyMarkers = await gc.loadNearbyMarkers(gc.grMarkers, gc.selectedProduct, gc.sliderVal, printDet: true);
                              },
                              onChanged: (val) {
                                gc.changeSlider(val);
                              },
                            ),
                          ),
                        ),
                      ),
                      ///plus
                      Positioned(
                        right: 0,
                        bottom: 11,
                        child: GestureDetector(
                          onTap: (){
                            gc.plusSlider();
                            //gc.showTimedKm();
                          },
                          child: Container(
                            height: 27,
                            width: 27,
                            padding: EdgeInsets.all(0),
                            decoration:
                            BoxDecoration(color: yellowColHex, borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: blueColHex, width: 1)
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 2.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(0),
                                  child: Text('+',
                                      style: GoogleFonts.almarai(
                                        textStyle: const TextStyle(color: blueColHex, fontSize: 20, fontWeight: FontWeight.w700),
                                      )
                                  ),
                                ),
                              ),
                            ),),
                        ),
                      ),
                      ///minus
                      Positioned(
                        left: 0,
                        bottom: 11,

                        child: GestureDetector(
                          onTap: (){
                            gc.minusSlider();
                            //gc.showTimedKm();

                          },
                          child: Container(
                            height: 27,
                            width: 27,
                            padding: EdgeInsets.all(0),
                            decoration:
                            BoxDecoration(color: yellowColHex, borderRadius: BorderRadius.circular(8), border: Border.all(color: blueColHex, width: 1)),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 2.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(0),
                                  child: Text('-',
                                      style: GoogleFonts.almarai(
                                        textStyle: const TextStyle(color: blueColHex, fontSize: 20, fontWeight: FontWeight.w700),
                                      )
                                  ),
                                ),
                              ),
                            ),),
                        ),
                      ),

                    ],
                  ),
                );
              }),
          ///ads
          Positioned(
            top: -4,
            child: Image.network(
              'https://firebasestorage.googleapis.com/v0/b/inarabiceuv1.appspot.com/o/users%2FJqH2HYXlF2h83wzr9P3D3RDbpw32%2Fuploads%2F1635930854325301.jpg?alt=media&token=5c72611b-e17f-4ac1-b321-3c559ba298e1',
              width: width,
              fit: BoxFit.cover,
            ),
          ),
          /// gps btn
          Positioned(
            key: ttr.gpsKey,
            height: 60,
            width: 60,
            bottom: 60,
            left: 10,
            child: FloatingActionButton.extended(
              backgroundColor: blueColHex,
              heroTag: 'gpsBtn',
              onPressed: () async {
                gc.userPos = await getCurrentLocation(gc.gMapCtr);
              },
              label: const Icon(
                Icons.gps_fixed,
                color: yellowColHex,
              ),
            ),
          ),
          /// clear prefs
          // Positioned(
          //   height: 60,
          //   width: 60,
          //   bottom: 160,
          //   left: 10,
          //   child: FloatingActionButton.extended(
          //     backgroundColor: blueColHex,
          //     heroTag: 'gpdssBtn',
          //     onPressed: () async {
          //       sharedPrefs!.clear();
          //     },
          //     label: const Icon(
          //       Icons.clear,
          //       color: yellowColHex,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

/// stores btn
// Positioned(
//   height: 60,
//   width: 60,
//   bottom: 15,
//   left: 15,
//   child: FloatingActionButton.extended(
//     backgroundColor: blueColHex,
//     heroTag: 'openGR',
//     onPressed: () {
//       gc.openStoreList();
//     },
//     label: const Icon(
//       Icons.search,
//       color: yellowColHex,
//     ),
//   ),
// ),
// /// Test btn
// Positioned(
//   height: 30,
//   bottom: 90,
//   left: 15,
//   child: FloatingActionButton.extended(
//     heroTag: 'test',
//     onPressed: () {
//       gc.loadMarkers(gc.storeMap, context);
//     },
//     label: const Text('load markers'),
//   ),
// ),
//
// /// Test btn
// Positioned(
//   height: 30,
//   bottom: 150,
//   left: 15,
//   child: FloatingActionButton.extended(
//     heroTag: 'teddst',
//     onPressed: () {
//       gc.getStoresData(context,printDet: true); //=> images are white
//     },
//     label: const Text('download strs'),
//   ),
// ),
//
// /// Test btn
// Positioned(
//   height: 30,
//   bottom: 200,
//   left: 15,
//   child: FloatingActionButton.extended(
//     heroTag: 'tefddst',
//     onPressed: () {
//       gc.testPressed();
//     },
//     label: const Text('cUser'),
//   ),
// ),
