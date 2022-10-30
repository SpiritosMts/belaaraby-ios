



import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:belaaraby/Home/selectedStore/categ/categViewRo.dart';
import 'package:belaaraby/Home/selectedStore/categ/itemViewRo.dart';
import 'package:belaaraby/addEditStore/components/productsPicker/addCateg/categ/categCtr.dart';
import 'package:belaaraby/addEditStore/components/productsPicker/addCateg/categ/categView.dart';
import 'package:belaaraby/addEditStore/components/productsPicker/addItem/item/itemView.dart';
import 'package:belaaraby/addEditStore/components/productsPicker/productsCtr.dart';
import 'package:belaaraby/models/itemModel.dart';
import 'package:belaaraby/models/storeModel.dart';
import 'package:belaaraby/myPacks/firebase/fireBase.dart';
import 'package:belaaraby/myPacks/mapVoids.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
double abrSize = 13;

List<String> abr = [
  'mo',
  'tu',
  'we',
  'th',
  'fr',
  'sa',
  'su',
];
 List<String>  currencies = [
  'euro',
  'Turkey Lira',
  'dollar',
  'Albania Lek',
  'Bulgaria Lev',
  'Convertible Mark',
  'Croatia Kuna',
  'Czech Republic Koruna',
  'Denmark Krone',
  'Hungary Forint',
  'Macedonia Denar',
  'Romania Leu',
  'Poland Zloty',
  'Serbia Dinar',
  'Switzerland Franc',
  'Ukraine Hryvnia',
  'Belarus Ruble',
];

 String currencySymbol(curr) {

   if(curr == currencies[0]){
     return '€';
   }
   else if( curr == currencies[1]){
     return 'TRY';
   }
   else if( curr == currencies[2]){
     return '\$';

   }
   else if( curr == currencies[3]){
     return 'Lek';

   }
   else if( curr == currencies[4]){
     return 'лв';

   }
   else if( curr == currencies[5]){
     return 'KM';

   }
   else if( curr == currencies[6]){
     return 'kn';

   }
   else if( curr == currencies[7]){
     return 'Kč';

   }
   else if( curr == currencies[8]){
     return 'kr';

   }
   else if( curr == currencies[9]){
     return 'Ft';

   }
   else if( curr == currencies[10]){
     return 'ден';

   }
   else if( curr == currencies[11]){
     return 'lei';

   }
   else if( curr == currencies[12]){
     return 'PLN';

   }
   else if( curr == currencies[13]){
     return 'Дин';

   }
   else if( curr == currencies[14]){
     return 'CHF';

   }
   else if( curr == currencies[15]){
     return 'UAH';

   }
   else if( curr == currencies[16]){
     return 'Br';

   }


   print('## cant symbolize currency');
return '€';

}

///item_info
itemInfo(Item item){
  return SingleChildScrollView(
    child: Column(
        children: [
          //item_img
          SizedBox(
            width: 100.w,
            height: 250,
            child: item.imageUrl != ''
                ? Image.network(
              item.imageUrl!,
              fit: BoxFit.cover,
            )
                : Image.asset(
              'assets/noImage.jpg',
              fit: BoxFit.cover,
            ),
          ),
          //item_name/price
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(item.name!,
                        style: GoogleFonts.almarai(
                          textStyle: TextStyle(fontSize: 27.sp),
                        )),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${item.price} ${currencySymbol(item.currency)}",
                            style: GoogleFonts.almarai(
                                textStyle: TextStyle(fontSize: 21.sp),
                                decoration: (item.promoted == 'true' && item.newPrice != '') ? TextDecoration.lineThrough : null)),
                        if (item.promoted == 'true' && item.newPrice != '')
                          Text("${item.newPrice} ${currencySymbol(item.currency)}", style: GoogleFonts.almarai(textStyle: TextStyle(fontSize: 24.sp), color: yellowColHex)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          //item_desc
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    child: Text(item.desc!,
                        textAlign: TextAlign.start,
                        style: GoogleFonts.almarai(
                          textStyle: TextStyle(fontSize: 22.sp),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
  );
}

Item itemFromMap(itemMap){
  return Item(
    name: itemMap['name'],
    price: itemMap['price'],
    newPrice: itemMap['newPrice'],
    desc: itemMap['desc'],
    imageUrl: itemMap['imageUrl'],
    categ: itemMap['categ'],
    promoted: itemMap['promoted'],
    currency: itemMap['currency'],
  );
}

String noWork ='--:--';
/// isOpen
bool isOpen(Store st) {

  List<bool> openDays = [];
  Map openDaysData = {};
  Map openHoursData = {};

  openDaysData = mapToString(st.openDays!);
  openHoursData = mapToString(st.openHours!);
  openDays = [
    openDaysData['mo'] == 'true',
    openDaysData['tu'] == 'true',
    openDaysData['we'] == 'true',
    openDaysData['th'] == 'true',
    openDaysData['fr'] == 'true',
    openDaysData['sa'] == 'true',
    openDaysData['su'] == 'true',
  ];


  var today = DateTime.now();

  for (int i = 1; i <= 7; i++) {
    if (today.weekday == i) {
      //if st opening in this day of week
      if (openDays[i - 1]) {
        String formattedTodayDate = DateFormat('yyyy-MM-dd').format(today);

        String? openData = openHoursData['${abr[i - 1]}_o'];
        String? closeData = openHoursData['${abr[i - 1]}_c'];

        DateTime openTime = DateTime.parse('$formattedTodayDate $openData:00');
        DateTime closeTime = DateTime.parse('$formattedTodayDate $closeData:00');

        var opening = (today.isBefore(closeTime) && today.isAfter(openTime));
        return opening;
      }
    }
  }
  return false;
}

///Shcedule
showShcedule( ctx,Store st) {
  Map openHoursData = {};
  openHoursData = mapToString(st.openHours!);
  Map openDaysData = {};

  List<bool> openDays = [];

  openDaysData = mapToString(st.openDays!);
  openDays = [
    openDaysData['mo'] == 'true',
    openDaysData['tu'] == 'true',
    openDaysData['we'] == 'true',
    openDaysData['th'] == 'true',
    openDaysData['fr'] == 'true',
    openDaysData['sa'] == 'true',
    openDaysData['su'] == 'true',
  ];

  double _width = MediaQuery.of(ctx).size.width;
  double _height = MediaQuery.of(ctx).size.height;

  return AwesomeDialog(
    dialogBackgroundColor: blueColHex2,

    isDense: false,
    dismissOnBackKeyPress: true,
    context: ctx,
    dismissOnTouchOutside: true,
    animType: AnimType.SCALE,
    headerAnimationLoop: false,
    dialogType: DialogType.INFO,
    body: Flexible(
      child: Container(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0, top: 15.0),
        width: MediaQuery.of(ctx).size.width,
        child: Column(
          children: [
            Text(
              'Work Times'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
            const SizedBox(height: 14.0),
            Container(
              //padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: DataTable(
                decoration: BoxDecoration(),
                //checkboxHorizontalMargin: 20,
                columnSpacing: _width * 0.08,
                dataRowHeight: 40,
                //horizontalMargin: 20,
                columns:  [
                  const DataColumn(label: Text('', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Opening'.tr, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Closing'.tr, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold))),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('Mon'.tr, style: TextStyle(fontSize: abrSize, fontWeight: FontWeight.bold))),
                    DataCell(Center(child: Text(openDays[0]? openHoursData['${abr[0]}_o']:noWork))),
                    DataCell(Center(child: Text(openDays[0]? openHoursData['${abr[0]}_c']:noWork))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Tue'.tr, style: TextStyle(fontSize: abrSize, fontWeight: FontWeight.bold))),
                    DataCell(Center(child: Text(openDays[1]? openHoursData['${abr[1]}_o']:noWork))),
                    DataCell(Center(child: Text(openDays[1]? openHoursData['${abr[1]}_c']:noWork))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Wed'.tr, style: TextStyle(fontSize: abrSize, fontWeight: FontWeight.bold))),
                    DataCell(Center(child: Text(openDays[2]? openHoursData['${abr[2]}_o']:noWork))),
                    DataCell(Center(child: Text(openDays[2]? openHoursData['${abr[2]}_c']:noWork))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Thu'.tr, style: TextStyle(fontSize: abrSize, fontWeight: FontWeight.bold))),
                    DataCell(Center(child: Text(openDays[3]? openHoursData['${abr[3]}_o']:noWork))),
                    DataCell(Center(child: Text(openDays[3]? openHoursData['${abr[3]}_c']:noWork))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Fri'.tr, style: TextStyle(fontSize: abrSize, fontWeight: FontWeight.bold))),
                    DataCell(Center(child: Text(openDays[4]? openHoursData['${abr[4]}_o']:noWork))),
                    DataCell(Center(child: Text(openDays[4]? openHoursData['${abr[4]}_c']:noWork))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Sat'.tr, style: TextStyle(fontSize: abrSize, fontWeight: FontWeight.bold))),
                    DataCell(Center(child: Text(openDays[5]? openHoursData['${abr[5]}_o']:noWork))),
                    DataCell(Center(child: Text(openDays[5]? openHoursData['${abr[5]}_c']:noWork))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Sun'.tr, style: TextStyle(fontSize: abrSize, fontWeight: FontWeight.bold))),
                    DataCell(Center(child: Text(openDays[6]?  openHoursData['${abr[6]}_o']:noWork))),
                    DataCell(Center(child: Text(openDays[6]? openHoursData['${abr[6]}_c']:noWork))),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  ).show();
}


///ratingBox
ratingBox(storeID) {
  return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
    future: storesColl.doc(storeID).get(),
    builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      if (snapshot.hasData) {
        //update();
        var oneStore = snapshot.data!;
        String stars = oneStore.get('stars');
        String raterCount = oneStore.get('raterCount');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ///rating
            Row(
              children: [
                Text(stars, style: const TextStyle(fontSize: 20)),
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 30,
                ),
              ],
            ), //star
            const SizedBox(
              height: 5,
            ),
            ///raters
            Row(
              children: [
                const Icon(Icons.person, color: Colors.white70, size: 15), //person

                Text("($raterCount)", style: const TextStyle(fontSize: 14)),
              ],
            ),
          ],
        );
      } else {
        // no rating (loading)
        //return const CircularProgressIndicator();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ///rating
            Row(
              children:const [
                Text('X,X', style:  TextStyle(fontSize: 20)),
                Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 30,
                ),
              ],
            ), //star
            const SizedBox(
              height: 5,
            ),
            ///raters
            Row(
              children:const [
                Icon(Icons.person, size: 15), //person

                Text("(X)", style:  TextStyle( fontSize: 14)),
              ],
            ),
          ],
        );
      }
    },
  );
}


///comments box
futureCommentBox(storeID) {
  return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
    future: storesColl.doc(storeID).get(),
    builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      if (snapshot.hasData) {
        //update();

        if (snapshot.hasError) {
          return const Text("");
        }

        if ((snapshot.hasData) && (!snapshot.data!.exists)) {
          return const Text("");
        }

        var oneStore = snapshot.data!;
        Map<String, dynamic> _raters = oneStore.get('raters');
        //return Text('snapshot has data');
        if(_raters.isNotEmpty){
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
            shrinkWrap: true,
            itemCount: _raters.length,
            itemBuilder: (BuildContext context, int index) {
              String key = _raters.keys.elementAt(index);

              /// single_Comment
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      // rater_name
                      title: Text(
                        key,
                        style: GoogleFonts.almarai(
                          fontSize: 19.sp,
                          color: hintYellowColHex3
                        ),
                      ),

                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          // rate_stars
                          RatingBarIndicator(
                            unratedColor: Colors.white24,

                            itemPadding:const EdgeInsets.symmetric(horizontal: 0),
                            rating: double.parse(_raters[key]['stars']),
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 15.0,
                            direction: Axis.horizontal,
                          ),
                          const SizedBox(height: 1),
                          // rater_comment
                          Text("${_raters[key]['comment']}",
                          style: GoogleFonts.almarai(
                            height: 1.4,
                            fontSize: 16.sp
                          ),
                          ),
                         const SizedBox(height: 3,)
                        ],
                      ),
                    ),
                    const Divider(
                      height: 2.0,
                    ),
                  ],
                ),
              );
            },
          );

        }else{
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Text(
                'no comments yet'.tr,
                textAlign: TextAlign.start,
                style: GoogleFonts.almarai(
                  fontSize: 17,

                ),
              ),
            ),
          );
        }
      } else {
        return const Text('');
      }
    },
  );
}




deleteStoreDialog(ctx,Store st){
  MyVoids().shownoHeader(ctx, txt: '${'are you sure you want to delete this store'.tr}\n"${st.name}" ؟ ').then((value) {
    if (value) {
      deleteStore(st,shouldBack: true);
    }
  });
}

deleteStore(Store st,{bool shouldBack =false}){
  /// delete store from coll
  storesColl.doc(st.id).delete().then((value) async {
    MyVoids().showTos('Store deleted'.tr);
    if(shouldBack)    Get.back();
    /// delete all images
    getImagesUrls(st,getAndDelete: true);
    /// delete store from users garages IDs
    removeElementsFromList([st.id],'stores',st.ownerID!,usersCollName).then((value) => authCtr.refreshCuser());




  }).catchError((error) => print("Failed to delete store: $error"));

}

declineStore(ctx,id) {
  MyVoids().shownoHeader(ctx, txt: 'are you sure you want to decline this store?'.tr,btnOkText: 'decline').then((value) {
    if (value) {
      /// decline store from coll
      storesColl.doc(id).update({
        'accepted':'no'
      }).then((value) async {
        MyVoids().showTos('Store declined'.tr);

        Get.back();

      }).catchError((error) => print("Failed to decline store: $error"));
    }
  });
}
approveStore(id) {
 
  /// approve store from coll
  storesColl.doc(id).update({
    'accepted':'yes'
  }).then((value) async {
    MyVoids().showTos('Store approved'.tr);

    Get.back();

  }).catchError((error) => print("Failed to approve store: $error"));
}

getImagesUrls(Store st,{bool getAndDelete=false})  {
  List<String> allItemsUrls =[];
  String logoUrl ='';
  List<String> imagesUrls =[];

  logoUrl = st.logo!;
  imagesUrls =st.images!;
  for (Map<String, dynamic> categ in st.categories!.values) {
    for (var item in categ.values) {
      allItemsUrls.add(item['imageUrl']);
    }
  }
  print('## store <${st.name}> has <${allItemsUrls.length}> item image');
  print('## store <${st.name}> has <${imagesUrls.length}> store image');
  print('## store <${st.name}> ${logoUrl!=''? 'DO':'D\'ONT'} has logo image');

  if(getAndDelete){



    if(allItemsUrls.isNotEmpty){
      for(var imgUrl in allItemsUrls){
        deleteFileByUrlFromStorage(imgUrl);
      }
    }
    if(imagesUrls.isNotEmpty){
      for(var imgUrl in imagesUrls){
        deleteFileByUrlFromStorage(imgUrl);
      }
    }

    if(logoUrl!=''){
      deleteFileByUrlFromStorage(logoUrl);
    }




  }


}

//marker widget icon
customMarkerImg(String logoUrl, String accepted, String jobType,String stName) {
  double markerH = 35.0;
  return Column(
    children: [
      ///store name
      Container(
          decoration: BoxDecoration(
            color: blueColHex.withOpacity(.6),
            borderRadius: BorderRadius.circular(10),
            //border: Border.all(color: blueColHex,width: .5)
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 3.0,top: 2.0,right: 5.0,left: 5.0),
            child: Text(  stName.length > 10 ? '${stName.substring(0, 10)}...' : stName,

              style: GoogleFonts.almarai(
                  textStyle:  TextStyle(
                      fontSize: 15.sp),
                  color: yellowColHex
              ),
            ),
          )
      ),
      ///store marker
      Stack(
        children: [
          ///marker
          Container(
               height: markerH.sp,

              child: FittedBox(
                child: Icon(
                  Icons.add_location,
                  color: accepted == 'yes' ? yellowColHex : Colors.redAccent,
                  //size: ,
                ),
              ),
            ),
          ///logo
          Positioned(
            // height: 8.5.h,
            // left: 5.7.w,
            // top: 1.6.h,

            // left: (markerH* 1.8).sp,
            // top: (markerH* 2.5).sp,
            left: markerH * 0.46,
            top: markerH * 0.25,
            child: Container(

              decoration: BoxDecoration(color: blueColHex2, borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: (logoUrl != '' && showMarkerLogo)
                    ? CircleAvatar(
                  radius: 35.0,
                  backgroundColor: Colors.white,
                  foregroundImage: NetworkImage(logoUrl),
                )
                // no logo
                    : SizedBox(

                    child: jobTypeIcon(jobType,(markerH * 0.7).sp)),
              ),
            ),
          ),

        ],
      ),
    ],
  );
}


Map<String, Store> getStoreModelData(List<DocumentSnapshot> storesData){
  Map<String, Store> storeMap = {};

  //fill store map
  for (var doc in storesData) {
    List<String> images = listDynamicToString(doc.get('images'));
    bool showLogo = doc.get('showLogo');

    String logo = showLogo ? doc.get('logo') : '';
    GeoPoint pos = doc.get('coords');
    // fill stores products
    Map<String, dynamic> promos = doc.get("promo");
    Map<String, dynamic> categories = doc.get("categories");
    Map<String, dynamic> categImages = doc.get("categImages");
    List<String> allItemsList = [];
    for (Map<String, dynamic> categ in categories.values) {
      for (var item in categ.keys) {
        allItemsList.add(item.toString());
      }
    }
    //fill storeMap
    storeMap[doc.id] = Store(
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
      stars: doc.get('stars'),
      raterCount: doc.get('raterCount'),
      //
      accepted: doc.get('accepted'),
      showLogo: doc.get('showLogo'),
      //raters: not-to-use-here
    );
  }

  return storeMap;
}

headerLogo(logo,jobType) {
  double size = 85.0;
  double containerSize = 110.0;
  double borderWidth = 1.0;
  return Stack(
    //alignment: Alignment.bottomCenter,

    children: [
      ///logo
      Positioned(
        child: Container(
          width: containerSize,
          height: containerSize,
          decoration: BoxDecoration(
            color: yellowColHex.withOpacity(.3),
            borderRadius: BorderRadius.circular(90),
            border: Border.all(color: yellowColHex, width: borderWidth, style: BorderStyle.solid),
          ),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: CircleAvatar(
              radius: 80.0,
              backgroundColor: blueColHex,
              child: ( logo != '' && showMarkerLogo)? storeLogo(logo,size):jobTypeIcon(jobType,size),
              // foregroundImage: ( gc.st.logo! != '' && showMarkerLogo)? NetworkImage( gc.st.logo!):jobTypeIcon(gc.st.jobType!),
            ),
          ),
        ),
      ),
     ///text
     Positioned(
       left: 10,
       right: 10,
       //top: 85,
       bottom: 0,


       child: Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: Container(
              // constraints: BoxConstraints(
              //   maxWidth: 50,
              // ),

              padding: EdgeInsets.only(bottom:4,top: 4),
              decoration: BoxDecoration(
                color: blueColHex,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: yellowColHex, width: borderWidth, style: BorderStyle.solid),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child:    Text(
                       jobType,
                        textHeightBehavior: TextHeightBehavior(

                        ),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.almarai(
                          textStyle: const TextStyle(
                              color: yellowColHex,
                              fontSize: 11,
                              fontWeight: FontWeight.w600
                          ),
                        )),
                  ),
                ),
              ),
            ),
          ),
       ),


    ],
  );
}

///grid card
double gridCardWidth = 50;
double gridCardHeight = 17;


itemGridCard(Item item, gc,{bool ro =false}) {
  return GestureDetector(
    onTap: () {
      gc.selectItem(item);
      if(ro){
        Get.to(() => ItemViewRo());

      }else{
        Get.to(() => ItemView());

      }

    },
    child: Stack(
      children: [
        SizedBox(
          width: 50.w,
          height: 27.h,
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Card(
              color: blueColHex2,

              margin: const EdgeInsets.all(5.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              shadowColor: Colors.white24,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0.0,top: 0.0),
                child: SizedBox(
                  child: Center(
                    child: Column(


                      children: [
                        //image
                        Container(
                          padding:const EdgeInsets.only(bottom: 7),
                          decoration:const BoxDecoration(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(15),bottom: Radius.circular(15)),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(15),bottom: Radius.circular(8)),
                            child: SizedBox(
                              width: 50.w,
                              height: 19.h,
                              child: FittedBox(
                                fit: BoxFit.cover,

                                //size: Size.fromRadius(30),
                                child: item.imageUrl! != ''
                                    ? Image.network(
                                  item.imageUrl!,
                                )
                                    : Image.asset('assets/noImage.jpg',

                                ),
                              ),
                            ),
                          ),
                        ),
                        //name - price
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 10.0,vertical:item.promoted=='true'? 0.0:8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // item_name
                              Flexible(
                                child: Text(

                                  item.name!,
                                  overflow: TextOverflow.ellipsis,

                                  maxLines: 1,
                                  style: GoogleFonts.almarai(
                                    textStyle: const TextStyle(fontWeight: FontWeight.w600),
                                    fontSize: 17.sp
                                  ),
                                ),
                              ),

                              // item_price
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${item.price} ${currencySymbol(item.currency)}",
                                    style: GoogleFonts.almarai(
                                      decoration: (item.promoted == 'true' && item.newPrice != '') ?
                                      TextDecoration.lineThrough : null,
                                      fontSize: 16.sp,

                                    ),
                                  ),

                                  if (item.promoted == 'true' && item.newPrice != '')
                                    Text(
                                      "${item.newPrice} ${currencySymbol(item.currency)}",
                                      style:  TextStyle(
                                        fontSize: 17.sp,
                                        color: yellowColHex,
                                      ),
                                    ),

                                ],
                              ),
                            ],
                          ),
                        ),
                      ],

                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        if (item.promoted == 'true')
          Positioned(
              top: 0,
              right: currLang == 'en' ? -1 : null,
              left: currLang == 'ar' ? -1 : null,
              child: Image.asset(height: 9.w, width: 9.w, 'assets/promo.png')),
      ],
    ),
  );
}
categGridCard(categName,categUrl, gc,ctx){

  return GestureDetector(
    onTap: (){
      gc.selectedCategory = categName;
        Get.to(()=>CategView());


    },
    child: Padding(
      padding: const EdgeInsets.all(0.0),
     child: SizedBox(
       width: gridCardWidth.w,
       height: gridCardHeight.h,
       child: Card(
          color: blueColHex2,

          margin: const EdgeInsets.all(5.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),

          child: Padding(
            padding: const EdgeInsets.only(bottom: 0.0,top: 0.0),
            child: SizedBox(
              child: Center(
                child: Column(


                  children: [
                    //image
                    Container(
                      decoration:const BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15),bottom: Radius.circular(15)),
                      ),
                      child: ClipRRect(
                        borderRadius:const  BorderRadius.vertical(top: Radius.circular(15),bottom: Radius.circular(8)),
                        child: SizedBox(
                          width: gridCardWidth.w,
                          height: gridCardHeight.h,
                          child: categUrl != ''
                              ? Image.network(
                            categUrl,
                            fit: BoxFit.cover,
                          )
                              : Image.asset('assets/noImage.jpg',
                            fit: BoxFit.cover,

                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 13,bottom: 4,right: 7,left: 7),
                      child: Text(

                        categName,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                        style: GoogleFonts.almarai(
                          textStyle:GoogleFonts.almarai(
                              fontWeight: FontWeight.w500,
                            //color: yellowColHex,
                            fontSize: 17.sp,
                          ),
                        ),
                      ),
                    )
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

///read only
categCardRoHori(categName,categUrl, gc,ctx,){


  return GestureDetector(
    onTap: (){
      gc.selectedCategory = categName;
        Get.to(()=>CategViewRo());

    },
    child: Padding(
      padding: const EdgeInsets.all(0.0),
     child: SizedBox(
       width: 50.w,
       //height: 20.h,
       child: Card(
          color: blueColHex2,

          margin: const EdgeInsets.all(5.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),

          child: Padding(
            padding: const EdgeInsets.only(bottom: 0.0,top: 0.0),
            child: SizedBox(
              child: Center(
                child: Column(


                  children: [
                    //image
                    Container(
                      decoration:const BoxDecoration(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15),bottom: Radius.circular(15)),
                      ),
                      child: ClipRRect(
                        borderRadius:const  BorderRadius.vertical(top: Radius.circular(15),bottom: Radius.circular(8)),
                        child: SizedBox(
                          width: 50.w,
                          height: 15.h,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            //size: Size.fromRadius(30),
                            child: categUrl != ''
                                ? Image.network(
                              categUrl,

                            )
                                : Image.asset('assets/noImage.jpg',


                            ),
                          ),
                        ),
                      ),
                    ),
                    //categ_name
                    Padding(
                      padding:  EdgeInsets.only(top: 1.5.h,bottom: 1.h,right: 7,left: 7),
                      child: Text(

                        categName,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                          overflow: TextOverflow.ellipsis,

                        style: GoogleFonts.almarai(
                          textStyle:GoogleFonts.almarai(
                              fontWeight: FontWeight.w500,
                            //color: yellowColHex,
                            fontSize: 17.5.sp
                          ),
                        ),
                      ),
                    )
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
itemCardRoHori(Item item, gc) {
  return GestureDetector(
    onTap: () {
      gc.selectItem(item);
      Get.to(() => ItemViewRo());

    },
    child: Stack(
      children: [
        SizedBox(
          width: 50.w,
          //height: 30.h,
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Card(
              color: blueColHex2,

              margin: const EdgeInsets.all(5.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              shadowColor: Colors.white24,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 0.0,top: 0.0),
                child: SizedBox(
                  child: Center(
                    child: Column(


                      children: [
                        //image
                        Container(
                         // padding: EdgeInsets.only(bottom: 1.h),
                          decoration:const BoxDecoration(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(15),bottom: Radius.circular(15)),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(15),bottom: Radius.circular(8)),
                            child: SizedBox(
                              width: 50.w,
                              height: 15.h,
                              child: FittedBox(
                                fit: BoxFit.cover,


                                //size: Size.fromRadius(30),
                                child: item.imageUrl! != ''
                                    ? Image.network(
                                  item.imageUrl!,
                                )
                                    : Image.asset('assets/noImage.jpg',

                                ),
                              ),
                            ),
                          ),
                        ),
                        //name - price
                        Padding(
                         // padding:  EdgeInsets.symmetric(horizontal: 1.h,vertical:item.promoted=='true'? 1.h:3.h),
                          padding:  EdgeInsets.symmetric(horizontal: 1.h,vertical:item.newPrice != '' ? 0.9.h:2.2.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // item_name
                              Flexible(
                                child: Text(
                                  item.name!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: GoogleFonts.almarai(
                                    textStyle:  TextStyle(
                                        fontWeight: FontWeight.w500,
                                      fontSize: 17.sp,
                                    ),
                                  ),
                                ),
                              ),
                              // item_price
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${item.price} ${currencySymbol(item.currency)}",
                                    style: TextStyle(
                                        decoration: (item.promoted == 'true' && item.newPrice != '') ?
                                        TextDecoration.lineThrough : null,
                                      color: Colors.white,
                                      fontSize: 17.sp

                                    ),
                                  ),
                                  if (item.promoted == 'true' && item.newPrice != '')
                                    Text(
                                      "${item.newPrice} ${currencySymbol(item.currency)}",
                                      style:  TextStyle(
                                        color: yellowColHex,
                                          fontSize: 18.sp

                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],

                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (item.promoted == 'true')
          Positioned(
              top: 0,
              right: currLang == 'en' ? -1 : null,
              left: currLang == 'ar' ? -1 : null,
              child: Image.asset(height: 30, width: 30, 'assets/promo.png')),
      ],
    ),
  );
}

