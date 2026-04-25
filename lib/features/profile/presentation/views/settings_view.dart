import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/config/routes/app_routes.dart';
import 'package:mindloom/config/theme/theme_controller.dart';
import 'package:mindloom/core/containers/rounded_container.dart';
import 'package:mindloom/features/profile/presentation/views/account_details.dart';
import 'package:mindloom/features/profile/presentation/views/privacy_setting_view.dart';
import 'package:mindloom/features/profile/presentation/widgets/setting_section.dart';
import 'package:mindloom/services/database/database_service.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final theme = Theme.of(context).textTheme;
    final themeController = Get.find<ThemeController>();
    final isDarkMode = themeController.isDarkMode;
    String selectedLanguage = 'English';
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          children: [
            SizedBox(height: height * 0.01),
            Text(
              'Settings',
              style: theme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 2),
            Text(
              'Customize your experience',
              style: theme.titleSmall!.copyWith(
                color: AppColors.textLighter,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: height * 0.02),

            SettingsSection(
              title: 'Appearance',
              isDarkMode: isDarkMode,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),

                  child: SettingsTile(
                    icon: CupertinoIcons.brightness,
                    title: 'Dark Mode',
                    subtitle: 'Switch between light and dark theme',
                    isDarkMode: isDarkMode,
                    trailing: Switch.adaptive(
                      activeThumbColor: AppColors.primary,
                      value: themeController.isDarkMode,
                      onChanged: (val) {
                        themeController.toggleTheme();
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.02),

            SettingsSection(
              title: 'Account',
              isDarkMode: isDarkMode,
              children: [
                SettingsTile(
                  icon: CupertinoIcons.person,
                  title: 'Account Details',
                  isDarkMode: isDarkMode,
                  onTap: () => Get.to(() => const AccountDetailsView()),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SettingsTile(
                    icon: CupertinoIcons.refresh_thin,
                    title: 'Data Backup',
                    subtitle: 'Last synced: 2 hours ago',
                    isDarkMode: isDarkMode,
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.02),

            SettingsSection(
              title: 'Notifications',
              isDarkMode: isDarkMode,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),

                  child: SettingsTile(
                    icon: CupertinoIcons.bell,
                    title: 'Daily Reminders',
                    subtitle: 'Get reminded to write daily',
                    isDarkMode: isDarkMode,
                    trailing: Switch.adaptive(
                      activeThumbColor: AppColors.primary,
                      value: true,
                      onChanged: (_) {},
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.02),

            SettingsSection(
              title: 'Preferences',
              isDarkMode: isDarkMode,
              children: [
                SettingsTile(
                  onTap: () {
                    showLanguageModal(
                      isDarkMode: isDarkMode,
                      selectedLanguage: selectedLanguage,
                      onSelect: (lang) {
                        selectedLanguage = lang;

                      
                      },
                    );
                  },
                  icon: CupertinoIcons.globe,
                  title: 'Language',
                  subtitle: selectedLanguage,
                  isDarkMode: isDarkMode,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SettingsTile(
                    onTap: () => Get.to(() => const PrivacySettingsView()),
                    icon: CupertinoIcons.lock,
                    title: 'Privacy Settings',
                    isDarkMode: isDarkMode,
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.03),

            InkWell(
              onTap: () async {
                await DataBaseService.instance.deleteUser(
                  userId: FirebaseAuth.instance.currentUser!.uid,
                );
                await FirebaseAuth.instance.signOut();

                Get.offAllNamed(Routes.login);
              },
              child: TRoundedContainer(
                width: width,
                height: height * .06,
                backgroundColor: isDarkMode ? Colors.red : AppColors.white,
                borderColor: Colors.red,
                radius: 16,
                showBorder: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout_outlined,
                      color: isDarkMode ? Colors.white : Colors.red,
                    ),
                    SizedBox(width: width * .01),
                    Text(
                      'Log Out',
                      style: theme.titleLarge!.copyWith(
                        color: isDarkMode ? Colors.white : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: height * 0.04),

            Align(
              alignment: Alignment.center,
              child: Text(
                'StoryDiary AI v1.0.0',
                style: theme.titleSmall!.copyWith(color: AppColors.textLighter),
              ),
            ),
            SizedBox(height: height * 0.04),
          ],
        ),
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.isDarkMode,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return ListTile(
      onTap: onTap,
      leading: Icon(icon),
      title: Text(
        title,
        style: theme.titleLarge!.copyWith(
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: theme.titleSmall!.copyWith(
                color: AppColors.textLighter,
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
            ),
      trailing: trailing,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      minVerticalPadding: 0,
      visualDensity: const VisualDensity(vertical: -4),
    );
  }
}

void showLanguageModal({
  required bool isDarkMode,
  required String selectedLanguage,
  required Function(String) onSelect,
}) {
  final languages = ['English', 'Hindi', 'Spanish', 'French', 'German'];

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Wrap(
        children: [
          /// Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          /// Title
          const Text(
            'Select Language',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 16),

          /// Language List
          ...languages.map((lang) {
            final isSelected = selectedLanguage == lang;

            return ListTile(
              onTap: () {
                onSelect(lang);
                Get.back();
              },
              leading: const Icon(CupertinoIcons.globe),
              title: Text(lang),
              trailing: Icon(
                isSelected
                    ? CupertinoIcons.check_mark_circled_solid
                    : CupertinoIcons.circle,
                color: isSelected ? AppColors.primary : Colors.grey,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            );
          }),
        ],
      ),
    ),
  );
}
