import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_alarm_apps/constant/custom_color.dart';

// LightTheme
ThemeData lightThemeData(BuildContext context) {
  return ThemeData(
    appBarTheme: appBarTheme,
    primaryColor: kPrimaryColor,
    accentColor: kAccentLightColor,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(
      secondary: kSecondaryLightColor,
      // on light theme surface = Colors.white by default
    ),
    backgroundColor: Colors.white,
    shadowColor: Colors.grey[350].withOpacity(0.5),
    iconTheme: IconThemeData(color: kBodyTextColorLight),
    accentIconTheme: IconThemeData(color: kAccentIconLightColor),
    primaryIconTheme: IconThemeData(color: kPrimaryIconLightColor),
    textTheme: GoogleFonts.latoTextTheme().copyWith(
      bodyText1: TextStyle(color: kBodyTextColorLight),
      bodyText2: TextStyle(color: kBodyTextColorLight),
      headline6: TextStyle(color: kTitleTextLightColor, fontSize: 24),
      headline5: TextStyle(color: kTitleTextLightColor, fontSize: 28),
      headline4: TextStyle(color: kTitleTextLightColor, fontSize: 32, fontWeight: FontWeight.bold),
      headline1: TextStyle(color: kTitleTextLightColor, fontSize: 80),
    ),
  );
}

// Dark Them
ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
    primaryColor: kPrimaryColor,
    accentColor: kAccentDarkColor,
    scaffoldBackgroundColor: Color(0xFF0D0C0E),
    appBarTheme: appBarTheme,
    colorScheme: ColorScheme.light(
      secondary: kSecondaryDarkColor,
      surface: kSurfaceDarkColor,
    ),
    backgroundColor: kBackgroundDarkColor,
    shadowColor: Colors.transparent,
    iconTheme: IconThemeData(color: kBodyTextColorDark),
    accentIconTheme: IconThemeData(color: kAccentIconDarkColor),
    primaryIconTheme: IconThemeData(color: kPrimaryIconDarkColor),
    textTheme: GoogleFonts.latoTextTheme().copyWith(
      bodyText1: TextStyle(color: kBodyTextColorDark),
      bodyText2: TextStyle(color: kBodyTextColorDark),
      headline6: TextStyle(color: kTitleTextDarkColor, fontSize: 24),
      headline5: TextStyle(color: kTitleTextDarkColor, fontSize: 28),
      headline4: TextStyle(color: kTitleTextDarkColor, fontSize: 32, fontWeight: FontWeight.bold),
      headline1: TextStyle(color: kTitleTextDarkColor, fontSize: 80),
    ),
  );
}

AppBarTheme appBarTheme = AppBarTheme(color: Colors.transparent, elevation: 0);