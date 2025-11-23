import 'package:flutter/material.dart';

abstract final class AppColors {
  static const white = Colors.white;
  static const black = Colors.black;
  static const blackE1 = Color(0xFF1E1E1E);
  static const black05 = Color(0x0D000000); // 0.05 opacity
  static const black10 = Color(0x1A000000); // 0.1 opacity
  static const black15 = Color(0x26000000); // 0.15 opacity
  static const black20 = Color(0x33000000); // 0.2 opacity
  static const black25 = Color(0x40000000); // 0.25 opacity
  static const black60 = Color(0x99000000); // 0.6 opacity
  static const black70 = Color(0xB3000000); // 0.7 opacity
  static const black95 = Color(0xF2000000); // 0.95 opacity

  // Border of text field, drop down
  static const border = Color(0XFFDBE1E5);
  static const dashedBorder = Color(0XFFB0B0B0);

  // Random
  static const base = Color(0xFF121212);
  static const fade = Color(0xFF5E6A75);
  static const hightLight = Color(0xFF254EDB);
  static const iconContainer = Color(0xFFFEF3EB);

  // Color Scheme
  static const primary = Color(0xFF003399);
  static const secondary = Color(0xFF263A43);
  static const surface = white;
  static const onSurface = base;
  static const error = Color(0xFFE20A17);

  // Green
  static const success = Color(0xFF109335);
  static const green500 = Color(0xFF16B364);

  // Red
  static const red500 = Color(0xFFFF4405);
  static const red600 = Color(0xFFD92D20);

  // Orange
  static const warning = Color(0xFFF97316);
}
