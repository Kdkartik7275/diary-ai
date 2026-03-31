import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/config/theme/theme_controller.dart';
import 'package:mindloom/features/profile/presentation/views/settings_view.dart';
import 'package:mindloom/features/profile/presentation/widgets/setting_section.dart';

class PrivacySettingsView extends StatelessWidget {
  const PrivacySettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDarkMode = themeController.isDarkMode;

    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Settings')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            const SizedBox(height: 10),

            /// 🔐 ACCOUNT PRIVACY
            SettingsSection(
              title: 'Account Privacy',
              isDarkMode: isDarkMode,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SettingsTile(
                    icon: CupertinoIcons.eye,
                    title: 'Private Account',
                    subtitle: 'Only you can see your diary entries',
                    isDarkMode: isDarkMode,
                    trailing: Switch.adaptive(
                      activeThumbColor: AppColors.primary,
                      value: true,
                      onChanged: (val) {},
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// 📖 DIARY PRIVACY
            SettingsSection(
              title: 'Diary Privacy',
              isDarkMode: isDarkMode,
              children: [
                SettingsTile(
                  icon: CupertinoIcons.lock,
                  title: 'Lock Diary',
                  subtitle: 'Require PIN / biometrics',
                  isDarkMode: isDarkMode,
                  trailing: Switch.adaptive(
                    activeThumbColor: AppColors.primary,
                    value: false,
                    onChanged: (val) {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SettingsTile(
                    icon: CupertinoIcons.doc_text,
                    title: 'Auto Delete Entries',
                    subtitle: 'Delete entries after 30 days',
                    isDarkMode: isDarkMode,
                    trailing: Switch.adaptive(
                      activeThumbColor: AppColors.primary,
                      value: false,
                      onChanged: (val) {},
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// 🔔 PERMISSIONS
            SettingsSection(
              title: 'Permissions',
              isDarkMode: isDarkMode,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SettingsTile(
                    icon: CupertinoIcons.mic,
                    title: 'Microphone Access',
                    subtitle: 'Voice notes support',
                    isDarkMode: isDarkMode,
                    trailing: Switch.adaptive(
                      activeThumbColor: AppColors.primary,
                      value: false,
                      onChanged: (val) {},
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// 🔑 SECURITY
            SettingsSection(
              title: 'Security',
              isDarkMode: isDarkMode,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SettingsTile(
                    icon: CupertinoIcons.refresh,
                    title: 'Reset Password',
                    subtitle: 'Send reset link to your email',
                    isDarkMode: isDarkMode,
                    onTap: () async {},
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
