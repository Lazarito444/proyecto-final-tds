import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(surface: Colors.white),
  textTheme: TextTheme(
    titleLarge: GoogleFonts.gabarito(
      fontWeight: FontWeight.w700,
      fontSize: 24.spa,
      color: const Color(0xFF113931),
    ),
    titleMedium: GoogleFonts.gabarito(
      fontWeight: FontWeight.w600,
      fontSize: 20.spa,
      color: const Color(0xFF113931),
    ),
    titleSmall: GoogleFonts.gabarito(
      fontWeight: FontWeight.w600,
      fontSize: 16.spa,
      color: const Color(0xFF113931),
    ),
    labelLarge: GoogleFonts.outfit(fontSize: 17.spa),
    labelMedium: GoogleFonts.outfit(fontSize: 15.spa),
    labelSmall: GoogleFonts.outfit(fontSize: 14.spa),
  ),
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.green.shade200, width: 3),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.green.shade400, width: 3),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.red.shade400, width: 3),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.red.shade600, width: 3),
    ),
    errorStyle: GoogleFonts.outfit(
      fontSize: 12.spa,
      color: Colors.red,
      fontWeight: FontWeight.w500,
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(),
);
