import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mindloom/config/constants/colors.dart';

class AnimatedNotificationBell extends StatefulWidget {
  final int unreadCount;
  final VoidCallback onTap;

  const AnimatedNotificationBell({
    super.key,
    required this.unreadCount,
    required this.onTap,
  });

  @override
  State<AnimatedNotificationBell> createState() =>
      _AnimatedNotificationBellState();
}

class _AnimatedNotificationBellState extends State<AnimatedNotificationBell>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    if (widget.unreadCount > 0) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedNotificationBell oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.unreadCount > oldWidget.unreadCount && widget.unreadCount > 0) {
      _controller.forward(from: 0); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: widget.onTap,
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(CupertinoIcons.bell, size: 24),

          if (widget.unreadCount > 0)
            Positioned(
              right: -6,
              top: -10,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.white, width: 2),
                  ),
                  child: Text(
                    widget.unreadCount > 99
                        ? "99+"
                        : widget.unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
