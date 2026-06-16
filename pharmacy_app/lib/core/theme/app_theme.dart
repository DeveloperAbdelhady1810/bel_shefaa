import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kMedicalBlue = Color(0xFF1A6FA8);

ThemeData buildAppTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: kMedicalBlue,
    brightness: Brightness.light,
  );

  final base = ThemeData(colorScheme: colorScheme, useMaterial3: true);

  final arabicTextTheme = GoogleFonts.notoKufiArabicTextTheme(base.textTheme);

  return base.copyWith(
    textTheme: arabicTextTheme,
    primaryTextTheme: arabicTextTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: kMedicalBlue,
      foregroundColor: Colors.white,
      centerTitle: true,
      titleTextStyle: GoogleFonts.notoKufiArabic(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kMedicalBlue,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: GoogleFonts.notoKufiArabic(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: kMedicalBlue, width: 2),
      ),
    ),
  );
}
