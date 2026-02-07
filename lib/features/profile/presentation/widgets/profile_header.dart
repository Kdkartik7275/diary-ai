import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/features/profile/presentation/views/settings_view.dart';
import 'package:lifeline/features/user/domain/entity/user_entity.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key, required this.user});

  final UserEntity? user;

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  bool bioExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final user = widget.user!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 600;

    final avatarSize = isSmallScreen ? 80.0 : (isMediumScreen ? 90.0 : 100.0);
    final horizontalPadding = isSmallScreen ? 16.0 : 20.0;
    final bioPadding = isSmallScreen ? 24.0 : 32.0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.08),
            AppColors.primary.withValues(alpha: 0.02),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                12,
                horizontalPadding,
                0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Get.to(() => SettingsView()),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.settings_outlined,
                          size: isSmallScreen ? 20 : 22,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              height: avatarSize,
              width: avatarSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withValues(alpha: .85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: user.profileUrl != null && user.profileUrl!.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        user.profileUrl!,
                        fit: BoxFit.cover,
                        width: avatarSize,
                        height: avatarSize,
                      ),
                    )
                  : Center(
                      child: Text(
                        user.fullName[0].toUpperCase(),
                        style: theme.headlineLarge!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: avatarSize * 0.42,
                        ),
                      ),
                    ),
            ),

            SizedBox(height: 12),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Text(
                user.fullName,
                style: theme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Text(
                "@${user.username}",
                style: theme.titleSmall?.copyWith(
                  color: AppColors.textLighter,
                  fontWeight: FontWeight.w500,
                  fontSize: isSmallScreen ? 14 : null,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),

            if (user.bio != null && user.bio!.isNotEmpty) ...[
              SizedBox(height: isSmallScreen ? 10 : 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: bioPadding),
                child: Column(
                  children: [
                    AnimatedCrossFade(
                      firstChild: Text(
                        user.bio!.length > 100
                            ? "${user.bio!.substring(0, 100)}..."
                            : user.bio!,
                        textAlign: TextAlign.center,
                        style: theme.titleSmall?.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.normal,
                          height: 1.5,
                          fontSize: 13,
                        ),
                      ),
                      secondChild: Text(
                        user.bio!,
                        textAlign: TextAlign.center,
                        style: theme.titleSmall?.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.normal,
                          height: 1.5,
                          fontSize: 13,
                        ),
                      ),
                      crossFadeState: bioExpanded
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 300),
                    ),
                    if (user.bio!.length > 100) ...[
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            bioExpanded = !bioExpanded;
                          });
                        },
                        child: Text(
                          bioExpanded ? "Show less" : "Show more",
                          style: theme.titleSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.normal,
                            height: 1.5,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
