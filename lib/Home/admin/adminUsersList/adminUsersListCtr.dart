import 'package:belaaraby/Home/admin/adminHome/adminHomeCtr.dart';
import 'package:belaaraby/models/brUserModel.dart';
import 'package:belaaraby/models/storeModel.dart';
import 'package:belaaraby/myPacks/firebase/fireBase.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:belaaraby/myPacks/storeVoids.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminUsersListCtr extends GetxController {

  Map swicherMap ={};

  Map<String, BrUser> userMap = {};
  Map<String, Store> storeMap = Get.find<AdminHomeCtr>().storeMap;
  List<BrUser> userList = [];
  List<BrUser> foundUsersList = [];
  final TextEditingController typeAheadController = TextEditingController();
  bool shouldLoad =true;


  onChangeAdmin(val,userId,ctx){
  swicherMap[userId]=val;
  update();
  if(val==true){
    MyVoids().shownoHeader(ctx, txt: 'are you sure you want to give this user full control'.tr,btnOkText: 'Yes',btnOkColor: Colors.green).then((value) {
      if (value) {
        /// decline store from coll
        usersColl.doc(userId).update({
          'isAdmin':swicherMap[userId]
        }).then((value) async {
          MyVoids().showTos('New Admin Added'.tr);

        }).catchError((error) => print("Failed to add admin: $error"));
      }
    });
  }
  else{
    usersColl.doc(userId).update({
      'isAdmin':swicherMap[userId]
    }).then((value) async {
      MyVoids().showTos('Admin removed'.tr);


    }).catchError((error) => print("Failed to remove admin: $error"));
  }

  }
  bool typing = false;
  @override
  void onInit() {
    super.onInit();
    print('## init AdminUsersListCtr');
    Future.delayed(const Duration(seconds: 0), () {
      getUsersData(printDet: true);
    });
  }



  getUsersData({bool printDet = false}) async {
    if (printDet) print('## downloading users from fireBase...');
    List<DocumentSnapshot> usersData =await getDocumentsByColl(usersColl);

    // Remove any existing users
    userMap.clear();

    //fill user map
    for (var _user in usersData) {

      //fill userMap
      userMap[_user.id] = BrUser(
        name: _user['name'],
        email: _user['email'],
        joinDate: _user['joinDate'],
        stores: _user['stores'],
        isAdmin: _user['isAdmin'],
        id: _user['id'],
        pwd: _user['pwd'],
        verified: _user['verified'],

      );
    }

    userList = userMap.entries.map( (entry) => entry.value).toList();
    foundUsersList = userList;
    shouldLoad=false;
    if (printDet) print('## < ${userMap.length} > users loaded from database');
    update();

  }

  void runFilterList(String enteredKeyword) {
    List<BrUser>? results = [];

    if (enteredKeyword.isEmpty) {
      results = userList;
    } else {
      results = userList.where((user) => user.email!.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
    }

    foundUsersList = results;
    update();

  }



  clearSelectedProduct() async {
    typeAheadController.clear();
    appBarTyping(false);
    update();
  }
  appBarTyping(typ) {
    typing = typ;
    update();
  }


  deleteUser(ctx,BrUser user){
    MyVoids().shownoHeader(ctx, txt: '${'are you sure you want to remove this user'.tr}\n"${user.name}" ${'with his stores'.tr} ؟ ',).then((value) {
      if (value) {
        /// delete user from coll
        usersColl.doc(user.id).delete().then((value) async {
          MyVoids().showTos('User removed'.tr);
          /// delete user from auth
          authCtr.deleteUserFromAuth(user.email,user.pwd);
          /// delete user's stores from coll

          for(var storeID in user.stores!){
            deleteStore(storeMap[storeID]!);
          }

          getUsersData(printDet: true);




        }).catchError((error) => print("Failed to delete user: $error"));
      }
    });
  }
}