import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Color Palette ────────────────────────────────────────────────────────────
const Color kMedicalBlue      = Color(0xFF1A6FA8);
const Color kMedicalBlueDark  = Color(0xFF0D4E8A);
const Color kMedicalBlueLight = Color(0xFFE8F4FD);
const Color kBg               = Color(0xFFF4F7FB);
const Color kSurface          = Color(0xFFFFFFFF);
const Color kTextPrimary      = Color(0xFF1A1F36);
const Color kTextSecondary    = Color(0xFF8A94A6);
const Color kSuccess          = Color(0xFF00B37E);
const Color kWarning          = Color(0xFFF59E0B);
const Color kError            = Color(0xFFEF4444);
const Color kGreenLight       = Color(0xFFE6FBF3);
const Color kCardShadowBlue   = Color(0x141A6FA8); // ~8% blue

ThemeData buildAppTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: kMedicalBlue,
    brightness: Brightness.light,
  );
  final base = ThemeData(colorScheme: colorScheme, useMaterial3: true);
  final arabicTextTheme = GoogleFonts.notoKufiArabicTextTheme(base.textTheme);

  return base.copyWith(
    scaffoldBackgroundColor: kBg,
    textTheme: arabicTextTheme.copyWith(
      bodyLarge: arabicTextTheme.bodyLarge?.copyWith(color: kTextPrimary),
      bodyMedium: arabicTextTheme.bodyMedium?.copyWith(color: kTextPrimary),
    ),
    primaryTextTheme: arabicTextTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: kMedicalBlue,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
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
        minimumSize: const Size(double.infinity, 56),
        side: const BorderSide(color: kMedicalBlue),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: kBg,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: kMedicalBlue, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: kSurface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.zero,
    ),
  );
}
