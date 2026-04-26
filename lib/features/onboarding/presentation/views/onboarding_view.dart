// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/config/theme/theme_controller.dart';
import 'package:mindloom/features/onboarding/presentation/controller/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  // Background gradient colors per page
  static const List<List<Color>> _pageGradients = [
    [Colors.white, Color(0xFFEEEDFE)],
    [Colors.white, Color(0xFFE1F5EE)],
    [Colors.white, Color(0xFFE6F1FB)],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: controller.currentPage.value.toDouble()),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          builder: (context, animatedPage, _) {
            // Interpolate gradient between pages
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

            return AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [startColor, endColor],
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 
                  Expanded(
                    child: PageView(
                      controller: controller.pageController,
                      onPageChanged: controller.setCurrentPage,
                      children: const [
                        OnboardingItem(
                          title: 'Welcome to Lifeline',
                          description:
                              'Your personal diary app to capture and cherish your daily moments.',
                          icon: CupertinoIcons.book,
                          pageIndex: 0,
                        ),
                        OnboardingItem(
                          title: 'AI Understands Your Journey',
                          description:
                              'Our AI analyzes your entries to understand the narrative of your life.',
                          icon: CupertinoIcons.wand_stars,
                          pageIndex: 1,
                        ),
                        OnboardingItem(
                          title: 'Transform Your Life Into a Story',
                          description:
                              'Watch your diary entries become beautiful stories with characters, plots, and adventures.',
                          icon: CupertinoIcons.book_fill,
                          pageIndex: 2,
                        ),
                      ],
                    ),
                  ),

                  // Animated dots
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          height: 8,
                          width:
                              controller.currentPage.value == index ? 30 : 10,
                          decoration: BoxDecoration(
                            color: controller.currentPage.value == index
                                ? AppColors.primary
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Animated button with cross-fading label
                  Obx(
                    () => _AnimatedButton(
                      isLastPage: controller.currentPage.value == 2,
                      onPressed: () {
                        controller
                            .setCurrentPage(controller.currentPage.value + 1);
                      },
                    ),
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─── Animated CTA Button ────────────────────────────────────────────────────

class _AnimatedButton extends StatefulWidget {
  const _AnimatedButton({
    required this.isLastPage,
    required this.onPressed,
  });

  final bool isLastPage;
  final VoidCallback onPressed;

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton> {
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
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: widget.onPressed,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: Text(
              widget.isLastPage ? 'Get Started' : 'Next',
              key: ValueKey(widget.isLastPage),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Onboarding Item ────────────────────────────────────────────────────────

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

    // Icon: scale bounce + subtle rotation
    _iconScale = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: 0.0, end: 1.15)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 60),
      TweenSequenceItem(
          tween: Tween(begin: 1.15, end: 0.95)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 20),
      TweenSequenceItem(
          tween: Tween(begin: 0.95, end: 1.0)
              .chain(CurveTween(curve: Curves.easeInOut)),
          weight: 20),
    ]).animate(_controller);

    _iconRotation = Tween<double>(begin: -0.08, end: 0.0)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    // Title: slide up + fade, starts after icon begins
    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
    ));

    // Description: slide up + fade, slightly after title
    _descOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );
    _descSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    ));

    // Auto-play on build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Called from parent via GlobalKey if you want to replay on page change.
  void replay() {
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Animated icon
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
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(widget.icon, size: 48, color: AppColors.primary),
          ),
        ),

        const SizedBox(height: 28),

        // Animated title
        SlideTransition(
          position: _titleSlide,
          child: FadeTransition(
            opacity: _titleOpacity,
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              style: theme.titleMedium!.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w600,
               color: AppColors.black
              ),
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Animated description
        SlideTransition(
          position: _descSlide,
          child: FadeTransition(
            opacity: _descOpacity,
            child: Text(
              widget.description,
              textAlign: TextAlign.center,
              style: theme.titleSmall!.copyWith(
                fontWeight: FontWeight.normal,
                color: AppColors.textLighter,
              ),
            ),
          ),
        ),
      ],
    );
  }
}