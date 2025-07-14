import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

//Tema Claro

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Colors.white,
    primary: Color.fromARGB(255, 31, 133, 119),
    onSurface: Color(0xFF113931),
    primaryContainer: Color(0xFFB8E6C1),
    secondaryContainer: Colors.white,
    tertiaryContainer: Colors.white,
    onSurfaceVariant: Colors.black,
    outline: Colors.grey.shade600,
    surfaceContainerLow: Color(0xFFE8F5F3),
    surfaceContainerLowest: Color(0xFF4A9B8E),
  ),
  scaffoldBackgroundColor: Colors.white,
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: Color.fromARGB(255, 31, 133, 119),
    circularTrackColor: Colors.green.shade100,
    linearTrackColor: Colors.green.shade100,
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.red.shade800,
    contentTextStyle: GoogleFonts.outfit(
      fontSize: 14.spa,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ),
  ),
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

//Tema Oscuro

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: const Color(0xFF242425),
    primary: const Color(0xFF374050),
    onSurface: Colors.white,
    primaryContainer: const Color(0xFF262726),
    secondaryContainer: const Color(0xFF1e2936),
    tertiaryContainer: const Color(0xFF1f1f1e),
    onSurfaceVariant: Colors.white,
    outline: const Color(0xFFd1d5db),
    surfaceContainerLow: const Color(0xFF374050),
    surfaceContainerLowest: const Color(0xFFd1d5db),
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: const Color(0xFF374050),
    circularTrackColor: Colors.grey.shade700,
    linearTrackColor: Colors.grey.shade700,
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.red.shade800,
    contentTextStyle: GoogleFonts.outfit(
      fontSize: 14.spa,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ),
  ),
  textTheme: TextTheme(
    titleLarge: GoogleFonts.gabarito(
      fontWeight: FontWeight.w700,
      fontSize: 24.spa,
      color: Colors.white,
    ),
    titleMedium: GoogleFonts.gabarito(
      fontWeight: FontWeight.w600,
      fontSize: 20.spa,
      color: Colors.white,
    ),
    titleSmall: GoogleFonts.gabarito(
      fontWeight: FontWeight.w600,
      fontSize: 16.spa,
      color: Colors.white,
    ),
    labelLarge: GoogleFonts.outfit(fontSize: 17.spa, color: Colors.white),
    labelMedium: GoogleFonts.outfit(fontSize: 15.spa, color: Colors.white),
    labelSmall: GoogleFonts.outfit(fontSize: 14.spa, color: Colors.white),
  ),
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade600, width: 3),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 3),
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
