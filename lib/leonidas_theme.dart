import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LeonidasTheme {
  static const List<Color> whiteTint = [
    Color(0xFF121212),
    Color(0x0CFFFFFF),
    Color(0x11FFFFFF),
    Color(0x14FFFFFF),
    Color(0x16FFFFFF),
    Color(0x1CFFFFFF),
    Color(0x1EFFFFFF),
    Color(0x23FFFFFF),
    Color(0x26FFFFFF),
    Color(0x28FFFFFF),
  ];

  static const Color primaryColor = Colors.blue;
  static const Color secondaryColor = Colors.green;
  static const Color accentColor = Colors.red;

  static const TextStyle h1 =
      TextStyle(fontSize: 96, fontWeight: FontWeight.w300, letterSpacing: -1.5);
  static const TextStyle h2 =
      TextStyle(fontSize: 60, fontWeight: FontWeight.w300, letterSpacing: -0.5);
  static const TextStyle h3 =
      TextStyle(fontSize: 48, fontWeight: FontWeight.w400, letterSpacing: 0);
  static const TextStyle h3Heavy =
  TextStyle(fontSize: 48, fontWeight: FontWeight.w500, letterSpacing: 0);
  static const TextStyle h4 =
      TextStyle(fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25);
  static const TextStyle h5 =
      TextStyle(fontSize: 24, fontWeight: FontWeight.w400, letterSpacing: 0);
  static const TextStyle h6 =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15);
  static const TextStyle subtitle1 =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15);
  static const TextStyle subtitle2 =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1);
  static const TextStyle body1 =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5);
  static const TextStyle body2 =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25);

//  static const TextStyle button= TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25);
  static const TextStyle caption =
      TextStyle(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4);
  static const TextStyle overline =
      TextStyle(fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5);
}
