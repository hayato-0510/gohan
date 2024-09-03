import 'package:flutter/material.dart';
import 'app_color.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    primary: AppColor.buttonBackgroundColor,
    onPrimary: Colors.black,
    secondary: AppColor.textColor,
    onSecondary: Colors.white,
    background: AppColor.bodyColor,
    onBackground: Colors.black,
    surface: AppColor.bodyColor,
    onSurface: Colors.black,
    error: Colors.red,
    onError: Colors.white,
  ),
  scaffoldBackgroundColor: AppColor.bodyColor,
  hintColor: AppColor.textColor,
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      color: Colors.black,
      fontSize: 40,
      fontWeight: FontWeight.bold,
    ),
  ),
  buttonTheme: ButtonThemeData(
    textTheme: ButtonTextTheme.primary,
    buttonColor: Colors.black,
  ),
);