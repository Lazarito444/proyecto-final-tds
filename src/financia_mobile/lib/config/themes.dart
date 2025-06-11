import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(),
  textTheme: TextTheme(
    titleLarge: GoogleFonts.gabarito(
      fontWeight: FontWeight.w700,
      fontSize: 24.spa,
      color: const Color(0xFF113931),
    ),
    titleSmall: GoogleFonts.gabarito(
      fontWeight: FontWeight.w600,
      fontSize: 16.spa,
      color: const Color(0xFF113931),
    ),
    labelMedium: GoogleFonts.outfit(fontSize: 15.spa),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(),
);
