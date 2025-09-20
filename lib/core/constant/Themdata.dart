import 'package:flutter/material.dart';
import 'package:Silaaty/core/constant/Colorapp.dart';

ThemeData themeEn = ThemeData(
  fontFamily: "Wittgenstein",
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    titleTextStyle: TextStyle(
        color: AppColor.primarycolor,
        fontWeight: FontWeight.bold,
        fontFamily: "Wittgenstein",
        fontSize: 25),
    iconTheme: IconThemeData(color: AppColor.primarycolor),
    backgroundColor: AppColor.backgroundcolor,
    elevation: 4,
  ),
  textTheme: const TextTheme(
    headlineMedium: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 20, color: AppColor.black),
    headlineSmall: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 26, color: AppColor.black),
    headlineLarge: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Color.fromARGB(255, 244, 111, 54)),
    bodyMedium: TextStyle(
        height: 2,
        color: AppColor.grey,
        fontWeight: FontWeight.bold,
        fontSize: 17),
    bodySmall: TextStyle(
        height: 2,
        color: AppColor.grey,
        fontWeight: FontWeight.bold,
        fontSize: 24),
  ),
);

ThemeData themeAr = ThemeData(
  fontFamily: "Cairo",
  appBarTheme: const AppBarTheme(
    centerTitle: true,
    titleTextStyle: TextStyle(
        color: AppColor.primarycolor,
        fontWeight: FontWeight.bold,
        fontFamily: "Wittgenstein",
        fontSize: 25),
    iconTheme: IconThemeData(color: AppColor.primarycolor),
    backgroundColor: AppColor.backgroundcolor,
    elevation: 4,
  ),
  textTheme: const TextTheme(
    headlineMedium: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 20, color: AppColor.black),
    headlineSmall: TextStyle(
        fontWeight: FontWeight.bold, fontSize: 26, color: AppColor.black),
    headlineLarge: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Color.fromARGB(255, 244, 111, 54)),
    bodyMedium: TextStyle(
        height: 2,
        color: AppColor.grey,
        fontWeight: FontWeight.bold,
        fontSize: 17),
    bodySmall: TextStyle(
        height: 2,
        color: AppColor.grey,
        fontWeight: FontWeight.bold,
        fontSize: 24),
  ),
);
