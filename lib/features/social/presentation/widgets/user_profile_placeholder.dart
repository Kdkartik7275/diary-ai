// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/features/social/presentation/controllers/follow_controller.dart';
import 'package:mindloom/features/social/presentation/widgets/profile_action_buttons.dart';
import 'package:mindloom/features/user/domain/entity/user_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mindloom/core/utils/helpers/functions.dart';

/// Full-screen placeholder shown when an account has been deleted.
class DeletedUserView extends StatelessWidget {
  const DeletedUserView({super.key, required this.isDarkMode});

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDarkMode
                      ? AppColors.darkSurface
                      : AppColors.filled.withValues(alpha: .4),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.person_outline_rounded,
                      size: 38,
                      color: isDarkMode
                          ? AppColors.textDarkSecondary
                          : AppColors.hintText,
                    ),
                    Transform.rotate(
                      angle: -0.785,
                      child: Container(
                        width: 2,
                        height: 64,
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? AppColors.textDarkSecondary
                              : AppColors.hintText,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Account deleted',
                style: tt.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This account is no longer available. The user may have deleted their account.',
                textAlign: TextAlign.center,
                style: tt.titleSmall?.copyWith(
                  fontWeight: FontWeight.normal,
                  color: isDarkMode
                      ? AppColors.textDarkSecondary
                      : AppColors.textLighter,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shown when a profile is private and the current user is not following.
/// Still renders avatar + name + follow button so visitors can request to follow.
class PrivateProfileView extends StatelessWidget {
  const PrivateProfileView({
    super.key,
    required this.user,
    required this.currentUser,
    required this.isDarkMode,
    required this.followController,
  });

  final UserEntity user;
  final UserEntity currentUser;
  final bool isDarkMode;
  final FollowController followController;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return ListView(
      children: [
        _buildMiniHeader(tt),
        const SizedBox(height: 32),
        _buildLockNotice(tt),
      ],
    );
  }

  Widget _buildMiniHeader(TextTheme tt) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: isDarkMode
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .06),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor: AppColors.primary.withValues(alpha: .15),
            child: (user.profileUrl == null || user.profileUrl!.isEmpty)
                ? Text(
                    user.fullName[0].toUpperCase(),
                    style: tt.headlineMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: user.profileUrl!,
                      width: 84,
                      height: 84,
                      fit: BoxFit.cover,
                      errorWidget: (context, _, __) => Center(
                        child: Text(
                          nameInitials(user.fullName),
                          style: tt.titleMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 14),
          Text(
            user.fullName,
            style: tt.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              letterSpacing: -0.3,
            ),
          ),
          if (user.username != null && user.username!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              '@${user.username!}',
              style: tt.bodySmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
          const SizedBox(height: 16),
          ProfileActionButtons(
            user: user,
            currentUser: currentUser,
            isDarkMode: isDarkMode,
            followController: followController,
          ),
        ],
      ),
    );
  }

  Widget _buildLockNotice(TextTheme tt) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDarkMode
                ? AppColors.darkSurface
                : AppColors.filled.withValues(alpha: .5),
          ),
          child: Icon(
            Icons.lock_outline_rounded,
            size: 32,
            color: isDarkMode
                ? AppColors.textDarkSecondary
                : AppColors.hintText,
          ),
        ),
        const SizedBox(height: 16),
        // tt is not accessible here directly, so we use a Builder
        Builder(builder: (context) {
          final tt = Theme.of(context).textTheme;
          return Column(
            children: [
              Text(
                'This account is private',
                style: tt.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Text(
                  'Follow this account to see their stories and activity.',
                  textAlign: TextAlign.center,
                  style: tt.titleSmall?.copyWith(
                    fontWeight: FontWeight.normal,
                    color: isDarkMode
                        ? AppColors.textDarkSecondary
                        : AppColors.textLighter,
                    height: 1.6,
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}

/// Inline placeholder shown inside the normal profile when stories are private.
class StoriesLockedView extends StatelessWidget {
  const StoriesLockedView({super.key, required this.isDarkMode});

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 32),
      child: Column(
        children: [
          Icon(
            Icons.auto_stories_outlined,
            size: 36,
            color: isDarkMode
                ? AppColors.textDarkSecondary
                : AppColors.hintText,
          ),
          const SizedBox(height: 10),
          Text(
            'Stories are private',
            style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            'Follow this account to view their stories.',
            textAlign: TextAlign.center,
            style: tt.titleSmall?.copyWith(
              fontWeight: FontWeight.normal,
              color: isDarkMode
                  ? AppColors.textDarkSecondary
                  : AppColors.textLighter,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}