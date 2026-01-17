
import 'package:flutter/material.dart';
import 'package:lifeline/core/containers/rounded_container.dart';

class QuickActionTile extends StatelessWidget {
  const QuickActionTile({
    super.key,
    required this.theme,
    required this.label,
    required this.icon,
    required this.backgroundColor,
  });

  final TextTheme theme;
  final String label;
  final IconData icon;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        label,
        style: theme.titleLarge!.copyWith(fontWeight: FontWeight.normal,fontSize: 15),
      ),
      leading: TRoundedContainer(
        height: 40,
        width: 40,
        radius: 12,
        backgroundColor: backgroundColor.withValues(alpha: .1),
        child: Icon(icon, color: backgroundColor),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: Colors.grey.shade400,
      ),
    );
  }
}
