//@dart=2.9
import 'package:flutter/widgets.dart';

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double sWidth;
  static double sHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;
  static double _safeAreaHorizontal;
  static double _safeAreaVertical;
  static double safeBlockHorizontal;
  static double safeBlockVertical;

  void init(BuildContext context){
    _mediaQueryData = MediaQuery.of(context);
    sWidth = _mediaQueryData.size.width;
    sHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = sWidth/100;
    blockSizeVertical = sHeight/100;
    _safeAreaHorizontal = _mediaQueryData.padding.left +
        _mediaQueryData.padding.right;
    _safeAreaVertical = _mediaQueryData.padding.top +
        _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (sWidth - _safeAreaHorizontal)/100;
    safeBlockVertical = (sHeight - _safeAreaVertical)/100;
  }
}