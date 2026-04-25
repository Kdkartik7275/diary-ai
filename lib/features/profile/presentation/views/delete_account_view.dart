import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/config/theme/theme_controller.dart';
import 'package:mindloom/core/containers/rounded_container.dart';
import 'package:mindloom/features/profile/presentation/widgets/delete_account_modal.dart';
import 'package:mindloom/features/profile/presentation/widgets/loading_deleting_user.dart';
import 'package:mindloom/features/user/presentation/controller/user_controller.dart';

class DeleteAccountView extends StatelessWidget {
  const DeleteAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();
    final isDarkMode = Get.find<ThemeController>().isDarkMode;

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text('Delete Account', style: theme.titleLarge)),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.02),

            TRoundedContainer(
              padding: const EdgeInsets.all(16),
              radius: 16,
              backgroundColor: Colors.red.withValues(alpha: .08),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.red),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'This action is permanent and cannot be undone.',
                      style: theme.titleSmall!.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: height * 0.03),

            /// 🧠 Explanation
            Text(
              'What happens when you delete your account?',
              style: theme.titleLarge!.copyWith(fontWeight: FontWeight.normal),
            ),

            SizedBox(height: height * 0.015),

            _buildPoint(
              'Your profile will be permanently removed',
              theme,
              isDarkMode,
            ),
            _buildPoint(
              'Your stories may be deleted or anonymized',
              theme,
              isDarkMode,
            ),
            _buildPoint('Your saved stories will be lost', theme, isDarkMode),
            _buildPoint(
              'You will not be able to recover your account',
              theme,
              isDarkMode,
            ),

            SizedBox(height: height * 0.02),

            TRoundedContainer(
              padding: const EdgeInsets.all(16),
              radius: 16,
              backgroundColor: isDarkMode
                  ? AppColors.darkSurface
                  : AppColors.white,
              boxShadow: isDarkMode
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delete your account',
                    style: theme.titleSmall!.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Permanently delete your account and all associated data.',
                    style: theme.titleSmall!.copyWith(
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                      color: isDarkMode
                          ? AppColors.textDarkSecondary
                          : AppColors.textLighter,
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        side: BorderSide(
                          color: Colors.red.withValues(alpha: .2),
                          width: 1,
                        ),
                      ),
                      onPressed: () {
                        showDeleteAccountModal(
                          onConfirm: (password) async {
                            Get.back(); // close confirm modal

                            showDeletingAccountModal();

                            try {
                              await controller.deleteAccount(password);
                            } catch (e) {
                              Get.back(); // close loading modal
                              Get.snackbar('Error', e.toString());
                            }
                          },
                        );
                      },
                      child: Text(
                        'Delete Account',
                        style: theme.titleSmall!.copyWith(
                          color: AppColors.white,
                          letterSpacing: .7,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: height * 0.04),
          ],
        ),
      ),
    );
  }

  Widget _buildPoint(String text, TextTheme theme, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(
            child: Text(
              text,
              style: theme.titleSmall!.copyWith(
                fontWeight: FontWeight.normal,
                fontSize: 13,
                color: isDarkMode
                    ? AppColors.textDarkSecondary
                    : AppColors.textLighter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
