// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/features/onboarding/presentation/controller/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  static const List<List<Color>> _pageGradients = [
    [Colors.white, Color(0xFFEEEDFE)],
    [Colors.white, Color(0xFFE1F5EE)],
    [Colors.white, Color(0xFFE6F1FB)],
  ];

  static const List<List<Color>> _orbColors = [
    [Color(0xFFEEEDFE), Color(0xFFE0DFFE)],
    [Color(0xFFD6F5EE), Color(0xFFB8EFE0)],
    [Color(0xFFD6E8FB), Color(0xFFBDD6F5)],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => TweenAnimationBuilder<double>(
          tween: Tween(
            begin: 0,
            end: controller.currentPage.value.toDouble(),
          ),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          builder: (context, animatedPage, _) {
            final int fromPage = animatedPage.floor().clamp(0, 2);
            final int toPage = (fromPage + 1).clamp(0, 2);
            final double t = animatedPage - fromPage;

            final Color startColor = Color.lerp(
              _pageGradients[fromPage][0],
              _pageGradients[toPage][0],
              t,
            )!;
            final Color endColor = Color.lerp(
              _pageGradients[fromPage][1],
              _pageGradients[toPage][1],
              t,
            )!;
            final Color orb1 = Color.lerp(
                _orbColors[fromPage][0], _orbColors[toPage][0], t)!;
            final Color orb2 = Color.lerp(
                _orbColors[fromPage][1], _orbColors[toPage][1], t)!;

            return Stack(
              children: [
                // ── Background gradient ───────────────────────────────
                Positioned.fill(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [startColor, endColor],
                      ),
                    ),
                  ),
                ),

                // ── Orbs ─────────────────────────────────────────────
                Positioned(
                  top: -60,
                  right: -80,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          orb1.withValues(alpha: 0.7),
                          orb1.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -40,
                  left: -60,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          orb2.withValues(alpha: 0.6),
                          orb2.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Content ───────────────────────────────────────────
                SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),

                        // Logo mark — identical to login/signup
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(12),
                              
                              ),
                              child: Image.asset('assets/icons/logo.png', width: 20, height: 20),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'MindLoom',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: AppColors.primary,
                                    letterSpacing: 0.3,
                                  ),
                            ),
                          ],
                        ),

                        // Page content
                        Expanded(
                          child: PageView(
                            controller: controller.pageController,
                            onPageChanged: controller.setCurrentPage,
                            children: const [
                              OnboardingItem(
                                title: 'Capture your\nmoments.',
                                description:
                                    'Your personal diary app to capture and cherish your daily moments.',
                                icon: CupertinoIcons.book,
                                pageIndex: 0,
                              ),
                              OnboardingItem(
                                title: 'AI understands\nyour journey.',
                                description:
                                    'Our AI analyzes your entries to understand the narrative of your life.',
                                icon: CupertinoIcons.wand_stars,
                                pageIndex: 1,
                              ),
                              OnboardingItem(
                                title: 'Transform life\ninto a story.',
                                description:
                                    'Watch your diary entries become beautiful stories with characters, plots, and adventures.',
                                icon: CupertinoIcons.book_fill,
                                pageIndex: 2,
                              ),
                            ],
                          ),
                        ),

                        // Dots
                        Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              3,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 4),
                                height: 8,
                                width:
                                    controller.currentPage.value == index
                                        ? 28
                                        : 8,
                                decoration: BoxDecoration(
                                  color:
                                      controller.currentPage.value == index
                                          ? AppColors.primary
                                          : AppColors.primary
                                              .withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // CTA button
                        Obx(
                          () => _OnboardingButton(
                            isLastPage:
                                controller.currentPage.value == 2,
                            onPressed: () => controller.setCurrentPage(
                              controller.currentPage.value + 1,
                            ),
                          ),
                        ),

                        // Skip
                        Obx(
                          () => AnimatedOpacity(
                            opacity:
                                controller.currentPage.value == 2 ? 0 : 1,
                            duration: const Duration(milliseconds: 200),
                            child: Center(
                              child: TextButton(
                                onPressed: () =>
                                    controller.setCurrentPage(2),
                                child: Text(
                                  'Skip',
                                  style: TextStyle(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.6),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ─── CTA Button — same gradient + shadow + press scale as login ───────────────

class _OnboardingButton extends StatefulWidget {
  const _OnboardingButton({
    required this.isLastPage,
    required this.onPressed,
  });

  final bool isLastPage;
  final VoidCallback onPressed;

  @override
  State<_OnboardingButton> createState() => _OnboardingButtonState();
}

class _OnboardingButtonState extends State<_OnboardingButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.97),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.85),
                AppColors.primary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(anim),
                  child: child,
                ),
              ),
              child: widget.isLastPage
                  ? const Row(
                      key: ValueKey('start'),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Get Started',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(CupertinoIcons.arrow_right,
                            color: Colors.white, size: 16),
                      ],
                    )
                  : const Row(
                      key: ValueKey('next'),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Next',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(CupertinoIcons.chevron_right,
                            color: Colors.white, size: 14),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Onboarding Item ─────────────────────────────────────────────────────────

class OnboardingItem extends StatefulWidget {
  const OnboardingItem({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.pageIndex,
  });

  final String title;
  final String description;
  final IconData icon;
  final int pageIndex;

  @override
  State<OnboardingItem> createState() => _OnboardingItemState();
}

class _OnboardingItemState extends State<OnboardingItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _iconScale;
  late final Animation<double> _iconRotation;
  late final Animation<double> _titleOpacity;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _descOpacity;
  late final Animation<Offset> _descSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _iconScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.15)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.15, end: 0.95)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.95, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
    ]).animate(_controller);

    _iconRotation = Tween<double>(begin: -0.08, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
      ),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
    ));

    _descOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );
    _descSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void replay() {
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon — solid primary with shadow (matches login logo mark)
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) => Transform.rotate(
            angle: _iconRotation.value,
            child: Transform.scale(
              scale: _iconScale.value,
              child: child,
            ),
          ),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(22),
            
            ),
            child: Icon(widget.icon, size: 40, color: Colors.white),
          ),
        ),

        const SizedBox(height: 36),

        // Title — left-aligned, multi-line like "Begin your / story."
        SlideTransition(
          position: _titleSlide,
          child: FadeTransition(
            opacity: _titleOpacity,
            child: Text(
              widget.title,
              style: theme.titleMedium!.copyWith(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                height: 1.2,
              ),
            ),
          ),
        ),

        const SizedBox(height: 14),

        // Description
        SlideTransition(
          position: _descSlide,
          child: FadeTransition(
            opacity: _descOpacity,
            child: Text(
              widget.description,
              style: theme.titleSmall!.copyWith(
                fontWeight: FontWeight.normal,
                fontSize: 15,
                color: Colors.black45,
                height: 1.6,
              ),
            ),
          ),
        ),
      ],
    );
  }
}