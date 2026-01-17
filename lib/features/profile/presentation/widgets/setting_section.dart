import 'package:flutter/material.dart';
import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/core/containers/rounded_container.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return TRoundedContainer(
      margin: EdgeInsets.zero,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: .07),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: Text(title, style: theme.titleLarge),
          ),
          Divider(color: AppColors.border.withValues(alpha: .3)),
          ..._buildTiles(),
        ],
      ),
    );
  }

  List<Widget> _buildTiles() {
    final widgets = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      widgets.add(children[i]);
      if (i != children.length - 1) {
        widgets.add(Divider(color: AppColors.border.withValues(alpha: .3)));
      }
    }
    return widgets;
  }
}
