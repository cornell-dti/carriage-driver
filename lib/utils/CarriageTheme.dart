import 'package:flutter/material.dart';

class CarriageTheme {
  static final TextStyle largeTitle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w600,
      fontSize: 34,
      letterSpacing: 0.37);

  static final TextStyle title1 = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w600,
      fontSize: 28,
      letterSpacing: 0.36);

  static final TextStyle title2 = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 22,
      letterSpacing: 0.35);

  static final TextStyle title3 = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w600,
      fontSize: 20,
      letterSpacing: 0.38);

  static final TextStyle body = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w400,
      fontSize: 17,
      letterSpacing: -0.41);

  static final TextStyle button =
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17);

  static final TextStyle subheadline = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w400,
      fontSize: 15,
      letterSpacing: -0.24);

  static final TextStyle caption1 = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w600,
      fontSize: 11,
      letterSpacing: 0.07);

  static final TextStyle caption2 = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w400,
      fontSize: 11,
      letterSpacing: 0.07);

  static Color mainBlack = Colors.black;
  static Color gray1 = Color.fromRGBO(74, 74, 74, 1);
  static Color gray2 = Color.fromRGBO(132, 132, 132, 1);
  static Color gray3 = Color.fromRGBO(167, 167, 167, 1);
  static Color backgroundColor = Color.fromRGBO(250, 250, 250, 0.9);

  static BoxShadow shadow =
      BoxShadow(blurRadius: 2, color: Colors.black.withOpacity(0.25));
}
