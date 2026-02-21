import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lifeline/config/constants/colors.dart';

Future<void> showPublishSuccessDialog(
  BuildContext context, {
  required String storyTitle,
}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black.withValues(alpha: .6),
    transitionDuration: const Duration(milliseconds: 500),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
      );
      return ScaleTransition(
        scale: Tween<double>(begin: .85, end: 1).animate(curved),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return _PublishSuccessDialog(storyTitle: storyTitle);
    },
  );
}

const _primary = AppColors.primary;
const _primaryDark = Color.fromRGBO(210, 90, 78, 1);
const _green = Color.fromRGBO(0, 109, 24, 1);
const _textLighter = AppColors.textLighter;
class _PublishSuccessDialog extends StatefulWidget {
  const _PublishSuccessDialog({required this.storyTitle});
  final String storyTitle;

  @override
  State<_PublishSuccessDialog> createState() => _PublishSuccessDialogState();
}

class _PublishSuccessDialogState extends State<_PublishSuccessDialog>
    with TickerProviderStateMixin {
  late final AnimationController _checkCtrl;
  late final AnimationController _burstCtrl;
  late final AnimationController _rippleCtrl;
  late final AnimationController _textCtrl;
  late final AnimationController _shimmerCtrl;
  late final AnimationController _floatCtrl;

  late final Animation<double> _checkDraw;
  late final Animation<double> _circleScale;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;

  late final List<_Particle> _burst;
  late final List<_FloatingPetal> _petals;

  @override
  void initState() {
    super.initState();

    _checkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _checkDraw = CurvedAnimation(
      parent: _checkCtrl,
      curve: const Interval(.3, 1, curve: Curves.easeOutCubic),
    );
    _circleScale = CurvedAnimation(
      parent: _checkCtrl,
      curve: const Interval(0, .45, curve: Curves.elasticOut),
    );

    _burstCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    final rng = math.Random(7);
    _burst = List.generate(22, (_) => _Particle.random(rng));

    _rippleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();

    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _textFade = CurvedAnimation(parent: _textCtrl, curve: Curves.easeIn);
    _textSlide = Tween<Offset>(
      begin: const Offset(0, .4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOutCubic));

    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
    final rng2 = math.Random(13);
    _petals = List.generate(10, (_) => _FloatingPetal.random(rng2));

    Future.delayed(const Duration(milliseconds: 80), () {
      if (!mounted) return;
      _checkCtrl.forward();
      _burstCtrl.forward();
      Future.delayed(const Duration(milliseconds: 400), () {
        if (!mounted) return;
        _textCtrl.forward();
      });
    });
  }

  @override
  void dispose() {
    _checkCtrl.dispose();
    _burstCtrl.dispose();
    _rippleCtrl.dispose();
    _textCtrl.dispose();
    _shimmerCtrl.dispose();
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: size.width * .84,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: _primary.withValues(alpha: .25),
                blurRadius: 50,
                spreadRadius: 0,
                offset: const Offset(0, 20),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: .06),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Stack(
              children: [
                // Floating petal background
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _floatCtrl,
                    builder: (_, _) => CustomPaint(
                      painter: _FloatingPetalsPainter(
                        petals: _petals,
                        progress: _floatCtrl.value,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 36, 28, 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Icon cluster ──────────────────────────
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Ripple rings
                            AnimatedBuilder(
                              animation: _rippleCtrl,
                              builder: (_, _) => CustomPaint(
                                size: const Size(140, 140),
                                painter: _RipplePainter(
                                  progress: _rippleCtrl.value,
                                ),
                              ),
                            ),

                            // Burst confetti
                            AnimatedBuilder(
                              animation: _burstCtrl,
                              builder: (_, _) => CustomPaint(
                                size: const Size(140, 140),
                                painter: _BurstPainter(
                                  particles: _burst,
                                  progress: _burstCtrl.value,
                                ),
                              ),
                            ),

                            // Gradient circle
                            AnimatedBuilder(
                              animation: _circleScale,
                              builder: (_, _) => Transform.scale(
                                scale: _circleScale.value,
                                child: Container(
                                  width: 86,
                                  height: 86,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const RadialGradient(
                                      colors: [_primary, _primaryDark],
                                      center: Alignment(-0.3, -0.3),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: _primary.withValues(alpha: .45),
                                        blurRadius: 24,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Gloss highlight
                            AnimatedBuilder(
                              animation: _circleScale,
                              builder: (_, _) => Transform.scale(
                                scale: _circleScale.value,
                                child: Container(
                                  width: 86,
                                  height: 86,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        Colors.white.withValues(alpha: .28),
                                        Colors.transparent,
                                      ],
                                      center: const Alignment(-.4, -.55),
                                      radius: .65,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Checkmark
                            AnimatedBuilder(
                              animation: _checkDraw,
                              builder: (_, _) => CustomPaint(
                                size: const Size(44, 44),
                                painter: _CheckPainter(
                                  progress: _checkDraw.value,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ── Text block ────────────────────────────
                      SlideTransition(
                        position: _textSlide,
                        child: FadeTransition(
                          opacity: _textFade,
                          child: Column(
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(
                                      colors: [_primary, _primaryDark],
                                    ).createShader(bounds),
                                child: Text(
                                  'Story Published!',
                                  style: (theme.titleLarge ?? const TextStyle())
                                      .copyWith(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 20,
                                        color: Colors.white,
                                        letterSpacing: -.3,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ),

                              const SizedBox(height: 4),
                              const Text(
                                '🎉 ✨ 🎊',
                                style: TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 12),

                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: (theme.titleSmall ?? const TextStyle())
                                      .copyWith(
                                        color: _textLighter,
                                        fontWeight: FontWeight.normal,
                                        height: 1.6,
                                        fontSize: 14,
                                      ),
                                  children: [
                                    const TextSpan(text: 'Your story '),
                                    TextSpan(
                                      text: '"${widget.storyTitle}"',
                                      style: const TextStyle(
                                        color: _primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const TextSpan(
                                      text:
                                          ' is now live and\nvisible to all readers.',
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Live badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: _green.withValues(alpha: .08),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: _green.withValues(alpha: .25),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _PulsingDot(),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Live Now',
                                      style: theme.titleSmall?.copyWith(
                                        color: _green,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: .3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── Button ────────────────────────────────
                      FadeTransition(
                        opacity: _textFade,
                        child: _ShimmerButton(
                          shimmerCtrl: _shimmerCtrl,
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ),

                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Pulsing green dot
// ─────────────────────────────────────────────

class _PulsingDot extends StatefulWidget {
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _green.withValues(alpha: .5 + _ctrl.value * .5),
          boxShadow: [
            BoxShadow(
              color: _green.withValues(alpha: .4 * _ctrl.value),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Shimmer button
// ─────────────────────────────────────────────

class _ShimmerButton extends StatelessWidget {
  const _ShimmerButton({required this.shimmerCtrl, required this.onTap});

  final AnimationController shimmerCtrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: shimmerCtrl,
        builder: (_, _) => Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [_primary, _primaryDark, _primary],
            ),
            boxShadow: [
              BoxShadow(
                color: _primary.withValues(alpha: .4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _ShimmerPainter(progress: shimmerCtrl.value),
                  ),
                ),
                Text(
                  'Awesome! 🚀',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    letterSpacing: .3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CustomPainters
// ─────────────────────────────────────────────

class _CheckPainter extends CustomPainter {
  const _CheckPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final path = Path()
      ..moveTo(cx - 12, cy + 1)
      ..lineTo(cx - 4, cy + 9)
      ..lineTo(cx + 13, cy - 10);

    final metrics = path.computeMetrics().toList();
    final total = metrics.fold<double>(0, (s, m) => s + m.length);
    double remaining = total * progress;
    for (final metric in metrics) {
      final take = remaining.clamp(0.0, metric.length);
      if (take > 0) canvas.drawPath(metric.extractPath(0, take), paint);
      remaining -= take;
    }
  }

  @override
  bool shouldRepaint(_CheckPainter o) => o.progress != progress;
}

class _RipplePainter extends CustomPainter {
  const _RipplePainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    for (int i = 0; i < 3; i++) {
      final t = (progress + i / 3) % 1.0;
      final eased = Curves.easeOut.transform(t);
      final radius = 43.0 + eased * 35;
      final opacity = (1.0 - eased) * .18;
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..color = _primary.withValues(alpha: opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5,
      );
    }
  }

  @override
  bool shouldRepaint(_RipplePainter o) => o.progress != progress;
}

class _BurstPainter extends CustomPainter {
  const _BurstPainter({required this.particles, required this.progress});
  final List<_Particle> particles;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;
    final center = Offset(size.width / 2, size.height / 2);
    final eased = Curves.easeOut.transform(progress);

    for (final p in particles) {
      final opacity = (1.0 - eased).clamp(0.0, 1.0);
      if (opacity <= 0) continue;

      final dx = math.cos(p.angle) * p.speed * eased;
      final dy =
          math.sin(p.angle) * p.speed * eased + p.gravity * eased * eased;
      final pos = center + Offset(dx, dy);

      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(p.rotation + p.rotSpeed * progress * math.pi * 2);

      final paint = Paint()..color = p.color.withValues(alpha: opacity);
      if (p.isCircle) {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset.zero,
            width: p.size,
            height: p.size * .55,
          ),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_BurstPainter o) => o.progress != progress;
}

class _FloatingPetalsPainter extends CustomPainter {
  const _FloatingPetalsPainter({required this.petals, required this.progress});
  final List<_FloatingPetal> petals;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    for (final petal in petals) {
      final t = (progress + petal.offset) % 1.0;
      final y = size.height * (1 - t) - 10;
      final x =
          petal.x * size.width + math.sin(t * math.pi * 2 + petal.sway) * 18;
      final opacity = math.sin(t * math.pi).clamp(0.0, 1.0) * 0.18;
      if (opacity <= 0.01) continue;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(t * math.pi * petal.rotDir);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset.zero,
          width: petal.size,
          height: petal.size * .55,
        ),
        Paint()..color = petal.color.withValues(alpha: opacity),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_FloatingPetalsPainter o) => o.progress != progress;
}

class _ShimmerPainter extends CustomPainter {
  const _ShimmerPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final x = -size.width + progress * size.width * 2.5;
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = LinearGradient(
          colors: [
            Colors.transparent,
            Colors.white.withValues(alpha: .22),
            Colors.transparent,
          ],
          stops: const [0, .5, 1],
        ).createShader(Rect.fromLTWH(x, 0, size.width * .6, size.height)),
    );
  }

  @override
  bool shouldRepaint(_ShimmerPainter o) => o.progress != progress;
}

// ─────────────────────────────────────────────
// Data models
// ─────────────────────────────────────────────

class _Particle {
  const _Particle({
    required this.angle,
    required this.speed,
    required this.color,
    required this.size,
    required this.rotation,
    required this.rotSpeed,
    required this.gravity,
    required this.isCircle,
  });

  factory _Particle.random(math.Random rng) {
    const colors = [
      _primary,
      _green,
      Color(0xFFFFD166),
      Color(0xFF06D6A0),
      _primaryDark,
      Color(0xFFFF6584),
    ];
    return _Particle(
      angle: rng.nextDouble() * 2 * math.pi,
      speed: 34 + rng.nextDouble() * 32,
      color: colors[rng.nextInt(colors.length)],
      size: 5 + rng.nextDouble() * 5,
      rotation: rng.nextDouble() * math.pi,
      rotSpeed: rng.nextDouble() * 3 - 1.5,
      gravity: 10 + rng.nextDouble() * 20,
      isCircle: rng.nextBool(),
    );
  }

  final double angle;
  final double speed;
  final Color color;
  final double size;
  final double rotation;
  final double rotSpeed;
  final double gravity;
  final bool isCircle;
}

class _FloatingPetal {
  const _FloatingPetal({
    required this.x,
    required this.offset,
    required this.size,
    required this.color,
    required this.sway,
    required this.rotDir,
  });

  factory _FloatingPetal.random(math.Random rng) {
    const colors = [_primary, _green, Color(0xFFFFD166)];
    return _FloatingPetal(
      x: rng.nextDouble(),
      offset: rng.nextDouble(),
      size: 8 + rng.nextDouble() * 10,
      color: colors[rng.nextInt(colors.length)],
      sway: rng.nextDouble() * math.pi * 2,
      rotDir: rng.nextBool() ? 1.0 : -1.0,
    );
  }

  final double x;
  final double offset;
  final double size;
  final Color color;
  final double sway;
  final double rotDir;
}
