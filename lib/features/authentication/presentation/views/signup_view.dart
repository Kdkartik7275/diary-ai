import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/core/utils/validators/vallidators.dart';
import 'package:mindloom/features/authentication/presentation/controller/signup_controller.dart';
import 'package:mindloom/features/authentication/presentation/widgets/auth_field.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> with TickerProviderStateMixin {
  late SignUpController controller;

  // ── Stagger controller (1000ms) ───────────────────────────────────────────
  late AnimationController _staggerController;
  late Animation<double> _logoFade;
  late Animation<Offset> _logoSlide;
  late Animation<double> _titleFade;
  late Animation<Offset> _titleSlide;
  late Animation<double> _subtitleFade;
  late Animation<double> _field1Fade;
  late Animation<Offset> _field1Slide;
  late Animation<double> _field2Fade;
  late Animation<Offset> _field2Slide;
  late Animation<double> _field3Fade;
  late Animation<Offset> _field3Slide;
  late Animation<double> _field4Fade;
  late Animation<Offset> _field4Slide;
  late Animation<double> _buttonFade;
  late Animation<Offset> _buttonSlide;
  late Animation<double> _footerFade;

  // ── Floating orb (breathe) ────────────────────────────────────────────────
  late AnimationController _orbController;
  late Animation<double> _orbAnimation;

  // ── Focus nodes ───────────────────────────────────────────────────────────
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmFocus = FocusNode();

  bool _nameFocused = false;
  bool _emailFocused = false;
  bool _passwordFocused = false;
  bool _confirmFocused = false;

  // ── Password strength ─────────────────────────────────────────────────────
  double _passwordStrength = 0;
  Color _strengthColor = Colors.transparent;
  String _strengthLabel = '';

  @override
  void initState() {
    super.initState();
    controller = Get.find<SignUpController>();

    // Stagger
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    Animation<double> _fade(double s, double e) =>
        Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _staggerController,
            curve: Interval(s, e, curve: Curves.easeOut),
          ),
        );

    Animation<Offset> _slide(
      double s,
      double e, {
      Offset begin = const Offset(0, 0.35),
    }) => Tween<Offset>(begin: begin, end: Offset.zero).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: Interval(s, e, curve: Curves.easeOut),
      ),
    );

    _logoFade = _fade(0.0, 0.25);
    _logoSlide = _slide(0.0, 0.3, begin: const Offset(0, -0.4));
    _titleFade = _fade(0.15, 0.4);
    _titleSlide = _slide(0.15, 0.4, begin: const Offset(-0.25, 0));
    _subtitleFade = _fade(0.25, 0.45);
    _field1Fade = _fade(0.35, 0.55);
    _field1Slide = _slide(0.35, 0.55);
    _field2Fade = _fade(0.45, 0.63);
    _field2Slide = _slide(0.45, 0.63);
    _field3Fade = _fade(0.54, 0.72);
    _field3Slide = _slide(0.54, 0.72);
    _field4Fade = _fade(0.62, 0.80);
    _field4Slide = _slide(0.62, 0.80);
    _buttonFade = _fade(0.73, 0.90);
    _buttonSlide = _slide(0.73, 0.92, begin: const Offset(0, 0.5));
    _footerFade = _fade(0.86, 1.0);

    // Orb
    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _orbAnimation = CurvedAnimation(
      parent: _orbController,
      curve: Curves.easeInOut,
    );

    // Focus listeners
    for (final pair in [
      (_nameFocus, () => setState(() => _nameFocused = _nameFocus.hasFocus)),
      (_emailFocus, () => setState(() => _emailFocused = _emailFocus.hasFocus)),
      (
        _passwordFocus,
        () => setState(() => _passwordFocused = _passwordFocus.hasFocus),
      ),
      (
        _confirmFocus,
        () => setState(() => _confirmFocused = _confirmFocus.hasFocus),
      ),
    ]) {
      pair.$1.addListener(pair.$2);
    }

    // Password strength listener
    controller.password.value.addListener(_updateStrength);

    _staggerController.forward();
  }

  void _updateStrength() {
    final p = controller.password.value.text;
    double strength = 0;
    if (p.length >= 8) strength += 0.25;
    if (p.contains(RegExp(r'[A-Z]'))) strength += 0.25;
    if (p.contains(RegExp(r'[0-9]'))) strength += 0.25;
    if (p.contains(RegExp(r'[!@#\$%^&*]'))) strength += 0.25;

    Color color;
    String label;
    if (strength <= 0.25) {
      color = Colors.red;
      label = 'Weak';
    } else if (strength <= 0.5) {
      color = Colors.orange;
      label = 'Fair';
    } else if (strength <= 0.75) {
      color = Colors.amber;
      label = 'Good';
    } else {
      color = Colors.green;
      label = 'Strong';
    }

    setState(() {
      _passwordStrength = strength;
      _strengthColor = color;
      _strengthLabel = p.isEmpty ? '' : label;
    });
  }

  @override
  void dispose() {
    _staggerController.dispose();
    _orbController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    controller.password.value.removeListener(_updateStrength);
    super.dispose();
  }

  Widget _focusGlow({required bool focused, required Widget child}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: focused
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.18),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;
    final isTablet = width > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Stack(
        children: [
          // ── Animated background orbs ──────────────────────────────────────
          AnimatedBuilder(
            animation: _orbAnimation,
            builder: (context, _) {
              final t = _orbAnimation.value;
              return Stack(
                children: [
                  Positioned(
                    top: -50 + (t * 18),
                    left: -70 + (t * 12),
                    child: Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.14),
                            AppColors.primary.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -30 + (t * -12),
                    right: -60 + (t * 8),
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.10),
                            AppColors.primary.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: height * 0.45 + (t * 10),
                    left: -20,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.07),
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

          // ── Main content ──────────────────────────────────────────────────
          Center(
            child: SizedBox(
              width: isTablet ? width * 0.55 : width,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: width * 0.06),
                children: [
                  SizedBox(height: height * 0.16),

                  // ── Title ─────────────────────────────────────────────────
                  FadeTransition(
                    opacity: _titleFade,
                    child: SlideTransition(
                      position: _titleSlide,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Begin your',
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: isTablet ? 30 : 26,
                                  color: Colors.black87,
                                  height: 1.1,
                                ),
                          ),
                          Text(
                            'story.',
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

                  // ── Subtitle ──────────────────────────────────────────────
                  FadeTransition(
                    opacity: _subtitleFade,
                    child: Text(
                      'Create your account and start writing today',
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: isTablet ? 16 : 14,
                        color: Colors.black45,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),

                  SizedBox(height: isTablet ? 36 : 28),

                  // ── Form ──────────────────────────────────────────────────
                  Form(
                    key: controller.signupFormKey.value,
                    autovalidateMode: AutovalidateMode.onUnfocus,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Full name
                        FadeTransition(
                          opacity: _field1Fade,
                          child: SlideTransition(
                            position: _field1Slide,
                            child: _focusGlow(
                              focused: _nameFocused,
                              child: AuthField(
                                prefixIcon: Icon(
                                  CupertinoIcons.person,
                                  color: _nameFocused
                                      ? AppColors.primary
                                      : Colors.grey,
                                  size: 20,
                                ),
                                validator: (value) =>
                                    TValidator.validateEmptyText(
                                      'Full Name',
                                      value,
                                    ),
                                controller: controller.fullName.value,
                                hintText: 'Full name',
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z\s]'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: isTablet ? 16 : 12),

                        // Email
                        FadeTransition(
                          opacity: _field2Fade,
                          child: SlideTransition(
                            position: _field2Slide,
                            child: _focusGlow(
                              focused: _emailFocused,
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
                          ),
                        ),

                        SizedBox(height: isTablet ? 16 : 12),

                        // Password
                        Obx(
                          () => FadeTransition(
                            opacity: _field3Fade,
                            child: SlideTransition(
                              position: _field3Slide,
                              child: _focusGlow(
                                focused: _passwordFocused,
                                child: AuthField(
                                  prefixIcon: Icon(
                                    CupertinoIcons.lock,
                                    color: _passwordFocused
                                        ? AppColors.primary
                                        : Colors.grey,
                                    size: 20,
                                  ),
                                  validator: (value) =>
                                      TValidator.validatePassword(value),
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
                          ),
                        ),

                        // Password strength bar
                        AnimatedSize(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOut,
                          child: _passwordStrength > 0
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                    top: 8,
                                    left: 4,
                                    right: 4,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: _passwordStrength,
                                          minHeight: 4,
                                          backgroundColor: Colors.grey.shade200,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                _strengthColor,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _strengthLabel,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: _strengthColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),

                        SizedBox(height: isTablet ? 16 : 12),

                        // Confirm password
                        Obx(
                          () => FadeTransition(
                            opacity: _field4Fade,
                            child: SlideTransition(
                              position: _field4Slide,
                              child: _focusGlow(
                                focused: _confirmFocused,
                                child: AuthField(
                                  prefixIcon: Icon(
                                    CupertinoIcons.lock_rotation,
                                    color: _confirmFocused
                                        ? AppColors.primary
                                        : Colors.grey,
                                    size: 20,
                                  ),
                                  validator: (value) =>
                                      TValidator.validateConfirmPassword(
                                        controller.password.value.text,
                                        value,
                                      ),
                                  controller: controller.confirmPassword.value,
                                  hintText: 'Confirm password',
                                  obsecure: controller.obsecureConfirm.value,
                                  suffixIcon: GestureDetector(
                                    onTap: () =>
                                        controller.obsecureConfirm.value =
                                            !controller.obsecureConfirm.value,
                                    child: Icon(
                                      controller.obsecureConfirm.value
                                          ? CupertinoIcons.eye
                                          : CupertinoIcons.eye_slash,
                                      color: _confirmFocused
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
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isTablet ? 40 : 32),

                  // ── Signup button ─────────────────────────────────────────
                  FadeTransition(
                    opacity: _buttonFade,
                    child: SlideTransition(
                      position: _buttonSlide,
                      child: Obx(
                        () => _SignUpButton(
                          isLoading: controller.isLoading.value,
                          onPressed: () => controller.registerUser(),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: isTablet ? 24 : 18),

                  // ── Divider ───────────────────────────────────────────────
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

                  SizedBox(height: isTablet ? 16 : 12),

                  // ── Footer ────────────────────────────────────────────────
                  FadeTransition(
                    opacity: _footerFade,
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Already have an account? ',
                              style: Theme.of(context).textTheme.titleSmall!
                                  .copyWith(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.normal,
                                    fontSize: isTablet ? 15 : 14,
                                  ),
                            ),
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Get.back(),
                              text: 'Log in',
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

// ─── Animated Sign Up Button ──────────────────────────────────────────────────

class _SignUpButton extends StatefulWidget {
  const _SignUpButton({required this.isLoading, required this.onPressed});

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  State<_SignUpButton> createState() => _SignUpButtonState();
}

class _SignUpButtonState extends State<_SignUpButton> {
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
                          'Create Account',
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
