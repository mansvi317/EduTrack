import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes{
  static final light = ThemeData(
    backgroundColor: Colors.white,
    primarySwatch: Colors.deepPurple,
    brightness: Brightness.light
  );
  static final dark = ThemeData(
    backgroundColor: Colors.black,
    primarySwatch: Colors.deepPurple,
    brightness: Brightness.dark

  );
}

class Palette {
  static const Color iconColor = Color(0xFF767F85);
  static const Color activeColor = Colors.white; //Color(0xFF09126C);
  static const Color textColor1 = Colors.white;
  static const Color textColor2 = Color(0XFF9BB3C0);
  static const Color facebookColor = Color(0xFF191970);
  static const Color googleColor = Color(0xFFffc0cb);
  static const Color backgroundColor = Colors.white;
  static const Color buttonColor = Color(0xFF6a5acd);
  static const Color bgColor =  Color(0xFFb8acd1);

}

TextStyle get subHeadingStyle{
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
        color: Get.isDarkMode?Colors.grey[400]:Colors.grey

    ),
  );
}

TextStyle get headingStyle{
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Get.isDarkMode?Colors.white:Colors.black
    ),
  );
}

TextStyle get titleStyle{
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Get.isDarkMode?Colors.white:Colors.black
    ),
  );
}

TextStyle get subTitleStyle{
  return GoogleFonts.lato(
    textStyle: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: Get.isDarkMode?Colors.grey[100]:Colors.grey[600]
    ),
  );
}