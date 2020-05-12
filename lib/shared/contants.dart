import 'package:flutter/material.dart';

class Constants{
  static const MainGoldColor = const Color(0xFFE8B923);
  static const WineColor = const Color(0xFFfd4953);
  static const GreyColor1 = const Color(0xFF595A5E);
  static const GreyColor2 = const Color(0xFF141414);
  static const OffBlack = const Color(0xFF0a0a0a);
  static const BlueishValorant = const Color(0xFF0e1824);

  static ThemeData lightModeTheme = ThemeData(
    brightness: Brightness.light,
    backgroundColor: Colors.white70,
    primaryColor: Colors.white,
    // primarySwatch: Colors.black,
    iconTheme: IconThemeData(color: Colors.black),
    textTheme: TextTheme(
        title: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black),
        subtitle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w300,
            color: Colors.black54)),
    cardColor: Colors.white,
    canvasColor: Colors.white,
    bottomAppBarColor: Colors.white,
   
    );

  static ThemeData darkModeTheme = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: Constants.OffBlack,
    primaryColor: Colors.black,
    // primarySwatch: Colors.black54,
    iconTheme: IconThemeData(color: Colors.white),
    
    textTheme: TextTheme(
        title: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white),
        subtitle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w300,
            color: Colors.white70)),
    cardColor: Colors.grey[900],
    canvasColor: Colors.black
   
  );
}