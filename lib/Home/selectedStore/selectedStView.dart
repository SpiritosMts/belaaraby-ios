import 'package:belaaraby/Home/selectedStore/selectedStCtr.dart';
import 'package:belaaraby/addEditStore/components/productsPicker/addItem/item/itemView.dart';
import 'package:belaaraby/Home/selectedStore/categ/itemViewRo.dart';
import 'package:belaaraby/models/brUserModel.dart';
import 'package:belaaraby/models/itemModel.dart';
import 'package:belaaraby/models/storeModel.dart';
import 'package:belaaraby/myPacks/mapVoids.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:belaaraby/myPacks/storeVoids.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:belaaraby/Home/homeCtr.dart';
import 'package:belaaraby/myPacks/scrollingImages.dart';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class SelectedStView extends StatefulWidget {
  @override
  State<SelectedStView> createState() => _SelectedStViewState();
}

class _SelectedStViewState extends State<SelectedStView> with TickerProviderStateMixin {
  final SelectedStCtr gc = Get.find<SelectedStCtr>();
  BrUser cUser = authCtr.cUser;

  Store st = Store();

  initTab() {
    gc.currentTitle = gc.titleList[0];
    gc.tabController = TabController(length: 3, vsync: this);
    gc.tabController.addListener(gc.changeTitle);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Material(
      child: DefaultTabController(
        length: 3,
        child: GetBuilder<SelectedStCtr>(
          initState: (_) {
            print('## open Selectedst View');
            st = gc.st;
            initTab();
          },
          dispose: (_) {
            print('## close Selectedst View');
            gc.tabController.dispose();
            Get.delete<SelectedStCtr>();
          },
          builder: (ctr) => SafeArea(
            child: Stack(
              children: [
                SizedBox(
                  // height: MediaQuery.of(context).size.height * gc.dialogheightScale,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 30,
                        ),

                        ///logo
                        headerLogo(st.logo!, st.jobType!),

                        /// name ,rate
                        Container(
                          padding: const EdgeInsets.only(left: 10.0, top: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              ///name
                              Flexible(
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.6,
                                  child: Text(
                                    '${st.name}',
                                    style: GoogleFonts.almarai(fontSize: 30, height: 1.3),
                                  ),
                                ),
                              ),

                              /// rate
                              ratingBox(st.id),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),

                        Container(
                          padding: const EdgeInsets.only(right: 20.0, top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ///open/closed
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Container(
                                  height: 35,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: blueColHex,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                        shape: RoundedRectangleBorder(
                                            side: const BorderSide(color: yellowColHex, width: 1, style: BorderStyle.solid),
                                            borderRadius: BorderRadius.circular(100)),
                                      ),
                                      onPressed: () async {
                                        showShcedule(context, st);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 13.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.timer,
                                              color: yellowColHex,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 5),
                                            isOpen(st)
                                                ? Text(
                                                    "Open".tr,
                                                    style: const TextStyle(color: Colors.greenAccent, fontSize: 13),
                                                  )
                                                : Text(
                                                    "Closed".tr,
                                                    style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              ///deirections
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Container(
                                  height: 35,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 0.0),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: blueColHex,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                        shape: RoundedRectangleBorder(
                                            side: const BorderSide(color: yellowColHex, width: 1, style: BorderStyle.solid),
                                            borderRadius: BorderRadius.circular(100)),
                                      ),
                                      onPressed: () async {
                                        await MyVoids().openGoogleMapApp(st.latitude!, st.longitude!);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 13.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.subdirectory_arrow_left_rounded,
                                              color: yellowColHex,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              "directions".tr,
                                              style: const TextStyle(color: yellowColHex, fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              ///call
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Container(
                                  height: 35,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 0.0),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: blueColHex,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                        shape: RoundedRectangleBorder(
                                            side: const BorderSide(color: yellowColHex, width: 1, style: BorderStyle.solid),
                                            borderRadius: BorderRadius.circular(100)),
                                      ),
                                      onPressed: () async {
                                        launchUrl(Uri.parse("tel://${st.phone}"));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 13.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.phone,
                                              color: yellowColHex,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              "call".tr,
                                              style: const TextStyle(color: yellowColHex, fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        ///TabBar
                        TabBar(
                          unselectedLabelColor: hintYellowColHex,
                          labelColor: yellowColHex,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          controller: gc.tabController,
                          isScrollable: false,
                          indicatorColor: yellowColHex,
                          indicatorWeight: 4,
                          tabs: [
                            Tab(
                                icon: Text(
                              gc.titleList[0],
                            )),
                            Tab(
                                icon: Text(
                              gc.titleList[1],
                            )),
                            Tab(
                                icon: Text(
                              gc.titleList[2],
                            )),
                          ],
                        ),
                        /// info (read only)
                        if (gc.currentTitle == gc.titleList[0])
                          Column(
                            children: [
                              const SizedBox(
                                height: 15,
                              ),

                              ///Images
                              gc.images.isNotEmpty ? ImagesScroll(imageList: gc.images) : Container(),
                              const SizedBox(
                                height: 15,
                              ),

                              ///logo_tax
                             if(gc.isAdmin) Column(
                                children: [

                                  ///show logo
                                  Column(
                                    children: [
                                      Row(
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        // mainAxisAlignment: MainAxisAlignment.start,
                                        // mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          const Icon(
                                            Icons.image_outlined,
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Flexible(
                                            child: Container(
                                              //padding: const EdgeInsets.only(right:25.0),
                                              width: MediaQuery.of(context).size.width * 0.6,
                                              child: RichText(
                                                locale: Locale(currLang!),
                                                textAlign: TextAlign.start,
                                                softWrap: true,
                                                text: TextSpan(children: [
                                                  TextSpan(
                                                    text: '${'show logo'.tr}:',
                                                    style: TextStyle(fontSize: 10),
                                                  ),
                                                  const TextSpan(text: '  '),
                                                  WidgetSpan(
                                                    child:  SizedBox(
                                                      height: 15,
                                                      // color: Colors.redAccent,
                                                      child: Switch(
                                                        inactiveTrackColor: Colors.white24,
                                                        value: gc.localShowLogo,
                                                        onChanged: (val) {
                                                          gc.switchLogo(val);
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  ),
                                  ///store_tax

                                  Column(
                                    children: [
                                      Row(
                                        children: <Widget>[
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          const Icon(
                                            Icons.numbers,
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Flexible(
                                            child: Container(
                                              //padding: const EdgeInsets.only(right:25.0),
                                              width: MediaQuery.of(context).size.width * 0.6,
                                              child: RichText(
                                                locale: Locale(currLang!),
                                                textAlign: TextAlign.start,
                                                softWrap: true,
                                                text: TextSpan(children: [
                                                  TextSpan(
                                                    text: '${'tax number'.tr}:',
                                                    style: TextStyle(fontSize: 10),
                                                  ),
                                                  const TextSpan(text: '  '),
                                                  TextSpan(
                                                    text: '${st.tax}',
                                                    style: const TextStyle(
                                                      height: 1.5,
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  ),
                                ],
                              ),


                              ///full adress
                              Row(
                                children: <Widget>[
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  const Icon(
                                    Icons.place,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Flexible(
                                    child: Container(
                                      //padding: const EdgeInsets.only(right:25.0),
                                      width: MediaQuery.of(context).size.width * 0.6,
                                      child: RichText(
                                        locale: Locale(currLang!),
                                        textAlign: TextAlign.start,
                                        softWrap: true,
                                        text: TextSpan(children: [
                                          TextSpan(
                                            text: '${st.address}',
                                            style: const TextStyle(
                                              height: 1.5,
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),

                              ///store_desc
                              if (st.jobDesc != '')
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Icon(
                                      Icons.description,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Flexible(
                                      child: Container(
                                        //padding: const EdgeInsets.only(right:25.0),
                                        width: MediaQuery.of(context).size.width * 0.6,
                                        child: RichText(
                                          locale: Locale(currLang!),
                                          textAlign: TextAlign.start,
                                          softWrap: true,
                                          text: TextSpan(children: [
                                            TextSpan(
                                              text: '${st.jobDesc}',
                                              style: const TextStyle(
                                                height: 1.5,
                                              ),
                                            ),
                                          ]),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              const SizedBox(
                                height: 15,
                              ),

                              ///store_website
                              if (st.website != '')
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    const Icon(
                                        Icons.web,
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Flexible(
                                      child: Container(
                                        //padding: const EdgeInsets.only(right:25.0),
                                        width: MediaQuery.of(context).size.width * 0.6,
                                        child: RichText(
                                          locale: Locale(currLang!),
                                          textAlign: TextAlign.start,
                                          softWrap: true,
                                          text: TextSpan(children: [
                                            WidgetSpan(child: InkWell(
                                              onTap: ()async{
                                               String url = st.website!;
                                                if (await canLaunchUrl(Uri.parse(url))) {
                                                await launchUrl(Uri.parse(url));
                                                } else {
                                                throw "Could not launch $url";
                                                }
                                              },
                                              child:   Text(
                                                 '${st.website}',
                                                style: const TextStyle(
                                                  height: 1.5,
                                                ),
                                              ),
                                            ))

                                          ]),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        /// products (read only)
                        if (gc.currentTitle == gc.titleList[1])
                          SafeArea(
                            child: GetBuilder<SelectedStCtr>(
                              builder: (ctr) => Column(children: [
                                SizedBox(
                                  height: height / 20,
                                ),
                                ///promos
                                if(st.promos!.isNotEmpty)
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 5.0,right: 27),
                                          child: Text(
                                            'Interface'.tr,
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.almarai(
                                              fontSize: 20,

                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 29.h,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 13),
                                          itemCount: st.promos!.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            String itemName = st.promos!.keys.elementAt(index);
                                            Map<String, dynamic> itemMap = st.promos![itemName]!;
                                            Item item = itemFromMap(itemMap);

                                            return itemCardRoHori(item, gc);
                                          }),
                                    ),

                                  ],
                                ),
                                ///categs
                                (st.categories!.isNotEmpty)?
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 5.0,right: 27),
                                          child: Text(
                                            'categories'.tr,
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.almarai(
                                              fontSize: 20,

                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      height:28.h,
                                      child: ListView.builder(
                                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 13),
                                          scrollDirection: Axis.horizontal,
                                           shrinkWrap: true,
                                          itemCount: st.categories!.length,
                                          itemBuilder: (BuildContext ctx, index) {
                                            String categName = st.categories!.keys.elementAt(index);
                                            String categUrl = st.categImages![categName];

                                            return categCardRoHori(categName, categUrl, gc, ctx);
                                          }),
                                    ),

                                  ],
                                ):
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Text(
                                      'no categories found'.tr,
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.almarai(
                                        fontSize: 17,

                                      ),
                                    ),
                                  ),
                                ),

                              ]),
                            ),
                          ),
                        ///comments
                        if (gc.currentTitle == gc.titleList[2])
                          futureCommentBox(st.id),
                        const SizedBox(
                          height: 90,
                        )
                      ],
                    ),
                  ),
                ),

                Positioned(
                  top: 5,
                  right: 5,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: yellowColHex,
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),

                ///rate btn
                Positioned(
                  height: 40,
                  width: 110,
                  bottom: 19,
                  left: 10,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 0.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: (authCtr.cUser.name! != 'no-name') //has account
                            ? (!ownerCanRateOthers) // cant rate others cte bool
                                ? (!authCtr.cUser.hasStores!) //user has stores
                                    ? Colors.amber
                                    : Colors.grey[400]
                                : Colors.amber
                            : Colors.grey[400],
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                        shape: RoundedRectangleBorder(
                            //side: const BorderSide(color: blueColHex, width: 2, style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(100)),
                      ),
                      onPressed: () async {
                        gc.onPressRate(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.star,
                            color: blueColHex,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Rate".tr,
                            style: const TextStyle(color: blueColHex),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                ///call btn
                // Positioned(
                //   height: 40,
                //   width: 110,
                //   bottom: 19,
                //   left: 10,
                //   child: Padding(
                //     padding: const EdgeInsets.only(bottom: 0.0),
                //     child: TextButton(
                //       style: TextButton.styleFrom(
                //         backgroundColor: blueColHex,
                //         tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //         padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                //         shape: RoundedRectangleBorder(
                //             side: const BorderSide(color: yellowColHex, width: 2, style: BorderStyle.solid),
                //             borderRadius: BorderRadius.circular(100)),
                //       ),
                //       onPressed: ()async {
                //         launch("tel://${st.phone}");
                //
                //       },
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Text(
                //             "call".tr,
                //             style: const TextStyle(color: yellowColHex),
                //           ),
                //           const SizedBox(width: 10),
                //           const Icon(Icons.phone,color: yellowColHex)
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
