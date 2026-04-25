// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/core/utils/helpers/functions.dart';
import 'package:mindloom/features/social/presentation/controllers/follow_controller.dart';
import 'package:mindloom/features/social/presentation/widgets/profile_action_buttons.dart';
import 'package:mindloom/features/social/presentation/widgets/user_profile_stat_chip.dart';
import 'package:mindloom/features/user/domain/entity/user_entity.dart';
import 'package:mindloom/features/user/domain/entity/user_stats.dart';
import 'package:mindloom/features/user/presentation/controller/user_controller.dart';

class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({
    super.key,
    required this.user,
    required this.currentUser,
    required this.isDarkMode,
    required this.controller,
    required this.followController,
    required this.statsFuture,
  });

  final UserEntity user;
  final UserEntity currentUser;
  final bool isDarkMode;
  final UserController controller;
  final FollowController followController;

  final Future<UserStats> statsFuture;

  bool get _isOwnProfile => currentUser.id == user.id;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
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
        children: [_buildBannerWithAvatar(context), _buildInfo(context)],
      ),
    );
  }

  // ── Banner + floating avatar + action buttons ──────────────────
  Widget _buildBannerWithAvatar(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Gradient banner
        Container(
          height: 90,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withValues(alpha: .15),
                AppColors.primary.withValues(alpha: .35),
              ],
            ),
          ),
        ),

        // Avatar — overlaps banner
        Positioned(
          bottom: -36,
          left: 20,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDarkMode ? AppColors.darkSurface : AppColors.white,
            ),
            child: _buildAvatar(tt),
          ),
        ),

        // Action buttons — top-right of banner
        if (!_isOwnProfile)
          Positioned(
            bottom: -22,
            right: 16,
            child: ProfileActionButtons(
              user: user,
              currentUser: currentUser,
              isDarkMode: isDarkMode,
              followController: followController,
            ),
          ),
      ],
    );
  }

  Widget _buildAvatar(TextTheme tt) {
    return CircleAvatar(
      radius: 36,
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
                width: 72,
                height: 72,
                fit: BoxFit.cover,
                errorWidget: (context, _, _) => Center(
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
    );
  }

  // ── Name / Username / Bio / Stats ─────────────────────────────
  Widget _buildInfo(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 48, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          Text(
            user.fullName,
            style: tt.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              letterSpacing: -0.3,
            ),
          ),

          // Username
          if (user.username != null && user.username!.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              '@${user.username!}',
              style: tt.titleSmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],

          // Bio
          if (user.bio != null && user.bio!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              user.bio!,
              style: tt.titleSmall?.copyWith(
                fontSize: 13.5,
                fontWeight: FontWeight.normal,
                color: isDarkMode
                    ? AppColors.textDarkSecondary
                    : AppColors.textLighter,
                height: 1.55,
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Stats — uses the pre-created future, never recreated on rebuild
          FutureBuilder<UserStats>(
            future: statsFuture,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return ProfileStatsRow.loading(isDarkMode: isDarkMode);
              }
              if (!snap.hasData) return const SizedBox.shrink();
              final stat = snap.data!;
              return ProfileStatsRow(
                storiesCount: stat.storiesCount,
                followersCount: stat.followersCount,
                followingCount: stat.followingCount,
                isDarkMode: isDarkMode,
              );
            },
          ),
        ],
      ),
    );
  }
}
