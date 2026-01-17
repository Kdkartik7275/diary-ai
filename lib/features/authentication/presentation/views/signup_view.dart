import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/core/utils/validators/vallidators.dart';
import 'package:lifeline/features/authentication/presentation/controller/signup_controller.dart';
import 'package:lifeline/features/authentication/presentation/widgets/auth_button.dart';
import 'package:lifeline/features/authentication/presentation/widgets/auth_field.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

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

                    /// TITLE
                    Text(
                      "Create Account",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: isTablet ? 28 : 22,
                      ),
                    ),
                    const SizedBox(height: 6),

                    Text(
                      "Start your storytelling journey today",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: isTablet ? 18 : 15,
                        color: Colors.black54,
                      ),
                    ),

                    SizedBox(height: isTablet ? 40 : 28),

                    /// FORM
                    Form(
                      key: controller.signupFormKey.value,
                      autovalidateMode: AutovalidateMode.onUnfocus,
                      child: Column(
                        children: [
                          /// FULL NAME
                          AuthField(
                            prefixIcon: const Icon(CupertinoIcons.person),
                            validator: (value) => TValidator.validateEmptyText(
                              'Full Name',
                              value,
                            ),
                            controller: controller.fullName.value,
                            hintText: "Enter your full name",
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r"[a-zA-Z\s]"),
                              ),
                            ],
                          ),
                          SizedBox(height: isTablet ? 18 : 12),

                          /// EMAIL
                          AuthField(
                            prefixIcon: const Icon(CupertinoIcons.mail),
                            validator: (value) =>
                                TValidator.validateEmail(value),
                            controller: controller.email.value,
                            hintText: "Enter your email",
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r"\s")),
                            ],
                          ),
                          SizedBox(height: isTablet ? 18 : 12),

                          /// PASSWORD
                          Obx(
                            () => AuthField(
                              prefixIcon: const Icon(CupertinoIcons.lock),
                              validator: (value) =>
                                  TValidator.validatePassword(value),
                              controller: controller.password.value,
                              hintText: "Enter your password",
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
                                FilteringTextInputFormatter.deny(RegExp(r"\s")),
                              ],
                            ),
                          ),
                          SizedBox(height: isTablet ? 18 : 12),

                          /// CONFIRM PASSWORD
                          Obx(
                            () => AuthField(
                              prefixIcon: const Icon(
                                CupertinoIcons.lock_rotation,
                              ),
                              validator: (value) =>
                                  TValidator.validateConfirmPassword(controller.password.value.text, value),
                              controller: controller.confirmPassword.value,
                              hintText: "Confirm password",
                              obsecure: controller.obsecureConfirm.value,
                              suffixIcon: GestureDetector(
                                onTap: () => controller.obsecureConfirm.value =
                                    !controller.obsecureConfirm.value,
                                child: Icon(
                                  controller.obsecureConfirm.value
                                      ? CupertinoIcons.eye
                                      : CupertinoIcons.eye_slash,
                                ),
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r"\s")),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: isTablet ? 55 : 45),

                    /// SIGNUP BUTTON / LOADER
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
                              label: "Create Account",
                              size: Size(width * 0.6, 52),
                              onPressed: () => controller.registerUser(),
                            ),
                    ),

                    SizedBox(height: isTablet ? 35 : 25),

                    /// FOOTER
                    Align(
                      alignment: Alignment.center,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Already have an account? ",
                              style: Theme.of(context).textTheme.titleLarge!
                                  .copyWith(
                                    color: Colors.black,
                                    fontSize: isTablet ? 16 : 14,
                                  ),
                            ),
                            TextSpan(
                              text: "Login",
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

                    SizedBox(height: height * 0.05),
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
