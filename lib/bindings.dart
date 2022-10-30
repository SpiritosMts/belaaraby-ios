
import 'package:belaaraby/Home/admin/adminHome/adminHomeCtr.dart';
import 'package:belaaraby/Home/news/addNews/addPostDialog/addPostCtr.dart';
import 'package:belaaraby/Home/news/addNews/addVideoDialog/addVideoCtr.dart';
import 'package:belaaraby/Home/news/newsCtr.dart';
import 'package:belaaraby/Home/news/readNews/readPosts/readPostCtr.dart';
import 'package:belaaraby/Home/news/readNews/readVideos/readVideoCtr.dart';
import 'package:belaaraby/Home/selectedStore/selectedStCtr.dart';
import 'package:belaaraby/addEditStore/components/productsPicker/addCateg/addCategDialog/addCategCtr.dart';
import 'package:belaaraby/addEditStore/components/productsPicker/addCateg/categ/categCtr.dart';
import 'package:belaaraby/addEditStore/components/productsPicker/addCateg/updateCategDialog/updateCategCtr.dart';
import 'package:belaaraby/addEditStore/components/productsPicker/addItem/addItemDialog/addItemCtr.dart';
import 'package:belaaraby/tutoCtr.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belaaraby/Home/homeCtr.dart';


import 'Home/admin/adminStoresList/adminStoresListCtr.dart';
import 'Home/admin/adminUsersList/adminUsersListCtr.dart';
import 'Home/news/ads/addAdsCtr.dart';
import 'addEditStore/addStore/addStoreCtr.dart';
import 'addEditStore/components/imagePicker/imageCtr.dart';
import 'addEditStore/components/mapNoAddrPicker/mapCtr.dart';
import 'addEditStore/components/productsPicker/addItem/item/itemCtr.dart';
import 'addEditStore/components/productsPicker/addItem/updateItemDialog/updateItemCtr.dart';
import 'addEditStore/components/productsPicker/productsCtr.dart';
import 'addEditStore/components/radioPicker/radioCtr.dart';
import 'addEditStore/components/textFields/fieldsCtr.dart';
import 'addEditStore/components/timesPicker/timesCtr.dart';
import 'addEditStore/editStoreInfo/editStoreInfoCtr.dart';
import 'myPacks/firebase/fireBaseAuth.dart';
import 'myPacks/myLocale/myLocaleCtr.dart';
import 'myPacks/myTheme/myThemeCtr.dart';
import 'myPacks/notifications/notificationCtr.dart';

/// use dependencies injectionto keep controller data Saved

///you can make dependencies injection (in view class)
// final HomeCtr controller = Get.put<HomeCtr>(HomeCtr());
///you can make dependencies injection (in binding class)
// final HomeCtr controller = Get.put<HomeCtr>(HomeCtr());

/// you can just make init to call controller (in view class) // controller data zeroi when view dispose
// GetBuilder<HomeCtr>(
//    init: HomeCtr(),
//     builder: (ctr) {
//       return Container();
//     }),

///  Get.find<HomeCtr>
//    (init the HomeCtr) if used [Get.lazyPut<HomeCtr>(() => HomeCtr());}
//    (call without ini the HomeCtr) if used [Get.put<HomeCtr>(() => HomeCtr());} cz <Get.put> initilized the HomeCtr
//
//
// "HomeCtr" onDelete() called ==> zeroi HomeCtr
// "HomeCtr" delete from memory called ==> delete HomeCtr (should call put again)
////    //  Get.put<HomeCtr>(HomeCtr(),permanent: true); // dont zeroi ctr data with (permanent: true)
class GetxBinding implements Bindings {
  @override
  void dependencies() {


    ///auth
    Get.put(AuthController());
    //tuto
    Get.lazyPut<TutoController>(() => TutoController(),fenix: true);

    //add edit store
    Get.lazyPut<AddStoreCtr>(() => AddStoreCtr(),fenix: true);
    Get.lazyPut<EditStoreInfoCtr>(() => EditStoreInfoCtr(),fenix: true);
    //notif
    Get.lazyPut<MyNotifCtr>(() => MyNotifCtr(),fenix: true);

    //user
    Get.lazyPut<HomeCtr>(() => HomeCtr(),fenix: true);
    Get.lazyPut<SelectedStCtr>(() => SelectedStCtr(),fenix: true);

    //admin
    Get.lazyPut<AdminStoresListCtr>(() => AdminStoresListCtr(),fenix: true);
    Get.lazyPut<AdminUsersListCtr>(() => AdminUsersListCtr(),fenix: true);
    Get.lazyPut<AdminHomeCtr>(() => AdminHomeCtr(),fenix: true);

    //news
    Get.lazyPut<NewsCtr>(() => NewsCtr(),fenix: true);
    Get.lazyPut<AddPostCtr>(() => AddPostCtr(),fenix: true);
    Get.lazyPut<AddVideoCtr>(() => AddVideoCtr(),fenix: true);
    Get.lazyPut<ReadPostCtr>(() => ReadPostCtr(),fenix: true);
    Get.lazyPut<ReadVideoCtr>(() => ReadVideoCtr(),fenix: true);
    //add ads
    Get.lazyPut<AddAdsCtr>(() => AddAdsCtr(),fenix: true);



    //formular components
    Get.lazyPut<TextFieldsCtr>(() => TextFieldsCtr(),fenix: true);
    Get.lazyPut<MapPickerCtr>(() => MapPickerCtr(),fenix: true);
    Get.lazyPut<ImagePickerCtr>(() => ImagePickerCtr(),fenix: true);
    Get.lazyPut<TimesPickerCtr>(() => TimesPickerCtr(),fenix: true);
    Get.lazyPut<RadioPickerCtr>(() => RadioPickerCtr(),fenix: true);

    //prod
    Get.lazyPut<ProductsCtr>(() => ProductsCtr(),fenix: true);

    Get.lazyPut<AddCategCtr>(() => AddCategCtr(),fenix: true);
    Get.lazyPut<CategCtr>(() => CategCtr(),fenix: true);
    Get.lazyPut<AddItemCtr>(() => AddItemCtr(),fenix: true);
    Get.lazyPut<ItemCtr>(() => ItemCtr(),fenix: true);
    Get.lazyPut<UpdateItemCtr>(() => UpdateItemCtr(),fenix: true);
    Get.lazyPut<UpdateCategCtr>(() => UpdateCategCtr(),fenix: true);



    print('## getx dependency injection completed');

  }
}