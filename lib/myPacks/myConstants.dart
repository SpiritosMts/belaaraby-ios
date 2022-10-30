import 'package:belaaraby/Home/admin/adminHome/adminHomeView.dart';
import 'package:belaaraby/Home/homeView.dart';
import 'package:belaaraby/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firebase/fireBaseAuth.dart';
const CameraPosition belgiumPos = CameraPosition(target: LatLng( 51.260197, 4.402771), zoom: 10.0);


double animateZoom = 16.0;


var storesColl = FirebaseFirestore.instance.collection('stores');
var postsColl = FirebaseFirestore.instance.collection('posts');
var videosColl = FirebaseFirestore.instance.collection('videos');
var usersColl = FirebaseFirestore.instance.collection('br_users');
var testColl = FirebaseFirestore.instance.collection('testColl');
var adsColl = FirebaseFirestore.instance.collection('ads');
String usersCollName = 'br_users';
bool shouldNotVerifyInputs = false;
bool shouldVerifyAccount = true;
bool showMarkerLogo = true;
double storeLogoSize =25.0;
double btmPaddingInput =5.0;
double btmPaddingInputPrc =0.0;
String? get currLang => Get.locale!.languageCode;
  goToHomePage(){
    Get.offAll(()=> authCtr.cUser.isAdmin? AdminStoresMapView():StoresMapView());
 }

double defaultStarsNum = 3.0;

bool ownerCanRateOthers=true;

AuthController authCtr = AuthController.instance;
int refreshVerifInSec =5;
final Future<FirebaseApp> firebaseInitialization = Firebase.initializeApp();
FirebaseAuth auth = FirebaseAuth.instance;
User? get authCurrUser => FirebaseAuth.instance.currentUser;
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
GoogleSignIn googleSign = GoogleSignIn();