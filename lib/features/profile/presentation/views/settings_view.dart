import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/config/routes/app_routes.dart';
import 'package:lifeline/core/containers/rounded_container.dart';
import 'package:lifeline/features/profile/presentation/views/account_details.dart';
import 'package:lifeline/features/profile/presentation/widgets/setting_section.dart';
import 'package:lifeline/services/database/database_service.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final theme = Theme.of(context).textTheme;

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
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),

                  child: SettingsTile(
                    icon: CupertinoIcons.brightness,
                    title: 'Dark Mode',
                    subtitle: 'Switch between light and dark theme',
                    trailing: Switch.adaptive(
                      activeThumbColor: AppColors.primary,
                      value: false,
                      onChanged: (_) {},
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.02),

            SettingsSection(
              title: 'Account',
              children: [
                SettingsTile(
                  icon: CupertinoIcons.person,
                  title: 'Account Details',
                  onTap: () => Get.to(() => const AccountDetailsView()),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SettingsTile(
                    icon: CupertinoIcons.refresh_thin,
                    title: 'Data Backup',
                    subtitle: 'Last synced: 2 hours ago',
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.02),

            SettingsSection(
              title: 'Notifications',
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),

                  child: SettingsTile(
                    icon: CupertinoIcons.bell,
                    title: 'Daily Reminders',
                    subtitle: 'Get reminded to write daily',
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
              children: [
                SettingsTile(
                  icon: CupertinoIcons.globe,
                  title: 'Language',
                  subtitle: 'English',
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SettingsTile(
                    icon: CupertinoIcons.lock,
                    title: 'Privacy Settings',
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.03),

            InkWell(
              onTap: ()async{
                  await DataBaseService.instance.deleteUser(userId: FirebaseAuth.instance.currentUser!.uid);
               await FirebaseAuth.instance.signOut();
             
               Get.offAllNamed(Routes.login);

              },
              child: TRoundedContainer(
                width: width,
                height: height * .06,
                borderColor: Colors.red,
                radius: 16,
                showBorder: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_outlined, color: Colors.red),
                    SizedBox(width: width * .01),
                    Text(
                      'Log Out',
                      style: theme.titleLarge!.copyWith(color: Colors.red),
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
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

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
