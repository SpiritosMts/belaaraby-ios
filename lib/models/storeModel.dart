import 'package:belaaraby/models/itemModel.dart';
import 'package:flutter/foundation.dart';

class Store {
  String? id;
  //common
  String? name;
  String? phone;
  String? tax;
  String? website;
  String? address;
  String? jobDesc;
  double? latitude;
  double? longitude;
  Map<String,dynamic>? promos;
  Map<String,dynamic>? categories;
  Map<String,dynamic>? categImages;
  //times
  Map<String, dynamic>? openDays;
  Map<String, dynamic>? openHours;
  //jobType
  String? jobType;
  //images
  String? logo;
  List<String>? images;
  //owner
  String? ownerID;
  String? ownerName;
  String? ownerEmail;
  //rating
  Map<String, dynamic>? raters;
  String? stars;
  String? raterCount;
  //
  String? accepted;
  bool? showLogo;
  //
  List<String> allItemsList=const[];

  Store({
    this.id,
    this.ownerID,
    this.ownerName,
    this.ownerEmail,
    this.name,
    this.tax,
    this.website,
    this.jobDesc,
    this.phone,
    this.logo,
    this.images,
    this.accepted,
    this.jobType,
    this.openHours,
    this.openDays,
    this.latitude,
    this.longitude,
    this.address,
    this.raterCount,
    this.stars,
    this.raters,
    this.showLogo,
    this.promos,
    this.categories,
    this.categImages,
    this.allItemsList=const[],
  });
}
