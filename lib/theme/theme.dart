import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    //fontFamily: GoogleFonts.nunito().fontFamily,
    fontFamily: 'QuickSand',
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.nunito(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      headlineMedium: GoogleFonts.nunito(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      headlineSmall: GoogleFonts.nunito(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      bodyLarge: GoogleFonts.nunito(
        fontSize: 16.0,
        color: Colors.black,
      ),
      bodyMedium: GoogleFonts.nunito(
        fontSize: 14.0,
        color: Colors.black,
      ),
      bodySmall: GoogleFonts.nunito(
        fontSize: 12.0,
        color: Colors.black,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: GoogleFonts.nunito().fontFamily,
    textTheme: TextTheme(
      headlineLarge: GoogleFonts.nunito(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineMedium: GoogleFonts.nunito(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineSmall: GoogleFonts.nunito(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyLarge: GoogleFonts.nunito(
        fontSize: 16.0,
        color: Colors.white,
      ),
      bodyMedium: GoogleFonts.nunito(
        fontSize: 14.0,
        color: Colors.white,
      ),
      bodySmall: GoogleFonts.nunito(
        fontSize: 12.0,
        color: Colors.white,
      ),
    ),
  );
}