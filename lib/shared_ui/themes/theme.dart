import 'package:clean_architecture/core/constants/app_colors.dart';
import 'package:clean_architecture/shared_ui/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'theme_data.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.primary,
  colorScheme: colorScheme,
  fontFamily: "Poppins",
  scaffoldBackgroundColor: AppColors.surface,
  appBarTheme: appBarTheme,
  inputDecorationTheme: inputDecorationTheme,
  checkboxTheme: checkBoxThemeData,
  listTileTheme: listTileThemeData,
);
