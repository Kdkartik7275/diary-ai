import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/config/routes/app_routes.dart';
import 'package:lifeline/core/utils/validators/vallidators.dart';
import 'package:lifeline/features/authentication/presentation/controller/login_controller.dart';
import 'package:lifeline/features/authentication/presentation/widgets/auth_button.dart';
import 'package:lifeline/features/authentication/presentation/widgets/auth_field.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

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

                    Text(
                      'Welcome Back',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: isTablet ? 28 : 22,
                      ),
                    ),
                    const SizedBox(height: 6),

                    Text(
                      'Continue your storytelling journey',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: isTablet ? 18 : 15,
                        color: Colors.black54,
                      ),
                    ),

                    SizedBox(height: isTablet ? 40 : 28),

                    Form(
                      key: controller.loginFormKey.value, // FIXED
                      autovalidateMode: AutovalidateMode.onUnfocus,
                      child: Column(
                        children: [
                          AuthField(
                            prefixIcon: Icon(CupertinoIcons.mail),
                            validator: (value) =>
                                TValidator.validateEmail(value),
                            controller: controller.email.value,
                            hintText: 'Enter your email',
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(
                                RegExp(r"\s"),
                              ),
                            ],
                          ),
                          SizedBox(height: isTablet ? 18 : 12),

                          /// ONLY obscure + suffixIcon needs reactive updates
                          Obx(
                            () => AuthField(
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
                                FilteringTextInputFormatter.deny(
                                  RegExp(r"\s"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: isTablet ? 55 : 45),

                    /// LOADER / BUTTON - reactive
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
                          : AuthButton(
                              label: 'Continue',
                              size: Size(width * 0.6, 50),
                              onPressed: () => controller.loginUser(),
                            ),
                    ),

                    SizedBox(height: isTablet ? 35 : 25),

                    Align(
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Don’t have an account? ',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color: Colors.black,
                                    fontSize: isTablet ? 16 : 14,
                                  ),
                            ),
                            TextSpan(
                                 recognizer: TapGestureRecognizer()
                              ..onTap = () => Get.toNamed(
                               Routes.signup
                              ),
                              text: 'Sign up',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    color: AppColors.primary,
                                    fontSize: isTablet ? 18 : 16,
                                  ),
                            ),
                          ],
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
