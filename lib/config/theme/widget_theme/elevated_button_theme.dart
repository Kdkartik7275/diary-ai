import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifeline/config/constants/colors.dart';

class TElevatedButtonTheme {
  TElevatedButtonTheme._();

  /* -- Light Theme -- */
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColors.white,
      backgroundColor: AppColors.primary,
      disabledForegroundColor: AppColors.filled,
      disabledBackgroundColor: AppColors.filled,
      side: const BorderSide(color: AppColors.primary),
      padding: const EdgeInsets.all(10),
      textStyle: GoogleFonts.aBeeZee().copyWith(
          fontSize: 16, color: AppColors.white, fontWeight: FontWeight.w700),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
