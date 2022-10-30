import 'package:flutter/material.dart';

/// ///TEST THEME

Map<int, Color> colorMap = {
  50: Color.fromRGBO(255, 255, 255, .1),
  100: Color.fromRGBO(255, 255, 255, .2),
  200: Color.fromRGBO(255, 255, 255, .3),
  300: Color.fromRGBO(255, 255, 255, .4),
  400: Color.fromRGBO(255, 255, 255, .5),
  500: Color.fromRGBO(255, 255, 255, .6),
  600: Color.fromRGBO(255, 255, 255, .7),
  700: Color.fromRGBO(255, 255, 255, .8),
  800: Color.fromRGBO(255, 255, 255, .9),
  900: Color.fromRGBO(255, 255, 255, 1),
};
const Color customMagenta50 = Color(0xfffcd5ce);
const Color customMagenta100 = Color(0xfffaac9d);
const Color customMagenta300 = Color(0xfff8836c);
const Color customMagenta400 = Color(0xfff65a3b);

const Color customMagenta900 = Color(0xfff4310a);
const Color customMagenta600 = Color(0xffc32708);

const Color customErrorRed = Color(0xFFC5032B);

const Color customSurfaceWhite = Color(0xFFFFFBFA);
const Color customBackgroundWhite = Colors.white;

ColorScheme _customColorScheme = ColorScheme(
  primary: customMagenta50,
  primaryVariant: customMagenta600,
  secondary: Colors.amber,
  secondaryVariant: customMagenta400,
  surface: Colors.purpleAccent,
  background: customSurfaceWhite,
  error: customMagenta900,
  onPrimary: Colors.red,
  onSecondary: Colors.deepOrange,
  onSurface: customMagenta300,
  onBackground: customMagenta100,
  onError: Colors.redAccent,
  brightness: Brightness.light,
);

class ColorsPersonalScheme {
  static Color? eventoColor = Colors.red[300];
  static Color? tareaColor = Colors.purple[300];
  static Color? recordatorioColor = Colors.indigo[300];

  static Color? primaryColorLight = Colors.cyan[300];
  static Color? primaryColorDark = Colors.cyan[800];

  static Color? secondaryColorLight = Colors.pink[300];
  static Color? secondaryColorDark = Colors.pink[800];

  static Color? danger = Colors.red[400];
  static Color? success = Colors.green[400];

  static const Color darkColor = Color.fromRGBO(10, 10, 10, 1);
  static const Color darkColorElevation1 = Color.fromRGBO(20, 20, 20, 1);
  static const Color darkColorElevation2 = Color.fromRGBO(30, 30, 30, 1);
  static const Color darkColorElevation3 = Color.fromRGBO(40, 40, 40, 1);
  static const Color darkColorElevation4 = Color.fromRGBO(50, 50, 50, 1);
  static const Color darkColorElevation5 = Color.fromRGBO(60, 60, 60, 1);
  static const Color darkColorElevation6 = Color.fromRGBO(70, 70, 70, 1);
  static const Color darkColorElevation7 = Color.fromRGBO(80, 80, 80, 1);
  static const Color darkColorElevation8 = Color.fromRGBO(90, 90, 90, 1);

  static const Color lightColor = Color.fromRGBO(235, 235, 235, 1);
  static const Color lightColorShade1 = Color.fromRGBO(225, 225, 225, 1);
  static const Color lightColorShade2 = Color.fromRGBO(215, 215, 215, 1);
  static const Color lightColorShade3 = Color.fromRGBO(205, 205, 205, 1);
  static const Color lightColorShade4 = Color.fromRGBO(195, 195, 195, 1);
}

/// /////

ThemeData testTheme = ThemeData(
  primarySwatch: MaterialColor(0xFFffffff, colorMap),
  canvasColor: Colors.red,
  textSelectionTheme:TextSelectionThemeData(
    cursorColor: Colors.purple,
    selectionHandleColor: Colors.purple,
    selectionColor: Colors.red,
  ),
  hintColor: Colors.deepOrange,
  dividerColor: Colors.deepOrange,
  iconTheme: IconThemeData(color: Colors.deepOrange),
  listTileTheme: const ListTileThemeData(
    iconColor: Colors.deepOrange,
  ),
  //cursorColor: ColorsPersonalScheme.lightColor,
  unselectedWidgetColor: ColorsPersonalScheme.lightColorShade4,
  dialogBackgroundColor: ColorsPersonalScheme.darkColor,
  backgroundColor: ColorsPersonalScheme.darkColor,
  accentColor: ColorsPersonalScheme.lightColor,
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    backgroundColor: customMagenta100,
// This will control the "back" icon
    iconTheme: IconThemeData(color: Colors.red),
// This will control action icon buttons that locates on the right
    actionsIconTheme: IconThemeData(color: customMagenta900),
    centerTitle: false,
    elevation: 15,
    titleTextStyle: TextStyle(
      color: customMagenta400,
      fontWeight: FontWeight.bold,
      fontFamily: 'Allison',
      fontSize: 40,
    ),
  ),
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      fontSize: 22,
      color: customMagenta300,
    ),
    bodyText2: TextStyle(
      color: customMagenta400,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      backgroundColor: customBackgroundWhite,
    ),
    caption: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      color: customMagenta900,
      backgroundColor: customMagenta50,
    ),
    headline1: TextStyle(
      color: customMagenta600,
      fontSize: 60,
      fontFamily: 'Allison',
      fontWeight: FontWeight.bold,
    ),
    headline2: TextStyle(
      color: customMagenta400,
      fontSize: 25,
      fontWeight: FontWeight.bold,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    prefixStyle: TextStyle(color: ColorsPersonalScheme.lightColor),
    labelStyle: TextStyle(
      color: ColorsPersonalScheme.lightColorShade2,
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: ColorsPersonalScheme.lightColorShade2,
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: ColorsPersonalScheme.lightColor),
    ),
  ),
  colorScheme: _customColorScheme,
  primaryColor: ColorsPersonalScheme.lightColor,
  scaffoldBackgroundColor: ColorsPersonalScheme.darkColor,
  cardTheme: CardTheme(
      color: ColorsPersonalScheme.darkColorElevation2,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)))),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.deepOrange,
    disabledColor: Colors.grey,
  ),
);

/// ///////


