import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lifeline/config/constants/colors.dart';

class TAppBarTheme {
  TAppBarTheme._();

  static AppBarTheme lightAppBarTheme = AppBarTheme(
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      iconTheme: const IconThemeData(color: AppColors.black),
      actionsIconTheme: const IconThemeData(color: AppColors.black),
      titleTextStyle: GoogleFonts.aBeeZee(
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: AppColors.black));
}
