
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:belaaraby/Home/homeView.dart';
import 'package:belaaraby/auth/login_screen.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:belaaraby/myPacks/firebase/fireBase.dart';
import 'package:belaaraby/myPacks/myVoids.dart';

import 'verifyEmail.dart';


class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isObscure0 = true;
  bool _isObscure1 = true;

  int nameMaxLength = 15;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  signUp(){
    if (_formkey.currentState!.validate()) {
      MyVoids().showLoading(context);

      authCtr.signup(
          emailController.text,
          passwordController.text,
          context,
          onSignUp: (){
            /// add user to cloud
            addDocument(
                fieldsMap: {
                  'name': nameController.text,
                  'email': emailController.text,
                  'pwd': passwordController.text,
                  'joinDate': todayToString(),
                  'isAdmin': false,
                  'verified':false,
                  'currency': 'euro',
                  'stores': [],
                },
                collName: usersCollName

            );
           // should verify

              MyVoids().showTos('Verify your account'.tr);
              Get.to(()=>VerifyScreen());


          }
      );
     // Get.back();
    }
  }

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _pwdFocus = FocusNode();
  @override
  void initState() {

    super.initState();
    _nameFocus.addListener(_onFocusChange);
    _emailFocus.addListener(_onFocusChange);
    _pwdFocus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _nameFocus.removeListener(_onFocusChange);
    _emailFocus.removeListener(_onFocusChange);
    _pwdFocus.removeListener(_onFocusChange);
    _nameFocus.dispose();
    _emailFocus.dispose();
    _pwdFocus.dispose();
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
                 Text(
                  'Create account'.tr,
                  style:const TextStyle(
                    fontSize: 30,
                    fontFamily: 'Courier',
                    color: Colors.white54,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: height/88,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                  ),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        /// name
                        TextFormField(
                          textInputAction: TextInputAction.next,

                          focusNode: _nameFocus,

                          onEditingComplete: () {
                            fieldFocusChange(context,_nameFocus,_emailFocus);
                          },
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(nameMaxLength),
                          ],
                          controller: nameController,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'name can\'t be empty'.tr;
                            }
                            return null;
                          },
                          decoration:  InputDecoration(
                            contentPadding: const EdgeInsets.only(bottom: 15),
                            hintStyle:const TextStyle(
                                fontSize: 13
                            ),
                            icon:  Icon(Icons.person,color: _nameFocus.hasFocus?yellowCol:disabledIconCol),
                            hintText: 'Enter your name'.tr,
                            labelText: 'Full Name'.tr,
                          ),
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(
                          height: height/40,
                        ),

                        /// email
                        TextFormField(
                          textInputAction: TextInputAction.next,

                          focusNode: _emailFocus,

                          onEditingComplete: () {
                            fieldFocusChange(context,_emailFocus,_pwdFocus);
                          },
                          controller: emailController,
                          onChanged: (value) {},
                          keyboardType: TextInputType.emailAddress,
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
                          decoration:  InputDecoration(
                            contentPadding: const EdgeInsets.only(bottom: 15),
                            hintStyle:const TextStyle(
                                fontSize: 13
                            ),
                            icon: Icon(Icons.email,color: _emailFocus.hasFocus?yellowCol:disabledIconCol),
                            hintText: 'Enter your email'.tr,
                            labelText: 'Email'.tr,
                          ),
                        ),
                        SizedBox(
                          height: height/40,
                        ),
                        /// password
                        TextFormField(
                          focusNode: _pwdFocus,
                          textInputAction: TextInputAction.done,
                          onEditingComplete: () {
                            fieldUnfocusAll();

                          },

                          controller: passwordController,
                          obscureText: _isObscure0,
                          keyboardType: TextInputType.text,
                          onSaved: (value) {
                            passwordController.text = value!;
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(bottom: 15),
                            hintStyle:const TextStyle(
                                fontSize: 13
                            ),
                            suffixIcon: IconButton(
                                icon: Icon(_isObscure0 ? Icons.visibility : Icons.visibility_off,
                                  color: _pwdFocus.hasFocus?yellowCol:disabledIconCol,),
                                onPressed: () {
                                  setState(() {
                                    _isObscure0 = !_isObscure0;
                                  });
                                }),

                            /// simple deco
                            icon: Icon(Icons.lock, color: _pwdFocus.hasFocus?yellowCol:disabledIconCol),
                            hintText: 'Enter your password'.tr,
                            labelText: 'Password'.tr,
                          ),
                          validator: (value) {
                            RegExp regex = RegExp(r'^.{6,}$');
                            if (value!.isEmpty) {
                              return 'password can\'t be empty'.tr;
                            }
                            if (!regex.hasMatch(value)) {
                              return ('Enter a valid password of at least 6 characters'.tr);
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: height/30,
                        ),

                        /// password again
                        // TextFormField(
                        //   obscureText: _isObscure1,
                        //   keyboardType: TextInputType.text,
                        //   decoration: InputDecoration(
                        //     suffixIcon: IconButton(
                        //         icon: Icon(_isObscure1 ? Icons.visibility : Icons.visibility_off),
                        //         onPressed: () {
                        //           setState(() {
                        //             _isObscure1 = !_isObscure1;
                        //           });
                        //         }),
                        //
                        //     /// simple deco
                        //     icon: Icon(Icons.lock),
                        //     hintText: 'Tapez votre mot de passe',
                        //     labelText: 'Password again',
                        //   ),
                        //   validator: (value) {
                        //     if (value! != passwordController.text) {
                        //       return "Le mot de passe ne correspond pas";
                        //     } else {
                        //       return null;
                        //     }
                        //   },
                        // ),
                        // const SizedBox(
                        //   height: 10,
                        //   width: 10,
                        // ),

                        /// SIGN IN
                        TextButton.icon(
                          onPressed: (() {

                            signUp();
                          }),
                          icon: const Icon(Icons.create),
                          label: Container(
                            alignment: Alignment.center,
                            width: 150,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Color(0xFF1b3a4b),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child:  Text(
                              'Sign Up'.tr,
                              style:const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height/200,
                        ),
                        /// already have account
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('already have an account'.tr),

                            TextButton(
                              onPressed: (() {
                                Get.to(()=>LoginScreen());
                              }),
                              child:  Text(
                                'Sign In'.tr,
                                style:const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                          ],
                        ),
                      ],
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
