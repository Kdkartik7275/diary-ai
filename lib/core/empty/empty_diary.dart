import 'package:flutter/material.dart';
import 'package:lifeline/config/constants/colors.dart';
import 'package:lottie/lottie.dart';

class EmptyDiaryState extends StatelessWidget {
  const EmptyDiaryState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Center(
        child: Column(
          children: [
            LottieBuilder.asset(
              'assets/json/writing_man.json',
              width: 200,
              height: 200,
            ),
        
            Text(
              "Your story starts here",
              style: theme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
            ),
        
            Text(
              "Write your first entry and begin your journey.",
              style: theme.titleSmall!.copyWith(
                color: AppColors.textLighter,
                fontWeight: FontWeight.normal,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
