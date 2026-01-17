import 'package:flutter/material.dart';
import 'package:lifeline/config/constants/colors.dart';

// ignore: must_be_immutable
class AuthButton extends StatelessWidget {
  final String label;
  Function()? onPressed;
  final Size size;
  AuthButton({
    super.key,
    required this.label,
    this.onPressed,
    this.size = const Size(271, 51),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(fixedSize: size),
        onPressed: onPressed,
        child: Text(
          label,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: AppColors.white),
        ));
  }
}
