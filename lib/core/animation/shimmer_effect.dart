import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/config/theme/theme_controller.dart';

// ─── Public API ─────────────────────────────────────────────────────────────
//
// Wrap any widget tree with ShimmerWrapper to apply a shimmer effect.
//
// Usage:
//   ShimmerWrapper(
//     child: YourLoadingWidget(),
//   )
//
// Individual shimmer boxes inside the child:
//   ShimmerBox(width: 100, height: 12, borderRadius: BorderRadius.circular(8))
//   ShimmerBox.circle(size: 36)
//   ShimmerBox.fill(height: 180)   ← full width, e.g. image cover
//
// ────────────────────────────────────────────────────────────────────────────

class ShimmerWrapper extends GetView<ThemeController> {
  const ShimmerWrapper({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1400),
  });

  final Widget child;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _ShimmerEngine(
        isDarkMode: controller.isDarkMode,
        duration: duration,
        child: child,
      ),
    );
  }
}

// ─── Engine ──────────────────────────────────────────────────────────────────

class _ShimmerEngine extends StatefulWidget {
  const _ShimmerEngine({
    required this.child,
    required this.isDarkMode,
    required this.duration,
  });

  final Widget child;
  final bool isDarkMode;
  final Duration duration;

  @override
  State<_ShimmerEngine> createState() => _ShimmerEngineState();
}

class _ShimmerEngineState extends State<_ShimmerEngine>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ShimmerScope(
      animation: _controller,
      isDarkMode: widget.isDarkMode,
      child: widget.child,
    );
  }
}

// ─── Inherited scope ─────────────────────────────────────────────────────────

class _ShimmerScope extends InheritedWidget {
  const _ShimmerScope({
    required this.animation,
    required this.isDarkMode,
    required super.child,
  });

  final Animation<double> animation;
  final bool isDarkMode;

  static _ShimmerScope? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_ShimmerScope>();

  @override
  bool updateShouldNotify(_ShimmerScope old) =>
      animation != old.animation || isDarkMode != old.isDarkMode;
}

// ─── ShimmerBox ───────────────────────────────────────────────────────────────
//
// Place inside a ShimmerWrapper to render an animated placeholder box.

class ShimmerBox extends StatelessWidget {
  /// Explicit size box
  const ShimmerBox({
    super.key,
    this.width,
    required this.height,
    this.borderRadius,
  }) : _type = _BoxType.rect;

  /// Circle avatar placeholder
  const ShimmerBox.circle({super.key, required double size})
    : width = size,
      height = size,
      borderRadius = null,
      _type = _BoxType.circle;

  /// Full-width box (e.g. image cover) — set a custom borderRadius if needed
  const ShimmerBox.fill({super.key, required this.height, this.borderRadius})
    : width = double.infinity,
      _type = _BoxType.rect;

  final double? width;
  final double height;
  final BorderRadius? borderRadius;
  final _BoxType _type;

  @override
  Widget build(BuildContext context) {
    final scope = _ShimmerScope.of(context);

    // Fallback: static grey if used outside ShimmerWrapper
    if (scope == null) {
      return _staticBox();
    }

    return AnimatedBuilder(
      animation: scope.animation,
      builder: (context, _) {
        final double p = scope.animation.value;
        final Color base = scope.isDarkMode
            ? AppColors.filledDark
            : Colors.grey.shade300;
        final Color highlight = scope.isDarkMode
            ? Colors.grey.shade700
            : Colors.grey.shade100;

        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            shape: _type == _BoxType.circle
                ? BoxShape.circle
                : BoxShape.rectangle,
            borderRadius: _type == _BoxType.circle ? null : borderRadius,
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [base, highlight, base],
              stops: [
                (p - 0.3).clamp(0.0, 1.0),
                p.clamp(0.0, 1.0),
                (p + 0.3).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _staticBox() => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      shape: _type == _BoxType.circle ? BoxShape.circle : BoxShape.rectangle,
      borderRadius: _type == _BoxType.circle ? null : borderRadius,
      color: Colors.grey.shade300,
    ),
  );
}

enum _BoxType { rect, circle }
