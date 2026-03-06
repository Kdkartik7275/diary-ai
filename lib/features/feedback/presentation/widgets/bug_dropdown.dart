import 'package:flutter/material.dart';

class BugDropdownMenu extends StatelessWidget {
  final List<String> items;
  final String? selected;
  final ValueChanged<String> onSelect;

  const BugDropdownMenu({
    super.key,
    required this.items,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .10),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(items.length, (i) {
            final item = items[i];
            final isLast = i == items.length - 1;
            return _MenuItem(
              label: item,
              isSelected: item == selected,
              showDivider: !isLast,
              theme: Theme.of(context).textTheme,
              onTap: () => onSelect(item),
            );
          }),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool showDivider;
  final TextTheme theme;
  final VoidCallback onTap;

  const _MenuItem({
    required this.label,
    required this.isSelected,
    required this.showDivider,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            color: isSelected ? const Color(0xFFFDF0EF) : Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            width: double.infinity,
            child: Text(
              label,
              style: theme.titleLarge?.copyWith(
                fontWeight: FontWeight.normal,
                fontSize: 14
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: const Color(0xFFE2E4EC).withValues(alpha: .6),
            indent: 20,
            endIndent: 20,
          ),
      ],
    );
  }
}
