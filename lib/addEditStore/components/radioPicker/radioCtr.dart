import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/widgets.dart' as wig;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/myVoids.dart';
import 'package:belaaraby/myPacks/firebase/fireBase.dart';
import 'package:ionicons/ionicons.dart';

class RadioPickerCtr extends GetxController {
  // Default Radio Button Item
  String radioItem = 'متجر بقالة';

  // Group Value for Radio Button.
  int id = 1;

  onChangeRadio(data, val) {
    radioItem = data.name;
    id = data.index;
    update();
  }

  List<RadioItem> radioList = [
    RadioItem(
      index: 1,
      name: 'متجر بقالة',
    ),
    RadioItem(
      index: 2,
      name: 'مطعم',
    ),
    RadioItem(
      index: 3,
      name: 'حلويات',
    ),
    RadioItem(
      index: 4,
      name: 'تجارة جملة',
    ),
    RadioItem(
      index: 5,
      name: 'سياحة وسفر',
    ),
    RadioItem(
      index: 6,
      name: 'صيدلية',
    ),
    RadioItem(
      index: 7,
      name: 'طبیب',
    ),
    RadioItem(
      index: 8,
      name: 'محامي',
    ),
    RadioItem(
      index: 9,
      name: 'محاسب',
    ),
    RadioItem(
      index: 10,
      name: 'ترجمان',
    ),
    RadioItem(
      index: 11,
      name: 'الكترونيات',
    ),
    RadioItem(
      index: 12,
      name: 'معرض سيارة',
    ),
    RadioItem(
      index: 13,
      name: 'طباعة وتصميم',
    ),
    RadioItem(
      index: 14,
      name: 'حرفة يدوية',
    ),
    RadioItem(
      index: 15,
      name: 'نجار',
    ),
    RadioItem(
      index: 16,
      name: 'حداد',
    ),
    RadioItem(
      index: 17,
      name: 'لحام',
    ),
    RadioItem(
      index: 18,
      name: 'مزارع',
    ),
    RadioItem(
      index: 19,
      name: 'بيطري',
    ),
    RadioItem(
      index: 20,
      name: 'مواد بناء',
    ),
    RadioItem(
      index: 21,
      name: 'صاحب بنك',
    ),
    RadioItem(
      index: 22,
      name: 'صاحب تاكسي',
    ),
    RadioItem(
      index: 23,
      name: 'صيانة',
    ),
    RadioItem(
      index: 24,
      name: 'بائع لحوم',
    ),
    RadioItem(
      index: 25,
      name: 'زراعة',
    ),
    RadioItem(
      index: 26,
      name: 'أساس منزلي',
    ),
    RadioItem(
      index: 27,
      name: 'مكتب توظيف',
    ),
    RadioItem(
      index: 28,
      name: 'تعليم',
    ),
  ];
}

class RadioItem {
  String name;
  int index;

  RadioItem({required this.name, required this.index});
}
