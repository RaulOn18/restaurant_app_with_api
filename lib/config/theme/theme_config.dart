import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeConfig {
  static final TextTheme textTheme = TextTheme(
    displayLarge: GoogleFonts.manrope(
        fontSize: 95, fontWeight: FontWeight.w300, letterSpacing: -1.5),
    displayMedium: GoogleFonts.manrope(
        fontSize: 59, fontWeight: FontWeight.w300, letterSpacing: -0.5),
    displaySmall:
        GoogleFonts.manrope(fontSize: 48, fontWeight: FontWeight.w400),
    headlineMedium: GoogleFonts.manrope(
        fontSize: 34, fontWeight: FontWeight.w400, letterSpacing: 0.25),
    headlineSmall:
        GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.w400),
    titleLarge: GoogleFonts.manrope(
        fontSize: 20, fontWeight: FontWeight.w500, letterSpacing: 0.15),
    titleMedium: GoogleFonts.manrope(
        fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15),
    titleSmall: GoogleFonts.manrope(
        fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.1),
    bodyLarge: GoogleFonts.manrope(
        fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
    bodyMedium: GoogleFonts.manrope(
        fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
    labelLarge: GoogleFonts.manrope(
        fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
    bodySmall: GoogleFonts.manrope(
        fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
    labelSmall: GoogleFonts.manrope(
        fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
  );
}
