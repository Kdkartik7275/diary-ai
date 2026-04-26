import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/config/routes/app_routes.dart';
import 'package:mindloom/core/utils/validators/vallidators.dart';
import 'package:mindloom/features/authentication/presentation/controller/login_controller.dart';
import 'package:mindloom/features/authentication/presentation/widgets/auth_button.dart';
import 'package:mindloom/features/authentication/presentation/widgets/auth_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  late LoginController controller;
  late AnimationController animationController;
  late Animation<Offset> welcomeSlideAnimation;
  late Animation<Offset> emailFieldSlideAnimation;
  late Animation<Offset> passwordFieldSlideAnimation;
  late Animation<Offset> buttonSlideAnimation;
    late Tween opacity;


  @override
  void initState() {
    super.initState();
    controller = Get.find<LoginController>();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
      
    welcomeSlideAnimation =
        Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero).animate(
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        );
    emailFieldSlideAnimation =
        Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero).animate(
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        );
    passwordFieldSlideAnimation =
        Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        );
    buttonSlideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero).animate(
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        );
    animationController.forward();

        opacity = Tween(begin: 0.0, end: 1.0);
    opacity.animate(animationController);
  }
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    final horizontalPadding = width * 0.06;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth > 600;

          return Container(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  AppColors.primary.withValues(alpha: .05),
                ],
              ),
            ),
            child: Center(
              child: SizedBox(
                width: isTablet ? width * 0.55 : width,
                child: ListView(
                  children: [
                    SizedBox(height: height * 0.15),

                    SlideTransition(
                      position: welcomeSlideAnimation,
                      child: Text(
                        'Welcome Back',
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: isTablet ? 28 : 22,
                            ),
                      ),
                    ),
                    const SizedBox(height: 6),

                    SlideTransition(
                      position: welcomeSlideAnimation,
                      child: Text(
                        'Continue your storytelling journey',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: isTablet ? 18 : 15,
                          color: Colors.black54,
                        ),
                      ),
                    ),

                    SizedBox(height: isTablet ? 40 : 28),

                    Form(
                      key: controller.loginFormKey.value, // FIXED
                      autovalidateMode: AutovalidateMode.onUnfocus,
                      child: Column(
                        children: [
                          SlideTransition(
                            position: emailFieldSlideAnimation,
                            child: AuthField(
                              prefixIcon: Icon(CupertinoIcons.mail),
                              validator: (value) =>
                                  TValidator.validateEmail(value),
                              controller: controller.email.value,
                              hintText: 'Enter your email',
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'\s')),
                              ],
                            ),
                          ),
                          SizedBox(height: isTablet ? 18 : 12),

                          /// ONLY obscure + suffixIcon needs reactive updates
                          Obx(
                            () => SlideTransition(
                              position: passwordFieldSlideAnimation,
                              child: AuthField(
                                prefixIcon: const Icon(CupertinoIcons.lock),
                                validator: (value) =>
                                    TValidator.validateEmptyText(
                                      'Password',
                                      value,
                                    ),
                                controller: controller.password.value,
                                hintText: 'Enter your Password',
                                obsecure: controller.obsecure.value,
                                suffixIcon: GestureDetector(
                                  onTap: () => controller.obsecure.value =
                                      !controller.obsecure.value,
                                  child: Icon(
                                    controller.obsecure.value
                                        ? CupertinoIcons.eye
                                        : CupertinoIcons.eye_slash,
                                  ),
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    FadeTransition(
                      opacity: animationController,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            _showForgotPasswordModal(context, controller);
                          },
                          child: Text(
                            'Forgot Password?',
                            style: Theme.of(context).textTheme.titleSmall!
                                .copyWith(color: AppColors.primary),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: isTablet ? 55 : 45),

                    Obx(
                      () => controller.isLoading.value
                          ? const Center(
                              child: SizedBox(
                                width: 26,
                                height: 26,
                                child: CircularProgressIndicator(
                                  color: AppColors.white,
                                  strokeWidth: 2.5,
                                ),
                              ),
                            )
                          : FadeTransition(
                            opacity: animationController,
                            child: SlideTransition(
                              position: buttonSlideAnimation,
                              child: AuthButton(
                                  label: 'Continue',
                                  size: Size(width * 0.6, 50),
                                  onPressed: () => controller.loginUser(),
                                ),
                            ),
                          ),
                    ),

                    SizedBox(height: isTablet ? 35 : 25),

                    FadeTransition(
                      opacity: animationController,
                      child: Align(
                        alignment: Alignment.center,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Don’t have an account? ',
                                style: Theme.of(context).textTheme.titleLarge!
                                    .copyWith(
                                      color: Colors.black,
                                      fontSize: isTablet ? 16 : 14,
                                    ),
                              ),
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Get.toNamed(Routes.signup),
                                text: 'Sign up',
                                style: Theme.of(context).textTheme.titleLarge!
                                    .copyWith(
                                      color: AppColors.primary,
                                      fontSize: isTablet ? 18 : 16,
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
            ),
          );
        },
      ),
    );
  }
}

void _showForgotPasswordModal(
  BuildContext context,
  LoginController controller,
) {
  final emailController = TextEditingController(
    text: controller.email.value.text, // pre-fill if available
  );

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          Text(
            'Reset Password',
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),

          Text(
            'Enter your email to receive a reset link',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: AppColors.textLighter,
              fontWeight: FontWeight.normal,
            ),
          ),

          const SizedBox(height: 20),

          /// EMAIL FIELD
          AuthField(
            prefixIcon: const Icon(CupertinoIcons.mail),
            controller: emailController,
            hintText: 'Enter your email',
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!GetUtils.isEmail(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          /// BUTTON
          Obx(
            () => controller.isResetLoading.value
                ? Align(
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 1,
                    ),
                  )
                : SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.isResetLoading.value
                          ? null
                          : () {
                              final email = emailController.text.trim();

                              if (!GetUtils.isEmail(email)) {
                                Get.snackbar('Error', 'Enter a valid email');
                                return;
                              }

                              controller.forgotPassword(email);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Send Reset Link'),
                    ),
                  ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}
