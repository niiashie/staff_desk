import 'package:leave_desk/constants/fonts.dart';

import '../constants/app.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    primaryColor: const Color(0xff009688),
    iconTheme: const IconThemeData(color: Colors.black54),
    fontFamily: AppFonts.nunito,
    hintColor: Colors.white,
    buttonTheme: ButtonThemeData(
      buttonColor: const Color(0xFF8BC34A),
      padding: const EdgeInsets.symmetric(vertical: 10),
      textTheme: ButtonTextTheme.accent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(20),
      filled: false,
      fillColor: Colors.black87,
      focusColor: Colors.white,
      hintStyle: const TextStyle(color: Colors.black87),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.green),
  );
}
