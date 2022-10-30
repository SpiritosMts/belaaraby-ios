import 'package:belaaraby/Home/admin/adminStoresList/adminStoresListCtr.dart';
import 'package:belaaraby/Home/homeCtr.dart';
import 'package:belaaraby/models/storeModel.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:belaaraby/myPacks/myVoids.dart';



class AdminStoresListView extends StatefulWidget {
  @override
  State<AdminStoresListView> createState() => _AdminStoresListViewState();
}

class _AdminStoresListViewState extends State<AdminStoresListView> with TickerProviderStateMixin {
  final AdminStoresListCtr gc = Get.find<AdminStoresListCtr>();


  initTab() {
    gc.currentTitle = gc.titleList[0];
    gc.tabController = TabController(length: 2, vsync: this);
    gc.tabController.addListener(gc.changeTitle);
  }

  Widget StoreCard(ctx,Store st) {
    double width = MediaQuery.of(ctx).size.width;
    double height = MediaQuery.of(ctx).size.height;
    return GestureDetector(
      onTap: () {
        Get.back(result:{'tappedStPosition': LatLng(st.latitude!, st.longitude!)} );
      },
      child: SizedBox(
        height: height / 4.5,
        child: Card(
          color: blueColHex2,

          margin: const EdgeInsets.all(8.0),
          elevation: 3,
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 3.0),
              child: Text('${st.name}', style: const TextStyle(fontWeight: FontWeight.w800)),
            ),

            subtitle: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
              child: RichText(
                locale: Locale(currLang!),
                textAlign: TextAlign.start,
                //softWrap: true,
                text: TextSpan(children: [
                  WidgetSpan(
                      child: Text('${'address local'.tr}:  ${st.address}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 2,
                        ),
                      )
                  ),
                  WidgetSpan(
                      child: Text('${'store of'.tr}:  ${st.ownerName}',
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.5,
                        ),
                      )
                  ),
                  WidgetSpan(
                      child: Text('${'description'.tr}:    ${st.jobDesc !=''?   st.jobDesc:'...'}',
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
            trailing: Container(
              //color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: SizedBox(
                  width: 70,
                  height: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ///rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //stars.toStringAsFixed(1)
                          Text('${st.stars}', style: const TextStyle( fontSize: 20)),
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
                          const Icon(Icons.person,color: Colors.white70, size: 13), //person

                          Text("(${st.raterCount})", style: const TextStyle(fontSize: 11)),
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
    );
  }


  searchApprovedStores(){
    return EasySearchBar(


        searchTextStyle: TextStyle(color: blueColHex),
        //foregroundColor: Colors.white,
        searchBackgroundColor: Colors.amber[200],
        //backgroundColor: Colors.blueAccent,
        searchCursorColor: blueColHex,
        searchBackIconTheme: const IconThemeData(color: blueColHex),
        title:  Text('Approved Stores'.tr),

        onSearch: (value) {
          gc.runFilterAccepted(value);
        }
    );
  }
  searchStoresRequests(){
    return EasySearchBar(


        searchTextStyle: TextStyle(color: blueColHex),
        //foregroundColor: Colors.white,
        searchBackgroundColor: Colors.amber[200],
        //backgroundColor: Colors.blueAccent,
        searchCursorColor: blueColHex,
        searchBackIconTheme: const IconThemeData(color: blueColHex),
        title:  Text('Stores Requests'.tr),

        onSearch: (value) {
          gc.runFilterRequests(value);
        }
    );
  }


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 2,
      child: GetBuilder<AdminStoresListCtr>(
        initState: (_) {
          initTab();

        },
        dispose: (_) {
        },
        builder: (ctr) =>  Scaffold(

          appBar:gc.currentTitle==gc.titleList[0]?searchApprovedStores():searchStoresRequests(),
          body: SingleChildScrollView(
            child: Column(
              children: [
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
                  ],
                ),

                if (gc.currentTitle == gc.titleList[0])
                /// stores screen
                  SizedBox(
                    width: width,
                    //height: double.infinity,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: gc.foundStoresAccepted.isNotEmpty
                          ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),

                        shrinkWrap: true,

                        itemCount: gc.foundStoresAccepted.length,
                        itemBuilder: (context, index) => StoreCard(context, gc.foundStoresAccepted[index]),
                      )
                          :  Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            'no stores found'.tr,
                            style:const TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (gc.currentTitle == gc.titleList[1])
                /// users screen
                  SizedBox(
                    width: width,
                    //height: double.infinity,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: gc.foundStoresRequests.isNotEmpty
                          ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: gc.foundStoresRequests.length,
                        itemBuilder: (context, index) => StoreCard(context, gc.foundStoresRequests[index]),
                      )
                          :  Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            'no stores found'.tr,
                            style:const TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
