// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:lifeline/config/constants/colors.dart';

class TCircularContainer extends StatelessWidget {
  const TCircularContainer({
    super.key,
    this.height = 400,
    this.width = 400,
    this.margin,
    this.child,
    this.showBorder = false,
    this.borderColor = AppColors.black,
    this.backgroundColor = AppColors.white,
  });

  final double? height;
  final double? width;

  final EdgeInsetsGeometry? margin;
  final Widget? child;
  final Color backgroundColor;
  final bool showBorder;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          border: showBorder ? Border.all(color: borderColor) : null),
      child: child,
    );
  }
}
