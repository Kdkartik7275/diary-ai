import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifeline/config/constants/colors.dart';

class TTextTheme {
  TTextTheme._();

  static TextTheme get lightTextTheme => TextTheme(
    headlineLarge: GoogleFonts.aBeeZee(
      fontSize: 32,
      fontWeight: FontWeight.w900,
      color: AppColors.black,
    ),
    headlineMedium: GoogleFonts.aBeeZee(
      fontSize: 30,
      fontWeight: FontWeight.w700,
      color: AppColors.black,
    ),
    headlineSmall: GoogleFonts.aBeeZee(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: AppColors.black,
    ),
    titleLarge: GoogleFonts.aBeeZee(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.black,
    ),
    titleMedium: GoogleFonts.aBeeZee(
      fontSize: 19,
      fontWeight: FontWeight.w600,
      color: AppColors.black,
    ),
    titleSmall: GoogleFonts.aBeeZee(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.black,
    ),
  );
}

