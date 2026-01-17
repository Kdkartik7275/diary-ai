import 'package:flutter/material.dart';
import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/core/containers/rounded_container.dart';

class PersonalInfoTile extends StatelessWidget {
  const PersonalInfoTile({
    super.key,
    required this.height,
    required this.width,
    required this.title,
    required this.value,
    required this.backgroundColor,
    required this.icon,
  });

  final double height;
  final double width;
  final String title;
  final String value;
  final Color backgroundColor;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return ListTile(
      leading: TRoundedContainer(
        height: height * .1,
        width: width * .09,
        radius: 12,
        backgroundColor: backgroundColor.withValues(alpha: .2),
        child: Icon(icon, color: backgroundColor, size: 20),
      ),
      title: Text(
        title,
        style: theme.titleLarge!.copyWith(
          fontWeight: FontWeight.normal,
          color: AppColors.textLighter.withValues(alpha: .7),
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        value,
        style: theme.titleSmall!.copyWith(fontWeight: FontWeight.normal),
      ),
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      minVerticalPadding: 0,
      visualDensity: const VisualDensity(vertical: -4),
    );
  }
}
