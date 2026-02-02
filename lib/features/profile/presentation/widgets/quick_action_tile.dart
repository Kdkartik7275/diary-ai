// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import 'package:lifeline/core/containers/rounded_container.dart';

class QuickActionTile extends StatelessWidget {
  const QuickActionTile({
    super.key,
    required this.theme,
    required this.label,
    required this.icon,
    required this.backgroundColor,
    this.onTap,
  });

  final TextTheme theme;
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
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
