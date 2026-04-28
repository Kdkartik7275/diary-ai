import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/config/routes/app_routes.dart';
import 'package:mindloom/core/utils/validators/vallidators.dart';
import 'package:mindloom/features/authentication/presentation/controller/login_controller.dart';
import 'package:mindloom/features/authentication/presentation/widgets/auth_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with TickerProviderStateMixin {
  late LoginController controller;

  // Master stagger controller
  late AnimationController _staggerController;

  // Individual element animations
  late Animation<double> _logoFade;
  late Animation<Offset> _logoSlide;
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _subtitleFade;
  late Animation<double> _fieldsFade;
  late Animation<Offset> _fieldsSlide;
  late Animation<double> _buttonFade;
  late Animation<Offset> _buttonSlide;
  late Animation<double> _footerFade;

  // Floating orb animation
  late AnimationController _orbController;
  late Animation<double> _orbAnimation;

  // Focus tracking for field highlight
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  bool _emailFocused = false;
  bool _passwordFocused = false;

  @override
  void initState() {
    super.initState();
    controller = Get.find<LoginController>();

    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeOut),
      ),
    );
    _logoSlide = Tween<Offset>(begin: const Offset(0, -0.4), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _staggerController,
            curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
          ),
        );

    _titleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
      ),
    );
    _titleSlide = Tween<Offset>(begin: const Offset(-0.3, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _staggerController,
            curve: const Interval(0.2, 0.5, curve: Curves.easeOut),
          ),
        );

    _subtitleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.3, 0.55, curve: Curves.easeOut),
      ),
    );

    _fieldsFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.45, 0.7, curve: Curves.easeOut),
      ),
    );
    _fieldsSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _staggerController,
            curve: const Interval(0.45, 0.75, curve: Curves.easeOut),
          ),
        );

    _buttonFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.65, 0.85, curve: Curves.easeOut),
      ),
    );
    _buttonSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _staggerController,
            curve: const Interval(0.65, 0.9, curve: Curves.easeOut),
          ),
        );

    _footerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.8, 1.0, curve: Curves.easeOut),
      ),
    );

    // ── Floating orb (slow breathe) ───────────────────────────────────────
    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _orbAnimation = CurvedAnimation(
      parent: _orbController,
      curve: Curves.easeInOut,
    );

    // Focus listeners
    _emailFocus.addListener(() {
      setState(() => _emailFocused = _emailFocus.hasFocus);
    });
    _passwordFocus.addListener(() {
      setState(() => _passwordFocused = _passwordFocus.hasFocus);
    });

    _staggerController.forward();
  }

  @override
  void dispose() {
    _staggerController.dispose();
    _orbController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    final isTablet = width > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ── Animated background orbs ────────────────────────────────────
          AnimatedBuilder(
            animation: _orbAnimation,
            builder: (context, _) {
              final t = _orbAnimation.value;
              return Stack(
                children: [
                  // Top-right orb
                  Positioned(
                    top: -60 + (t * 20),
                    right: -80 + (t * 10),
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.18),
                            AppColors.primary.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Bottom-left orb
                  Positioned(
                    bottom: -40 + (t * -15),
                    left: -60 + (t * 10),
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.1),
                            AppColors.primary.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Mid accent
                  Positioned(
                    top: height * 0.38 + (t * 12),
                    right: -30,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.08),
                            AppColors.primary.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // ── Main content ─────────────────────────────────────────────────
          Center(
            child: SizedBox(
              width: isTablet ? width * 0.55 : width,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                children: [
                  SizedBox(height: height * 0.12),

                  // ── Logo / Brand mark ─────────────────────────────────
                  FadeTransition(
                    opacity: _logoFade,
                    child: SlideTransition(
                      position: _logoSlide,
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Image.asset(
                              'assets/icons/logo.png',
                              width: 24,
                              height: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'MindLoom',
                            style: Theme.of(context).textTheme.titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: AppColors.primary,
                                  letterSpacing: 0.3,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.06),

                  // ── Title ─────────────────────────────────────────────
                  FadeTransition(
                    opacity: _titleFade,
                    child: SlideTransition(
                      position: _titleSlide,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back,',
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: isTablet ? 30 : 26,
                                  color: Colors.black87,
                                  height: 1.1,
                                ),
                          ),
                          Text(
                            'storyteller.',
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: isTablet ? 30 : 26,
                                  color: AppColors.primary,
                                  height: 1.2,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ── Subtitle ──────────────────────────────────────────
                  FadeTransition(
                    opacity: _subtitleFade,
                    child: Text(
                      'Continue your journey where you left off',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: isTablet ? 16 : 14,
                        color: Colors.black45,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),

                  SizedBox(height: isTablet ? 44 : 36),

                  // ── Fields ────────────────────────────────────────────
                  FadeTransition(
                    opacity: _fieldsFade,
                    child: SlideTransition(
                      position: _fieldsSlide,
                      child: Form(
                        key: controller.loginFormKey.value,
                        autovalidateMode: AutovalidateMode.onUnfocus,
                        child: Column(
                          children: [
                            // Email field with focus glow
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: _emailFocused
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.18,
                                          ),
                                          blurRadius: 16,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.05,
                                          ),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                              ),
                              child: AuthField(
                                prefixIcon: Icon(
                                  CupertinoIcons.mail,
                                  color: _emailFocused
                                      ? AppColors.primary
                                      : Colors.grey,
                                  size: 20,
                                ),
                                validator: (value) =>
                                    TValidator.validateEmail(value),
                                controller: controller.email.value,
                                hintText: 'Email address',
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(
                                    RegExp(r'\s'),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: isTablet ? 16 : 12),

                            // Password field with focus glow
                            Obx(
                              () => AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: _passwordFocused
                                      ? [
                                          BoxShadow(
                                            color: AppColors.primary.withValues(
                                              alpha: 0.18,
                                            ),
                                            blurRadius: 16,
                                            offset: const Offset(0, 4),
                                          ),
                                        ]
                                      : [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.05,
                                            ),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                ),
                                child: AuthField(
                                  prefixIcon: Icon(
                                    CupertinoIcons.lock,
                                    color: _passwordFocused
                                        ? AppColors.primary
                                        : Colors.grey,
                                    size: 20,
                                  ),
                                  validator: (value) =>
                                      TValidator.validateEmptyText(
                                        'Password',
                                        value,
                                      ),
                                  controller: controller.password.value,
                                  hintText: 'Password',
                                  obsecure: controller.obsecure.value,
                                  suffixIcon: GestureDetector(
                                    onTap: () => controller.obsecure.value =
                                        !controller.obsecure.value,
                                    child: Icon(
                                      controller.obsecure.value
                                          ? CupertinoIcons.eye
                                          : CupertinoIcons.eye_slash,
                                      color: _passwordFocused
                                          ? AppColors.primary
                                          : Colors.grey,
                                      size: 20,
                                    ),
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                      RegExp(r'\s'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ── Forgot password ───────────────────────────────────
                  FadeTransition(
                    opacity: _fieldsFade,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () =>
                            _showForgotPasswordModal(context, controller),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 8,
                          ),
                        ),
                        child: Text(
                          'Forgot password?',
                          style: Theme.of(context).textTheme.titleSmall!
                              .copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: isTablet ? 32 : 24),

                  // ── Login button ──────────────────────────────────────
                  FadeTransition(
                    opacity: _buttonFade,
                    child: SlideTransition(
                      position: _buttonSlide,
                      child: Obx(
                        () => _LoginButton(
                          isLoading: controller.isLoading.value,
                          onPressed: () => controller.loginUser(),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: isTablet ? 28 : 20),

                  // ── Divider ───────────────────────────────────────────
                  FadeTransition(
                    opacity: _footerFade,
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.black.withValues(alpha: 0.08),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'or',
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.black.withValues(alpha: 0.08),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isTablet ? 20 : 16),

                  // ── Sign up link ──────────────────────────────────────
                  FadeTransition(
                    opacity: _footerFade,
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'New to Lifeline? ',
                              style: Theme.of(context).textTheme.titleSmall!
                                  .copyWith(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.normal,
                                    fontSize: isTablet ? 15 : 14,
                                  ),
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Get.toNamed(Routes.signup),
                              text: 'Create account',
                              style: Theme.of(context).textTheme.titleSmall!
                                  .copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: isTablet ? 15 : 14,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.06),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Animated Login Button ────────────────────────────────────────────────────

class _LoginButton extends StatefulWidget {
  const _LoginButton({required this.isLoading, required this.onPressed});

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  State<_LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<_LoginButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.97),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        if (!widget.isLoading) widget.onPressed();
      },
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
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
              duration: const Duration(milliseconds: 200),
              child: widget.isLoading
                  ? const SizedBox(
                      key: ValueKey('loading'),
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Row(
                      key: ValueKey('label'),
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Continue',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          CupertinoIcons.arrow_right,
                          color: Colors.white,
                          size: 16,
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Forgot password modal ────────────────────────────────────────────────────

void _showForgotPasswordModal(
  BuildContext context,
  LoginController controller,
) {
  final emailController = TextEditingController(
    text: controller.email.value.text,
  );

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 32,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              CupertinoIcons.lock_rotation,
              color: AppColors.primary,
              size: 24,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'Reset password',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Enter your email and we\'ll send you a reset link.',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: Colors.black45,
              fontWeight: FontWeight.normal,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 24),

          AuthField(
            prefixIcon: const Icon(CupertinoIcons.mail),
            controller: emailController,
            hintText: 'Your email address',
            validator: (value) {
              if (value == null || value.isEmpty) return 'Email is required';
              if (!GetUtils.isEmail(value)) return 'Enter a valid email';
              return null;
            },
          ),

          const SizedBox(height: 20),

          Obx(
            () => GestureDetector(
              onTap: controller.isResetLoading.value
                  ? null
                  : () {
                      final email = emailController.text.trim();
                      if (!GetUtils.isEmail(email)) {
                        Get.snackbar('Error', 'Enter a valid email');
                        return;
                      }
                      controller.forgotPassword(email);
                    },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.85),
                      AppColors.primary,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: controller.isResetLoading.value
                        ? const SizedBox(
                            key: ValueKey('loading'),
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            key: ValueKey('send'),
                            'Send reset link',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}
