import 'package:flutter/material.dart';

class Apptheme {
  Apptheme._();
  static const Color primaryColor = Color(0xFF1D9AAA);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color defaultBlack = Color(0xFF1F2937);
  static const Color royalBlue = Color(0xFF1E3A8A);
  static const Color persianBlue = Color(0xFF1E40AF);
  static const Color deepTeel = Color(0xFF115E59);
  static const Color transparent = Colors.transparent;
  static const Color vividBlue = Color(0xFF3B82F6);
  static const Color aquaGreen = Color(0xFF2DD4BF);
  static const Color slateGray = Color(0xFFADAEBC);
  static const Color mintyAqua = Color(0xFFCCFBF1);
  static const Color mintGreen = Color(0xFF99F6E4);
  static const Color pastelBlue = Color(0xFFBFDBFE);
  static const Color lightGray = Color(0xFFE5E7EB);
  static const Color coolGray = Color(0xFFD1D5DB);
  static const Color darkSlateGray = Color(0xFF374151);
  static const Color strongBlue = Color(0xFF2563EB);
  static const Color iceBlue = Color(0xFFEFF6FF);
  static const Color paleBlue = Color(0xFFDBEAFE);
  static const Color whisperGrey = Color(0x4CEFEFEF);
  static const Color steelMist = Color(0xFF6B7280);
  static const Color jungleGreen = Color(0xFF059669);
  static const Color stormGray = Color(0xFF4B5563);
  static const Color electricIndigo = Color(0xFF1D4ED8);
  static const Color emeraldGreen = Color(0xFF047857);
  static const Color lightMintGreen = Color(0xFFD1FAE5);
  static const Color purple = Color(0xFFEDE9FE);
  static const Color yellow = Color(0xFFFEF3C7);


  static const String fontFamily = 'Inter'; //TODO bring font in

  static TextStyle get text => TextStyle(
    color: defaultBlack,
    fontSize: 14,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    height: 1,
  );
}
