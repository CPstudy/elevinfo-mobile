import 'dart:ui' show Color;
import 'package:flutter/material.dart';

class SColors {

  static const MaterialColor blueGreen = MaterialColor(
    _indigoPrimaryValue,
    <int, Color>{
      50: Color(0xFFE8EAF6),
      100: Color(0xFFC5CAE9),
      200: Color(0xFF9FA8DA),
      300: Color(0xFF7986CB),
      400: Color(0xFF5C6BC0),
      500: Color(_indigoPrimaryValue),
      600: Color(0xFF3949AB),
      700: Color(0xFF303F9F),
      800: Color(0xFF283593),
      900: Color(0xFF1A237E),
    },
  );
  static const int _indigoPrimaryValue = 0xff36a2af;


  static const Color colorPrimary = Color(0xff36a2af);
  static const Color colorPrimaryDark = Color(0xff218693);

  static const Color white87 = Color(0xddffffff);
  static const Color red = Color(0xffbf360c);
  static const Color red87 = Color(0xfff1dbd5);
  static const Color red12 = Color(0xfff1dbd5);

  // Light Theme
  static const Color backgroundLight = Color(0xffe6e8eb);
  static const Color listBackgroundLight = Color(0xffe4f3f4);
  static const Color listBoxBackgroundLight = Color(0xfff9f9f9);
  static const Color listBoxBorderLight = Color(0xffababab);
  static const Color dividerLight = Color(0x19000000);
  static const Color gridBackgroundLight = Color(0xffe6e8eb);
  static const Color gridDividerLight = Color(0x40000000);
  static const Color textLight = Color(0xff282828);
  static const Color subTextLight = Color(0xff5b5b5b);
  static const Color errorLight = Color(0xfff1dbd5);

  // Dark Theme
  static const Color colorDarkPrimary = Color(0xff19191e);
  static const Color backgroundDark = Color(0xff222222);
  static const Color listBackgroundDark = Color(0xff252531);
  static const Color listBoxBackgroundDark = Color(0xff1b1b1b);
  static const Color listBoxBorderDark = Color(0x901b1b1b);
  static const Color dividerDark = Color(0x19ffffff);
  static const Color gridBackgroundDark = Color(0xff252531);
  static const Color gridDividerDark = Color(0x40ffffff);
  static const Color textDark = Color(0xffeeeeee);
  static const Color subTextDark = Color(0xff8a8a8a);
  static const Color errorDark = Color(0xff311b1b);

}