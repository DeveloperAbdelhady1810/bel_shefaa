import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Color Tokens — Premium Arabic Clinical ──────────────────────────────────

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
const Color kBg               = Color(0xFFF8FAFC); // off-white scaffold
const Color kSurface          = Color(0xFFFFFFFF); // card surface
const Color kDivider          = Color(0xFFE8EEF4); // borders

// Text
const Color kTextPrimary      = Color(0xFF0B1F3A); // deep navy
const Color kTextSecondary    = Color(0xFF64748B); // slate gray

// Semantic
const Color kSuccess          = Color(0xFF10B981);
const Color kSuccessLight     = Color(0xFFD1FAE5);
const Color kWarning          = Color(0xFFF59E0B);
const Color kWarningLight     = Color(0xFFFEF3C7);
const Color kError            = Color(0xFFEF4444);
const Color kErrorLight       = Color(0xFFFEE2E2);

// Shadows
const Color kShadowBlue       = Color(0x141A6FA8); // 8% blue
const Color kShadowDeep       = Color(0x1A0B1F3A); // 10% navy

// Legacy aliases kept for backward compat
const Color kCardShadowBlue   = kShadowBlue;
const Color kGreenLight       = kSuccessLight;

// ─── Card Decoration Helper ───────────────────────────────────────────────────
BoxDecoration kCardDecoration({
  double radius = 20,
  Color color = kSurface,
}) =>
    BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: kDivider, width: 1),
      boxShadow: const [
        BoxShadow(color: kShadowBlue, blurRadius: 20, offset: Offset(0, 6)),
        BoxShadow(color: kShadowDeep, blurRadius: 4, offset: Offset(0, 2)),
      ],
    );

// ─── Theme ────────────────────────────────────────────────────────────────────
ThemeData buildAppTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: kMedicalBlue,
    brightness: Brightness.light,
  );
  final base = ThemeData(colorScheme: colorScheme, useMaterial3: true);
  // Cairo as primary, NotoKufiArabic as body fallback via TextTheme
  final cairoTextTheme = GoogleFonts.cairoTextTheme(base.textTheme);

  return base.copyWith(
    scaffoldBackgroundColor: kBg,
    textTheme: cairoTextTheme.copyWith(
      bodyLarge:   cairoTextTheme.bodyLarge?.copyWith(
          fontFamily: GoogleFonts.notoKufiArabic().fontFamily,
          color: kTextPrimary),
      bodyMedium:  cairoTextTheme.bodyMedium?.copyWith(
          fontFamily: GoogleFonts.notoKufiArabic().fontFamily,
          color: kTextPrimary),
      bodySmall:   cairoTextTheme.bodySmall?.copyWith(
          fontFamily: GoogleFonts.notoKufiArabic().fontFamily,
          color: kTextSecondary),
    ),
    primaryTextTheme: cairoTextTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: kMedicalBlue,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: GoogleFonts.cairo(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: kMedicalBlue,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: GoogleFonts.cairo(
            fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: kMedicalBlue,
        minimumSize: const Size(double.infinity, 56),
        side: const BorderSide(color: kMedicalBlue),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle:
            GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w600),
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
        borderSide: const BorderSide(color: kDivider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: kMedicalBlue, width: 2),
      ),
      labelStyle: GoogleFonts.notoKufiArabic(color: kTextSecondary, fontSize: 14),
      hintStyle:  GoogleFonts.notoKufiArabic(color: kTextSecondary, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: kSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: kDivider, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),
    dividerColor: kDivider,
  );
}
