// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:mindloom/config/constants/colors.dart';

import 'package:mindloom/features/feedback/presentation/widgets/bug_dropdown.dart';
import 'package:mindloom/features/feedback/presentation/widgets/issue_details.dart';

class BugOrCrashReport extends StatefulWidget {
  const BugOrCrashReport({super.key,required this.isDarkMode});
  final bool isDarkMode;

  @override
  State<BugOrCrashReport> createState() => _BugOrCrashReportState();
}

class _BugOrCrashReportState extends State<BugOrCrashReport> {
  String? selectedCategory;
  bool _open = false;
  final LayerLink _link = LayerLink();
  OverlayEntry? _overlay;

  final List<String> categories = [
    'App Crash',
    'Screen Freezes',
    'Login / Auth Issue',
    'Story Generation Bug',
    'UI / Display Glitch',
    'Slow Performance',
    'Data Not Saving',
    'Other',
  ];

  void _openDropdown(BuildContext context) {
    setState(() => _open = true);

    final renderBox = context.findRenderObject() as RenderBox;
    final triggerWidth = renderBox.size.width;

    _overlay = OverlayEntry(
      builder: (_) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _closeDropdown,
          child: Stack(
            children: [
              CompositedTransformFollower(
                link: _link,
                showWhenUnlinked: false,
                offset: const Offset(0, 60),
                child: Material(
                  color: Colors.transparent,
                  child: SizedBox(
                    width: triggerWidth,
                    child: BugDropdownMenu(
                      items: categories,
                      isDarkMode: widget.isDarkMode,
                      selected: selectedCategory,
                      onSelect: (val) {
                        setState(() => selectedCategory = val);
                        _closeDropdown();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    Overlay.of(context).insert(_overlay!);
  }

  void _closeDropdown() {
    _overlay?.remove();
    _overlay = null;
    if (mounted) setState(() => _open = false);
  }

  @override
  void dispose() {
    _overlay?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Bug Category', style: theme.titleLarge),
        const SizedBox(height: 12),

        CompositedTransformTarget(
          link: _link,
          child: GestureDetector(
            onTap: _open ? _closeDropdown : () => _openDropdown(context),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 56,
              decoration: BoxDecoration(
                color:widget.isDarkMode ?AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _open
                      ? const Color(0xFFE05C5C)
                      : const Color(0xFFE2E4EC),
                  width: _open ? 1.8 : 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .07),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedCategory ?? 'Select a category...',
                      style: selectedCategory != null
                          ? theme.titleLarge!.copyWith(fontSize: 14)
                          : theme.titleLarge?.copyWith(fontSize: 14),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _open ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF6B6B8A),
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        IssueDetails(
          title: 'Describe the issue',
          hintText:
              'What were you doing when it crashed? What happened? Please be detailed as possible...',
          controller: TextEditingController(),
        ),
      ],
    );
  }
}
