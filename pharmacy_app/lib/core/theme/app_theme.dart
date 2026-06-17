import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Color tokens — Premium Arabic Clinical ────────────────────────────────────

// Brand
const Color kMedicalBlue      = Color(0xFF1A6FA8);
const Color kMedicalBlueDark  = Color(0xFF0D4F7A);
const Color kMedicalBlueLight = Color(0xFFD6EAFA);

// Warm amber accent (premium feel)
const Color kAmber            = Color(0xFFF59E0B);
const Color kAmberLight       = Color(0xFFFEF3C7);

// Deep navy text (not cold black)
const Color kDeepNavy         = Color(0xFF0B1F3A);

// Backgrounds
const Color kBg               = Color(0xFFF8FAFC);   // off-white scaffold
const Color kSurface          = Color(0xFFFFFFFF);   // card surface
const Color kDivider          = Color(0xFFE8EEF4);   // borders

// Text
const Color kTextPrimary      = Color(0xFF0B1F3A);   // deep navy
const Color kTextSecondary    = Color(0xFF64748B);   // slate gray

// Semantic
const Color kSuccess          = Color(0xFF10B981);
const Color kSuccessLight     = Color(0xFFD1FAE5);
const Color kWarning          = Color(0xFFF59E0B);
const Color kWarningLight     = Color(0xFFFEF3C7);
const Color kError            = Color(0xFFEF4444);
const Color kErrorLight       = Color(0xFFFEE2E2);

// Shadows
const Color kShadowBlue       = Color(0x141A6FA8);   // 8% blue
const Color kShadowDeep       = Color(0x1A0B1F3A);   // 10% navy

// Legacy alias for backward compatibility
const Color kCardShadowBlue   = kShadowBlue;

// ─── Theme builder ─────────────────────────────────────────────────────────────
ThemeData buildAppTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: kMedicalBlue,
    brightness: Brightness.light,
    surface: kSurface,
  );

  final base = ThemeData(colorScheme: colorScheme, useMaterial3: true);

  // Cairo as primary display/headline font, Noto Kufi Arabic for body
  final cairoTextTheme = GoogleFonts.cairoTextTheme(base.textTheme).copyWith(
    displayLarge: GoogleFonts.cairo(
      fontWeight: FontWeight.w800,
      fontSize: 26,
      color: kTextPrimary,
    ),
    displayMedium: GoogleFonts.cairo(
      fontWeight: FontWeight.w800,
      fontSize: 22,
      color: kTextPrimary,
    ),
    displaySmall: GoogleFonts.cairo(
      fontWeight: FontWeight.w800,
      fontSize: 20,
      color: kTextPrimary,
    ),
    headlineLarge: GoogleFonts.cairo(
      fontWeight: FontWeight.w700,
      fontSize: 18,
      color: kTextPrimary,
    ),
    headlineMedium: GoogleFonts.cairo(
      fontWeight: FontWeight.w700,
      fontSize: 16,
      color: kTextPrimary,
    ),
    titleLarge: GoogleFonts.cairo(
      fontWeight: FontWeight.w700,
      fontSize: 18,
      color: kTextPrimary,
    ),
    titleMedium: GoogleFonts.cairo(
      fontWeight: FontWeight.w700,
      fontSize: 16,
      color: kTextPrimary,
    ),
    titleSmall: GoogleFonts.cairo(
      fontWeight: FontWeight.w600,
      fontSize: 14,
      color: kTextPrimary,
    ),
    bodyLarge: GoogleFonts.notoKufiArabic(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: kTextSecondary,
    ),
    bodyMedium: GoogleFonts.notoKufiArabic(
      fontSize: 14,
      color: kTextSecondary,
    ),
    bodySmall: GoogleFonts.notoKufiArabic(
      fontSize: 12,
      color: kTextSecondary,
    ),
    labelLarge: GoogleFonts.cairo(
      fontWeight: FontWeight.w700,
      fontSize: 16,
      color: kTextPrimary,
    ),
    labelMedium: GoogleFonts.notoKufiArabic(
      fontSize: 13,
      color: kTextSecondary,
    ),
    labelSmall: GoogleFonts.notoKufiArabic(
      fontSize: 12,
      color: kTextSecondary,
    ),
  );

  return base.copyWith(
    scaffoldBackgroundColor: kBg,
    textTheme: cairoTextTheme,
    primaryTextTheme: cairoTextTheme,

    // AppBar — gradient set via flexibleSpace on list/main screens;
    // detail screens use flat white AppBar per design spec
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
      titleTextStyle: GoogleFonts.cairo(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    ),

    // Cards — elevation 0, rounded, white, dual shadow applied in widgets
    cardTheme: CardThemeData(
      elevation: 0,
      color: kSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: kDivider, width: 1),
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
        textStyle: GoogleFonts.cairo(
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
        borderSide: const BorderSide(color: kDivider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: kDivider),
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      labelStyle: GoogleFonts.notoKufiArabic(color: kTextSecondary),
      hintStyle: GoogleFonts.notoKufiArabic(color: kTextSecondary),
      prefixIconColor: kTextSecondary,
    ),

    dividerTheme: const DividerThemeData(
      color: kDivider,
      thickness: 1,
      space: 1,
    ),
  );
}
