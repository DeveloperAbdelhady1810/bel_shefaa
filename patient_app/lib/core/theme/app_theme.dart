import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kMedicalBlue = Color(0xFF1A6FA8);
const Color kMedicalBlueLight = Color(0xFFE8F4FD);

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
      elevation: 0,
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
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.notoKufiArabic(
            fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: kMedicalBlue,
        minimumSize: const Size.fromHeight(50),
        side: const BorderSide(color: kMedicalBlue),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kMedicalBlue, width: 2)),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: EdgeInsets.zero,
    ),
  );
}
