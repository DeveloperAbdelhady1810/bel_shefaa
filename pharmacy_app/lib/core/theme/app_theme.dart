import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Color constants ───────────────────────────────────────────────────────────
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
const Color kCardShadowBlue   = Color(0x141A6FA8); // 8% blue

// ─── Theme builder ─────────────────────────────────────────────────────────────
ThemeData buildAppTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: kMedicalBlue,
    brightness: Brightness.light,
    surface: kSurface,
  );

  final base = ThemeData(colorScheme: colorScheme, useMaterial3: true);
  final arabicTextTheme = GoogleFonts.notoKufiArabicTextTheme(base.textTheme)
      .apply(bodyColor: kTextPrimary, displayColor: kTextPrimary);

  return base.copyWith(
    scaffoldBackgroundColor: kBg,
    textTheme: arabicTextTheme,
    primaryTextTheme: arabicTextTheme,

    // AppBar — gradient set via flexibleSpace in each screen; base is transparent
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      titleTextStyle: GoogleFonts.notoKufiArabic(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    ),

    // Cards — elevation 0, rounded, white
    cardTheme: CardThemeData(
      elevation: 0,
      color: kSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.zero,
    ),

    // ElevatedButton — transparent base; screens use custom gradient containers
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        shadowColor: Colors.transparent,
        elevation: 0,
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: GoogleFonts.notoKufiArabic(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),

    // Input fields
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: kError),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: kError, width: 2),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      labelStyle: const TextStyle(color: kTextSecondary),
      hintStyle: const TextStyle(color: kTextSecondary),
      prefixIconColor: kTextSecondary,
    ),
  );
}
