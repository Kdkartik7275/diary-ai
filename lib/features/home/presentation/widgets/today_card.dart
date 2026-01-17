import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/config/routes/app_routes.dart';

class TodayCard extends StatelessWidget {
  const TodayCard({
    super.key,
    required this.width,
    required this.height,
    required this.theme,
  });

  final double width;
  final double height;
  final TextTheme theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height * 0.16,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: .85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          // Decorative background pattern
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: CustomPaint(painter: _CardPatternPainter()),
            ),
          ),

          // Main content
          Padding(
            padding: EdgeInsets.all(width * 0.045),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Header section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat(
                            'EEEE',
                          ).format(DateTime.now()).toUpperCase(),
                          style: theme.labelSmall?.copyWith(
                            color: Colors.white.withValues(alpha: .7),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: height * 0.004),
                        Text(
                          DateFormat('MMMM d, yyyy').format(DateTime.now()),
                          style: theme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(width * 0.025),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.edit_note_rounded,
                        color: Colors.white,
                        size: width * 0.06,
                      ),
                    ),
                  ],
                ),

                // Action section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Ready to write?",
                      style: theme.titleSmall?.copyWith(
                        color: Colors.white.withValues(alpha: .9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    InkWell(
                      onTap:()=> Get.toNamed(Routes.writeDiary),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.04,
                          vertical: height * 0.008,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: .1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Start Entry',
                              style: theme.titleLarge?.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(width: width * 0.015),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: AppColors.primary,
                              size: width * 0.045,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final circlePaint = Paint()
      ..color = Colors.white.withValues(alpha: .3)
      ..style = PaintingStyle.fill;

    // Top-right circle (partially off top-right)
    canvas.drawCircle(
      Offset(size.width * .96, size.height * -0.02),
      size.height * 0.25,
      circlePaint,
    );

    // Bottom-left circle (partially off bottom-left)
    canvas.drawCircle(
      Offset(size.width * 0.08, size.height * 0.90),
      size.height * 0.3,
      circlePaint,
    );

    // Subtle dots pattern
    final dotPaint = Paint()
      ..color = Colors.white.withValues(alpha: .1)
      ..style = PaintingStyle.fill;

    const double spacing = 35;
    const double radius = 2;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        // Slight offset for natural look
        canvas.drawCircle(
          Offset(x + spacing / 3, y + spacing / 4),
          radius,
          dotPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
