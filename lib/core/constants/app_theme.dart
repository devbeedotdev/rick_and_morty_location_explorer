import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();
  static const Color rickGreen = Color(0xFF97CE4C);
  static const Color mortyYellow = Color(0xFFF5C518);
  static const Color portalBlue = Color(0xFF00B5CC);
  static const Color darkBg = Color(0xFF111B21);
  static const Color darkSurface = Color(0xFF1E2D38);
  static const Color darkCard = Color(0xFF243447);
  static const Color textPrimary = Color(0xFFF0F0F0);
  static const Color textSecondary = Color(0xFF8899AA);
  static const Color errorRed = Color(0xFFE53935);
  static const Color aliveGreen = Color(0xFF4CAF50);
  static const Color deadRed = Color(0xFFF44336);
  static const Color unknownGrey = Color(0xFF9E9E9E);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: rickGreen,
        secondary: portalBlue,
        surface: darkSurface,
        error: errorRed,
        onPrimary: darkBg,
        onSecondary: darkBg,
        onSurface: textPrimary,
      ),
      scaffoldBackgroundColor: darkBg,
      cardColor: darkCard,
      textTheme: GoogleFonts.exoTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.exo(color: textPrimary, fontWeight: FontWeight.w700),
        titleLarge: GoogleFonts.exo(color: textPrimary, fontWeight: FontWeight.w600, fontSize: 20),
        titleMedium: GoogleFonts.exo(color: textPrimary, fontWeight: FontWeight.w500),
        bodyMedium: GoogleFonts.exo(color: textPrimary),
        bodySmall: GoogleFonts.exo(color: textSecondary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: textPrimary,
        elevation: 0,
        titleTextStyle: GoogleFonts.exo(
          color: rickGreen,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCard,
        hintStyle: const TextStyle(color: textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: rickGreen, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: darkCard,
        selectedColor: rickGreen.withOpacity(0.25),
        labelStyle: GoogleFonts.exo(color: textPrimary, fontSize: 13),
        side: const BorderSide(color: Colors.transparent),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'alive': return aliveGreen;
      case 'dead': return deadRed;
      default: return unknownGrey;
    }
  }
}
