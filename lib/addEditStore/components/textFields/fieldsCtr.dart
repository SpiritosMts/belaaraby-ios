import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';


class TextFieldsCtr extends GetxController {
  GlobalKey<FormState> formKeyCommon = GlobalKey<FormState>(); // common verif
  TextEditingController nameTextController = TextEditingController();//name
  TextEditingController taxTextController = TextEditingController();//ciret
  TextEditingController phoneTextController = TextEditingController();//phone
  TextEditingController jobDescTextController = TextEditingController();//
  TextEditingController addressTextController = TextEditingController();//
  TextEditingController websiteTextController = TextEditingController();//

}
