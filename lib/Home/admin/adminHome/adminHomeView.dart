import 'dart:ui';
import 'package:belaaraby/Home/admin/adminHome/adminHomeCtr.dart';
import 'package:belaaraby/Home/admin/adminUsersList/adminUsersListView.dart';
import 'package:belaaraby/Home/news/ads/addAdsView.dart';
import 'package:belaaraby/Home/news/newsView.dart';
import 'package:belaaraby/addEditStore/addStore/addStoreView.dart';
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
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:belaaraby/auth/login_screen.dart';
import 'package:belaaraby/auth/signup.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminStoresMapView extends StatelessWidget {
  final AdminHomeCtr gc = Get.find<AdminHomeCtr>();
  BrUser cUser = authCtr.cUser;

  appDrawerAdmin(width, height) {
    return Drawer(
      width: width * .7,
      child: Column(
        children: <Widget>[
          Expanded(
            // upper listTiles
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
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
                              borderRadius: BorderRadius.circular(50)),
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
                          child: Text(cUser.name!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: blueColHex)),
                        ),

                        /// user info
                        subtitle: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 3.0),
                          child: Container(
                            width: width * 0.6,
                            child: RichText(
                              locale: Locale(currLang!),
                              textAlign: TextAlign.start,
                              softWrap: true,
                              text: TextSpan(children: [
                                TextSpan(
                                  text: cUser.email!,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    height: 1.5,
                                    color: Colors.black87,
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// all users (control)
                ListTile(
                  leading: const Icon(
                    Icons.group,
                  ),
                  title: Text('Users List'.tr),
                  onTap: () {
                    Get.back();

                    Get.to(() => AdminUsersListView());
                  },
                ),
                const Divider(
                  height: 10,
                  endIndent: 30,
                  indent: 30,
                ),

                /// Advertisement (control)
                ListTile(
                  leading: const Icon(
                    Icons.attach_money_outlined,
                  ),
                  title: Text('Advertisement'.tr),
                  onTap: () {
                    Get.back();
                    Get.to(() => AddAdsView());
                  },
                ),
                const Divider(
                  height: 10,
                  endIndent: 30,
                  indent: 30,
                ),

                /// News (control)
                ListTile(
                  leading: const Icon(
                    Icons.newspaper,
                  ),
                  title: Text('News'.tr),
                  onTap: () {
                    Get.back();
                    Get.to(() => NewsView(), arguments: {'showButtons': true});
                  },
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
                      ListTile(
                        leading: const Icon(
                          Icons.logout,
                          color: Colors.redAccent,
                        ),
                        title: Text(
                          'Sign out'.tr,
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                        onTap: () async {
                          Get.back();
                          await auth.signOut();
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
      title: GetBuilder<AdminHomeCtr>(
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

                              ///TypeAheadFormField
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

                                    contentPadding: EdgeInsets.only(
                                        right: 10.0, bottom: 10),
                                  ),
                                ),
                                suggestionsCallback: (pattern) {
                                  return gc.allNearbyItemsList
                                      .where((String item) => item
                                          .toLowerCase()
                                          .contains(pattern.toLowerCase()))
                                      .toList();
                                },
                                itemBuilder: (context, suggestion) {
                                  return ListTile(
                                    title: Text(suggestion.toString()),
                                  );
                                },
                                transitionBuilder:
                                    (context, suggestionsBox, controller) {
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
          icon: const Icon(
            Icons.list,
            color: yellowColHex,
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      actions: <Widget>[
        GetBuilder<AdminHomeCtr>(
            id: 'appBar',
            builder: (_) {
              return !gc.typing
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          padding: EdgeInsets.only(left: 0.0),
                          icon: const Icon(Icons.refresh),
                          onPressed: () {
                            gc.getStoresData(context);
                          },
                        ),
                        IconButton(
                          padding: EdgeInsets.only(left: 0.0),
                          icon: Icon(Icons.search),
                          onPressed: () {
                            gc.appBarTyping(true);
                          },
                        ),
                        SizedBox(width: 15,)

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
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: searchAppBar(context),

      /// change later
      drawer: appDrawerAdmin(width, height),
      body: Stack(
        children: [
          /// map
          GetBuilder<AdminHomeCtr>(
              initState: (_) {
                print('## init_map_View');

                Future.delayed(const Duration(seconds: 3), () {
                  gc.getStoresData(context);
                });
              },
              dispose: (_) {
                print('## dispose_map_View');
              },
              id: 'map',
              builder: (_) {
                //gc.updateMap();
                return CustomGoogleMapMarkerBuilder(
                  customMarkers: mapToListMarkerData(gc.grNearbyMarkers),
                  builder: (BuildContext context, Set<Marker>? markers) {
                    return Stack(
                      children: [
                        GoogleMap(
                            mapType: MapType.normal,
                            markers: markers ?? {},
                            initialCameraPosition:
                                (gc.userPos.latitude * gc.userPos.latitude !=
                                        0.0)
                                    ? CameraPosition(
                                        target: LatLng(gc.userPos.latitude,
                                            gc.userPos.longitude),
                                        zoom: 10,
                                      )
                                    : belgiumPos,
                            mapToolbarEnabled: false,
                            trafficEnabled: false,
                            liteModeEnabled: false,
                            myLocationButtonEnabled: false,
                            myLocationEnabled: true,
                            zoomControlsEnabled: false,
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
                                  padding: EdgeInsets.only(bottom: 20.0),
                                  child: CircularProgressIndicator(),
                                ))
                            : Container(),
                      ],
                    );
                  },
                );
              }),

          /// gps btn
          Positioned(
            height: 60,
            width: 60,
            bottom: 15,
            left: 15,
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
        ],
      ),
    );
  }
}
