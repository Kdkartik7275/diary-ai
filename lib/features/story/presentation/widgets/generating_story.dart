// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/core/containers/rounded_container.dart';
import 'package:lifeline/features/story/presentation/controller/generate_story_controller.dart';

class GeneratingStoryView extends StatefulWidget {
  const GeneratingStoryView({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.genre,
    required this.tone,
    required this.characterName,
  });

  final DateTime startDate;
  final DateTime endDate;
  final String genre;
  final String tone;
  final String characterName;

  @override
  State<GeneratingStoryView> createState() => _GeneratingStoryViewState();
}

class _GeneratingStoryViewState extends State<GeneratingStoryView>
    with TickerProviderStateMixin {
  late AnimationController _floatingController;
  late AnimationController _rotationController;
  late AnimationController _particleController;
  late AnimationController _pulseController;
  late AnimationController _textController;

  late Animation<double> _floatingAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  int _currentTextIndex = 0;
  final List<String> _loadingTexts = [
    'Analyzing your diary entries...',
    'Finding patterns in your journey...',
    'Weaving your memories together...',
    'Crafting your narrative...',
    'Adding the finishing touches...',
  ];

  final controller = Get.find<GenerateStoryController>();

  @override
  void initState() {
    super.initState();

    // Floating animation for the book icon
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _floatingAnimation = Tween<double>(begin: -15, end: 15).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
    _floatingController.repeat(reverse: true);

    // Rotation animation for particles
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_rotationController);
    _rotationController.repeat();

    // Particle scale animation
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _particleController.repeat(reverse: true);

    // Pulse animation for the container
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);

    // Text rotation controller
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _textController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _currentTextIndex = (_currentTextIndex + 1) % _loadingTexts.length;
        });
        _textController.reset();
        _textController.forward();
      }
    });
    _textController.forward();
    controller.generateStory(
      startDate: widget.startDate,
      endDate: widget.endDate,
      genre: widget.genre,
      tone: widget.tone,
      characterName: widget.characterName,
    );
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _rotationController.dispose();
    _particleController.dispose();
    _pulseController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
      body: SafeArea(
        child: Stack(
          children: [
            // Animated particles background
            AnimatedBuilder(
              animation: _rotationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ParticlePainter(
                    animation: _rotationAnimation.value,
                    particleAnimation: _particleController.value,
                  ),
                  size: size,
                );
              },
            ),

            // Main content
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated book icon container
                      AnimatedBuilder(
                        animation: Listenable.merge([
                          _floatingAnimation,
                          _pulseAnimation,
                        ]),
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _floatingAnimation.value),
                            child: Transform.scale(
                              scale: _pulseAnimation.value,
                              child: Container(
                                height: size.height * .18,
                                width: size.width * .32,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.primary.withValues(alpha: .8),
                                      AppColors.primary.withValues(alpha: .6),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(
                                        alpha: .3,
                                      ),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    // Shimmer effect
                                    Positioned.fill(
                                      child: AnimatedBuilder(
                                        animation: _rotationController,
                                        builder: (context, child) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Colors.white.withValues(
                                                    alpha: .0,
                                                  ),
                                                  Colors.white.withValues(
                                                    alpha: .1,
                                                  ),
                                                  Colors.white.withValues(
                                                    alpha: .0,
                                                  ),
                                                ],
                                                stops: [
                                                  (_rotationController.value -
                                                          0.3)
                                                      .clamp(0.0, 1.0),
                                                  _rotationController.value,
                                                  (_rotationController.value +
                                                          0.3)
                                                      .clamp(0.0, 1.0),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    // Book icon
                                    Center(
                                      child: Icon(
                                        CupertinoIcons.book_fill,
                                        color: AppColors.white,
                                        size: 52,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 40),

                      // Progress indicator
                      SizedBox(
                        width: size.width * 0.6,
                        child: Column(
                          children: [
                            // Animated dots
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(3, (index) {
                                return AnimatedBuilder(
                                  animation: _particleController,
                                  builder: (context, child) {
                                    final delay = index * 0.2;
                                    final value =
                                        (_particleController.value + delay) %
                                        1.0;
                                    final scale = math.sin(value * math.pi);

                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                      ),
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.primary.withValues(
                                          alpha: 0.3 + (scale * 0.7),
                                        ),
                                      ),
                                      transform: Matrix4.identity()
                                        ..scale(0.5 + (scale * 0.8)),
                                    );
                                  },
                                );
                              }),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Main title
                      Text(
                        'Your Story is Coming to Life...',
                        style: theme.titleMedium?.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 16),

                      // Animated status text
                      AnimatedBuilder(
                        animation: _textController,
                        builder: (context, child) {
                          return AnimatedOpacity(
                            opacity: _textController.value < 0.5
                                ? _textController.value * 2
                                : (1 - _textController.value) * 2,
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              _loadingTexts[_currentTextIndex],
                              textAlign: TextAlign.center,
                              style: theme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 12),

                      // Subtitle
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'This may take a few moments as our AI carefully crafts your personalized narrative',
                          textAlign: TextAlign.center,
                          style: theme.titleSmall?.copyWith(
                            color: AppColors.textLighter,
                            fontWeight: FontWeight.normal,
                            height: 1.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Fun fact or tip section
                      TRoundedContainer(
                        padding: const EdgeInsets.all(20),
                        backgroundColor: AppColors.primary.withValues(
                          alpha: .05,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.lightbulb,
                              color: AppColors.primary,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Did you know? Your story is being personalized based on your unique writing style and experiences.',
                                style: theme.titleSmall?.copyWith(
                                  color: AppColors.textLighter,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for animated particles
class ParticlePainter extends CustomPainter {
  final double animation;
  final double particleAnimation;

  ParticlePainter({required this.animation, required this.particleAnimation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Create floating particles
    final particles = [
      {'x': 0.2, 'y': 0.2, 'radius': 3.0, 'speed': 1.0},
      {'x': 0.8, 'y': 0.3, 'radius': 2.5, 'speed': 1.5},
      {'x': 0.3, 'y': 0.7, 'radius': 2.0, 'speed': 0.8},
      {'x': 0.7, 'y': 0.6, 'radius': 3.5, 'speed': 1.2},
      {'x': 0.5, 'y': 0.4, 'radius': 2.0, 'speed': 1.8},
      {'x': 0.15, 'y': 0.5, 'radius': 2.5, 'speed': 0.9},
      {'x': 0.85, 'y': 0.8, 'radius': 3.0, 'speed': 1.3},
    ];

    for (var particle in particles) {
      final x = particle['x'] as double;
      final y = particle['y'] as double;
      final radius = particle['radius'] as double;
      final speed = particle['speed'] as double;

      // Calculate animated position
      final animatedX = size.width * x + math.cos(animation * speed) * 20;
      final animatedY = size.height * y + math.sin(animation * speed) * 20;

      // Pulse effect
      final scale = 1 + math.sin(particleAnimation * math.pi * 2) * 0.3;

      paint.color = AppColors.primary.withValues(alpha: .1);
      canvas.drawCircle(Offset(animatedX, animatedY), radius * scale, paint);

      // Inner glow
      paint.color = AppColors.primary.withValues(alpha: .05);
      canvas.drawCircle(
        Offset(animatedX, animatedY),
        radius * scale * 2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}
