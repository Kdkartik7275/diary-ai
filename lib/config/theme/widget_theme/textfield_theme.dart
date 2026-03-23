import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindloom/config/constants/colors.dart';

class TTextFormFieldTheme {
  TTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: const Color.fromRGBO(0, 0, 0, 0.5),
    suffixIconColor: const Color.fromRGBO(0, 0, 0, 0.5),
    labelStyle: GoogleFonts.aBeeZee(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.hintText,
    ),
    hintStyle: GoogleFonts.aBeeZee(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.hintText,
    ),
    filled: true,
    fillColor: AppColors.white,
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(width: 1, color: AppColors.white),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(width: 1, color: AppColors.white),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(width: 1, color: AppColors.focusedBorder),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(width: 1, color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(width: 1, color: Colors.red),
    ),
  );
  static InputDecorationTheme darkInputDecorationTheme =
    InputDecorationTheme(
  errorMaxLines: 3,
  prefixIconColor: AppColors.textDarkSecondary,
  suffixIconColor: AppColors.textDarkSecondary,

  labelStyle: GoogleFonts.aBeeZee(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textDarkSecondary,
  ),
  hintStyle: GoogleFonts.aBeeZee(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textDarkSecondary,
  ),

  filled: true,
  fillColor: AppColors.filledDark,

  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: AppColors.filledDark),
  ),

  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: AppColors.filledDark),
  ),

  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: AppColors.primary),
  ),

  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: Colors.red),
  ),

  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: Colors.red),
  ),
);
}
