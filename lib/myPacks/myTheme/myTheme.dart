import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const disabledIconCol = Color(0X60ffd716);
// card - awesomeDialog - alerDialog
const blueColHex = Color(0XFF0a1227);
const blueColHex3 = Color(0X700a1227);
const blueColHex2 = Color(0XFF16254b);
const yellowColHex = Color(0XFFffd716);
const greyColHex = Color(0XFFB0B0B0);
const hintYellowColHex = Color(0X60ffd716);
const hintYellowColHex2 = Color(0X80ffd716);
const hintYellowColHex3 = Color(0XFFe9d98e);
const hintYellowColHex4 = Color(0XFFe9dda9);
ButtonStyle blueStyle = TextButton.styleFrom(
  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
  shape: RoundedRectangleBorder(
      side: const BorderSide(color: yellowColHex, width: 2, style: BorderStyle.solid), borderRadius: BorderRadius.circular(100)),
);
ButtonStyle ylwStyle = TextButton.styleFrom(
  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  backgroundColor: yellowColHex,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
);
ButtonStyle greyStyle = TextButton.styleFrom(
  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  backgroundColor: greyColHex,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
);
const MaterialColor yellowCol = MaterialColor(
  0XFFffd716,
  <int, Color>{
    50: Color(0XFFffd716),
    100: Color(0XFFffd716),
    200: Color(0XFFffd716),
    300: Color(0XFFffd716),
    400: Color(0XFFffd716),
    500: Color(0XFFffd716),
    600: Color(0XFFffd716),
    700: Color(0XFFffd716),
    800: Color(0XFFffd716),
    900: Color(0XFFffd716),
  },
);

ylwDivider() {
  return const Padding(
    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
    child: Divider(thickness: 2),
  );
}
 appBarUnderline(){
  return PreferredSize(
      preferredSize: Size.fromHeight(4.0),
      child: Container(
        color: yellowColHex,
        height: 3.0,
      ));
}



final TextTheme textThemeGlob = TextTheme(
  headline1: GoogleFonts.almarai(fontSize: 97, fontWeight: FontWeight.w300, letterSpacing: -1.5),
  headline2: GoogleFonts.almarai(fontSize: 61, fontWeight: FontWeight.w300, letterSpacing: -0.5),
  headline3: GoogleFonts.almarai(fontSize: 48, fontWeight: FontWeight.w400),
  headline4: GoogleFonts.almarai(fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  headline5: GoogleFonts.almarai(fontSize: 24, fontWeight: FontWeight.w400),
  headline6: GoogleFonts.almarai(fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
  subtitle1: GoogleFonts.almarai(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
  subtitle2: GoogleFonts.almarai(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
  bodyText1: GoogleFonts.almarai(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
  bodyText2: GoogleFonts.almarai(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
  button: GoogleFonts.almarai(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
  caption: GoogleFonts.almarai(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
  overline: GoogleFonts.almarai(fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
);
/////////////////// LIGHT /////////////////////////////////////////////////////////////////////////

ThemeData customLightTheme = ThemeData(


  dialogBackgroundColor: Colors.red,
  primarySwatch: yellowCol,
  brightness: Brightness.light,

  //drawer background col
  canvasColor: blueColHex,
  listTileTheme: const ListTileThemeData(
    iconColor: yellowColHex,
  ),

  iconTheme: IconThemeData(
    color: yellowColHex
  ),
  cardColor: hintYellowColHex4,

  cardTheme: CardTheme(
    color: hintYellowColHex4,
    //surfaceTintColor: Colors.greenAccent
  ),
  unselectedWidgetColor: Colors.white24,
  //unselected checkbox
  //disabledColor: Colors.redAccent,
  inputDecorationTheme: const InputDecorationTheme(
    contentPadding:  EdgeInsets.only(top: 0,bottom: 15),


    disabledBorder: UnderlineInputBorder(


        borderSide: BorderSide(
          color: hintYellowColHex,
          width: 1,
        )),
    enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
      color: hintYellowColHex,
      width: 1,
    )),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: yellowCol, width: 2),
    ),
  ),
  dividerColor: yellowCol,

  hintColor: hintYellowColHex,

  textTheme: textThemeGlob.apply(
    decoration: TextDecoration.none,
    decorationColor: Colors.white,
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),
  colorScheme: ColorScheme.fromSwatch(
    //with copywith
    // primary: yellowCol,
    // secondary: yellowCol,
    // outline: yellowCol
    //no copyWith
    accentColor: yellowCol,
    backgroundColor: const Color(0XFF0a1227),
    primarySwatch: yellowCol,
  ).copyWith(secondary: yellowCol),
  appBarTheme:  AppBarTheme(

    iconTheme:const IconThemeData(color: yellowColHex), // 1
    backgroundColor: blueColHex,
    centerTitle: true,
    titleTextStyle: GoogleFonts.almarai(
        textStyle: const TextStyle(fontSize: 20),
        color: yellowColHex
    ),


  ),
  accentColor: yellowCol,
  primaryColor: yellowCol,


  buttonTheme: const ButtonThemeData(
    buttonColor: yellowCol,
    disabledColor: Colors.grey,
  ),
  //button text col
  backgroundColor: blueColHex,
  scaffoldBackgroundColor: blueColHex,
);
/////////////////// DARK /////////////////////////////////////////////////////////////////////////
ThemeData customDarkTheme = ThemeData.dark().copyWith(
  appBarTheme: const AppBarTheme(color: Colors.redAccent),
  accentColor: Colors.red,
  brightness: Brightness.dark,
  primaryColor: Colors.amber,
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.amber,
    disabledColor: Colors.grey,
  ),
);
