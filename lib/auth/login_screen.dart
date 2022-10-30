import 'dart:ui';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:belaaraby/main.dart';
import 'package:belaaraby/myPacks/myTheme/myTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:belaaraby/Home/homeView.dart';
import 'package:belaaraby/auth/forgot_password.dart';
import 'package:belaaraby/myPacks/myConstants.dart';
import 'package:selectable/selectable.dart';
import '../myPacks/myVoids.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscure0 = true;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


   disableToolBar(){
    return const ToolbarOptions(
      copy: false,
      paste: false,
      cut: false,
      selectAll: false,
    );
  }
  void pasteText(TextEditingController textCtr)async{
    ClipboardData? cdata = await Clipboard.getData(Clipboard.kTextPlain);
    String copiedtext = cdata!.text!;
    textCtr.text =copiedtext;
    setState((){});
    print('## text pasted =>${copiedtext}');
  }
  void copyText(textToCopy)async{
    Clipboard.setData(ClipboardData(text: textToCopy));
    setState((){});
    print('## text copied => $textToCopy');
  }

  goSignUp() {
    //later
    Get.to(() => SignUp());
  }

  anonySignIn() {
    authCtr.anonyLogin();
  }

  signIn() {
    if (_formkey.currentState!.validate()) {

      authCtr.login(emailController.text, passwordController.text, context,
          // account found
          onSignIn: () async {
        //get current user info
        await authCtr.getUserInfoVoid(emailController.text).then((value) {

            authCtr.checkUserVerif(context);

        });
      });
    }
  }

  goForgotPwd() {
    Get.to(() => ForgotPassword());
  }

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _pwdFocus = FocusNode();
  @override
  void initState() {

    super.initState();
    _emailFocus.addListener(_onFocusChange);
    _pwdFocus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _emailFocus.removeListener(_onFocusChange);
    _pwdFocus.removeListener(_onFocusChange);
    _emailFocus.dispose();
    _pwdFocus.dispose();
  }

  void _onFocusChange() {
    setState((){});
  }
  late Offset tapXY;
  RelativeRect get relRectSize => RelativeRect.fromSize(tapXY & const Size(40,40),Size.fromHeight(50));
  void getPosition(TapDownDetails detail) {
    tapXY = detail.globalPosition;
  }


  showPopupMenu(TextEditingController textCtr){
    showMenu<String>(

      constraints:const BoxConstraints(
        maxWidth: 80,
      ),
      context: context,
      position: relRectSize,

      items: [
        PopupMenuItem<String>(
            value: '1',
            child:  Text('Copy'.tr,
            textAlign: TextAlign.center,
            )

        ),
        PopupMenuItem<String>(
            value: '2',
            child:  Text('Paste'.tr,
              textAlign: TextAlign.center,
            )

        ),
      ],
      elevation: 8.0,
    ).then((itemSelected){
      if (itemSelected == null) return;

      if(itemSelected == "1"){
        print('## text copied');



      }else if(itemSelected == "2"){
        print('## text pasted');

        pasteText(textCtr);
      }else{
        //code here
      }
    });
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
                  height: 40,
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText('أقرب إليك',
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Times New Roman',
                            fontWeight: FontWeight.w500,
                          ),
                          speed: const Duration(
                            milliseconds: 200,
                          )),
                    ],
                    onTap: () {
                      debugPrint("Welcome back!");
                    },
                    isRepeatingAnimation: true,
                    totalRepeatCount: 40,
                  ),
                ),
                SizedBox(
                  height: height/15,
                ),



                 Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                    ),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        children: [

                          /// email input
                          TextFormField(


                            textInputAction: TextInputAction.next,

                            //textAlign: TextAlign.left,
                            controller: emailController,
                            onSaved: (value) {
                              emailController.text = value!;
                            },
                            focusNode: _emailFocus,

                            onEditingComplete: () {
                              fieldFocusChange(context,_emailFocus,_pwdFocus);
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
                          SizedBox(
                            height: height/40,
                          ),

                          /// password input
                          TextFormField(
                            focusNode: _pwdFocus,
                            textInputAction: TextInputAction.done,

                            controller: passwordController,
                            obscureText: _isObscure0,


                            onEditingComplete: () {
                           fieldUnfocusAll();

                            },
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  icon: Icon(_isObscure0 ? Icons.visibility : Icons.visibility_off,
                                  color: _pwdFocus.hasFocus?yellowCol:disabledIconCol,),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure0 = !_isObscure0;
                                    });
                                  }),

                              contentPadding: const EdgeInsets.only(bottom: 15),
                              hintStyle:const TextStyle(
                                  fontSize: 13
                              ),
                              /// simple deco
                              icon: Icon(Icons.lock , color: _pwdFocus.hasFocus?yellowCol:disabledIconCol),
                              hintText: 'Enter your password'.tr,
                              labelText: 'Password'.tr,
                            ),
                            validator: (value) {
                              RegExp regex = RegExp(r'^.{6,}$');
                              if (value!.isEmpty) {
                                return "password can\'t be empty".tr;
                              }
                              if (!regex.hasMatch(value)) {
                                return ('Enter a valid password of at least 6 characters'.tr);
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              passwordController.text = value!;
                            },
                            keyboardType: TextInputType.text,
                          ),
                          SizedBox(
                            height: height/45,
                          ),
                          /// forgot btn
                          TextButton(
                            onPressed: () {
                              goForgotPwd();
                            },
                            child:  Text(
                              'Forgot Password?'.tr,
                            ),
                          ),
                          SizedBox(
                            height: height/200,
                          ),
                          /// signIn btn
                          TextButton(
                            onPressed: (() {
                              signIn();
                            }),
                            //icon: const Icon(Icons.login),
                            child: Container(
                              alignment: Alignment.center,
                              width: 150,
                              height: 35,
                              decoration: BoxDecoration(
                                color: Color(0xFF1b3a4b),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child:  Text(
                                'Sign In'.tr,
                                style:const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          /// anony btn
                          TextButton(
                            onPressed: (() {
                              sharedPrefs!.setBool('isGuest', true);
                              anonySignIn();
                            }),
                            //icon: const Icon(Icons.login),
                            child: Container(
                              alignment: Alignment.center,
                              width: 150,
                              height: 35,
                              decoration: BoxDecoration(
                                color: Color(0xFF1b3a4b),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child:  Text(
                                'Guest'.tr,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height/200,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                               Text('you have no account?'.tr),
                              TextButton(
                                onPressed: (() {
                                  goSignUp();
                                }),
                                child:  Text(
                                  'Sign Up'.tr,
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

///text field general
// TextFormField(
// focusNode: _emailFocus,
// textInputAction: TextInputAction.next,
//
// textAlign: TextAlign.left,
// controller: emailController,
// onSaved: (value) {
// emailController.text = value!;
// },
//
// onEditingComplete: () {
// _fieldFocusChange(context,_emailFocus,_pwdFocus);
// },
// keyboardType: TextInputType.emailAddress,
// decoration: InputDecoration(
// //######################################################""
// isDense: false,
//
// ///border
// //border: UnderlineInputBorder(),
//
// // border: OutlineInputBorder(
// //   borderRadius: BorderRadius.circular(30),
// // ),
// /// unfocused border (unfocus input => enabled=false)
// // enabledBorder: UnderlineInputBorder(
// //       //borderRadius: BorderRadius.circular(30),
// //     borderSide:  BorderSide(
// //       color: Colors.red,
// //       width: 5,
// //     )
// //   ),
// /// focused border (focus input => enabled=true)
// // focusedBorder: OutlineInputBorder(
// //   borderRadius: BorderRadius.circular(30),
// //   borderSide: const BorderSide(
// //     color: Colors.purple,
// //     width: 2.0,
// //   ),
// // ),
//
// ///icon
// icon: Icon(Icons.email , color: _emailFocus.hasFocus?yellowCol:disabledIconCol),
//
// ///fill color
// // filled: true,
// // fillColor: Colors.blue.shade100,
//
// ///label
// floatingLabelBehavior: FloatingLabelBehavior.auto,
// labelText: 'Email',
//
// ///padding
// contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
//
// ///hint
// hintText: 'Entrer votre Email',
//
// //######################################################""
// ),
// validator: (value) {
// RegExp regex = RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]");
//
// if (value!.isEmpty) {
// return "L'e-mail ne peut pas être vide";
// }
//
// if (!regex.hasMatch(value)) {
// return ("Veuillez entrer un email valide");
// } else {
// return null;
// }
// },
// ),
/// /////////////////////////////////////
// data: ThemeData(
// primarySwatch: MaterialColor(0xFFffffff, colorMap),
// canvasColor: Colors.red,
// hintColor: hintYellowColHex,
// dividerColor: yellowCol,
// iconTheme: IconThemeData(
// color: yellowColHex
// ),
// listTileTheme: const ListTileThemeData(
// iconColor: yellowColHex,
// ),
// cursorColor: ColorsPersonalScheme.lightColor,
// unselectedWidgetColor: ColorsPersonalScheme.lightColorShade4,
// dialogBackgroundColor: ColorsPersonalScheme.darkColor,
// backgroundColor: ColorsPersonalScheme.darkColor,
// accentColor: ColorsPersonalScheme.lightColor,
// brightness: Brightness.light,
// appBarTheme: const AppBarTheme(
// backgroundColor: customMagenta100,
// // This will control the "back" icon
// iconTheme: IconThemeData(color: Colors.red),
// // This will control action icon buttons that locates on the right
// actionsIconTheme: IconThemeData(color: customMagenta900),
// centerTitle: false,
// elevation: 15,
// titleTextStyle: TextStyle(
// color: customMagenta400,
// fontWeight: FontWeight.bold,
// fontFamily: 'Allison',
// fontSize: 40,
// ),
// ),
// textTheme: const TextTheme(
// bodyText1: TextStyle(
// fontSize: 22,
// color: customMagenta300,
// ),
// bodyText2: TextStyle(
// color: customMagenta400,
// fontSize: 18,
// fontWeight: FontWeight.bold,
// backgroundColor: customBackgroundWhite,
// ),
// caption: TextStyle(
// fontSize: 16,
// fontWeight: FontWeight.bold,
// fontStyle: FontStyle.italic,
// color: customMagenta900,
// backgroundColor: customMagenta50,
// ),
// headline1: TextStyle(
// color: customMagenta600,
// fontSize: 60,
// fontFamily: 'Allison',
// fontWeight: FontWeight.bold,
// ),
// headline2: TextStyle(
// color: customMagenta400,
// fontSize: 25,
// fontWeight: FontWeight.bold,
// ),
// ),
// inputDecorationTheme: InputDecorationTheme(
// prefixStyle: TextStyle(color: ColorsPersonalScheme.lightColor),
// labelStyle: TextStyle(
// color: ColorsPersonalScheme.lightColorShade2,
// ),
// enabledBorder: UnderlineInputBorder(
// borderSide: BorderSide(
// color: ColorsPersonalScheme.lightColorShade2,
// ),
// ),
// focusedBorder: UnderlineInputBorder(
// borderSide: BorderSide(color: ColorsPersonalScheme.lightColor),
// ),
// ),
// colorScheme: _customColorScheme,
// primaryColor: ColorsPersonalScheme.lightColor,
// scaffoldBackgroundColor: ColorsPersonalScheme.darkColor,
// cardTheme: CardTheme(
// color: ColorsPersonalScheme.darkColorElevation2,
// elevation: 0,
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.all(Radius.circular(10.0))
// )
// ),
//
// buttonTheme: const ButtonThemeData(
// buttonColor: yellowCol,
// disabledColor: Colors.grey,
// ),
//
// ),
/// ////////////////// gesture detector custom copy paste
// GestureDetector(
// onTapDown: (p){
// print('## onTapDown');
// getPosition(p);
// },
// onDoubleTap: (){
// print('## onLongPress');
// showPopupMenu(emailController);
// },
// child: TextFormField(
//
// toolbarOptions:disableToolBar(),
//
// textInputAction: TextInputAction.next,
//
// //textAlign: TextAlign.left,
// controller: emailController,
// onSaved: (value) {
// emailController.text = value!;
// },
// focusNode: _emailFocus,
//
// onEditingComplete: () {
// fieldFocusChange(context,_emailFocus,_pwdFocus);
// },
// keyboardType: TextInputType.emailAddress,
// decoration: InputDecoration(
//
// icon: Icon(Icons.email , color: _emailFocus.hasFocus?yellowCol:disabledIconCol),
// floatingLabelBehavior: FloatingLabelBehavior.auto,
// labelText: 'Email'.tr,
// contentPadding: const EdgeInsets.only(bottom: 15),
// hintStyle:const TextStyle(
// fontSize: 13
// ),
// hintText: 'Enter your email'.tr,
//
// ),
// validator: (value) {
// RegExp regex = RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]");
//
// if (value!.isEmpty) {
// return "email can\'t be empty".tr;
// }
//
// if (!regex.hasMatch(value)) {
// return ("Enter a valid email".tr);
// } else {
// return null;
// }
// },
// ),
// ),

