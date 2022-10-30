import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:belaaraby/myPacks/myConstants.dart';

import '../myPacks/myVoids.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {

  bool visible = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController =  TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _emailFocus.removeListener(_onFocusChange);
    _emailFocus.dispose();
  }

  void _onFocusChange() {
    setState((){});
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Material(
      color: Color(0xFF75b0b5),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: height/40,
                ),
                /// belaaraby Image
                Image.asset(
                  'assets/V.0001.png',
                  fit: BoxFit.cover,
                  width: 250,
                  height: 200,
                ),
                SizedBox(
                  height: height/40,
                ),
                 Center(
                  child: Text(
                    'Send email reset link!'.tr,
                    textAlign: TextAlign.center,
                    style:const TextStyle(
                      fontSize: 21,
                      color: Colors.white54,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Courier',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 32,
                  ),
                  child: Column(
                    children: [
                      /// email forgot pass
                      Form(
                        key: _formkey,
                        child: TextFormField(
                          textInputAction: TextInputAction.done,

                          //textAlign: TextAlign.left,
                          controller: emailController,
                          onSaved: (value) {
                            emailController.text = value!;
                          },
                          focusNode: _emailFocus,

                          onEditingComplete: () {
                            fieldUnfocusAll();
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(

                            icon: Icon(Icons.email , color: _emailFocus.hasFocus?yellowCol:disabledIconCol),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            labelText: 'Email'.tr,
                            contentPadding: const EdgeInsets.only(bottom: 15),
                            hintStyle:const TextStyle(
                                fontSize: 13
                            ),
                            hintText: 'Enter your email'.tr,

                          ),
                          validator: (value) {
                            RegExp regex = RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]");

                            if (value!.isEmpty) {
                              return "email can\'t be empty".tr;
                            }

                            if (!regex.hasMatch(value)) {
                              return ("Enter a valid email".tr);
                            } else {
                              return null;
                            }
                          },
                        ),

                      ),
                      SizedBox(
                        height: height/20,
                      ),
                      /// send btn
                      TextButton.icon(
                        onPressed: (() {
                            if (_formkey.currentState!.validate()) {
                              authCtr.ResetPss(emailController.text, context);
                            }
                        }),
                        icon: const Icon(
                          Icons.read_more,
                          size: 28,
                        ),
                        label: Container(
                          alignment: Alignment.center,
                          width: 150,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Color(0xFF1b3a4b),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child:  Text(
                            'Send'.tr,
                            style:const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height/80,
                      ),
                      /// back
                      TextButton.icon(
                        onPressed: (() {
                          Get.back();

                        }),
                        icon: const Icon(
                          Icons.home,
                          size: 28,
                        ),
                        label: Container(
                          alignment: Alignment.center,
                          width: 150,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Color(0xFF1b3a4b),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child:  Text(
                            'Back'.tr,
                            style:const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
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
