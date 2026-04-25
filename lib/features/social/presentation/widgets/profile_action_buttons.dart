// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/features/social/presentation/controllers/follow_controller.dart';
import 'package:mindloom/features/user/domain/entity/user_entity.dart';

/// Follow + Message buttons rendered side-by-side.
/// Hidden entirely when viewing your own profile.
class ProfileActionButtons extends StatelessWidget {
  const ProfileActionButtons({
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

  bool get _isOwnProfile => currentUser.id == user.id;

  @override
  Widget build(BuildContext context) {
    if (_isOwnProfile) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _FollowButton(
          user: user,
          currentUser: currentUser,
          followController: followController,
        ),
      ],
    );
  }
}

// ── Follow button ────────────────────────────────────────────────

class _FollowButton extends StatelessWidget {
  const _FollowButton({
    required this.user,
    required this.currentUser,
    required this.followController,
  });

  final UserEntity user;
  final UserEntity currentUser;
  final FollowController followController;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Obx(() {
      final isFollowing = followController.isFollowing.value;
      final isLoading = followController.isLoading.value;
      final isFollowedByUser = followController.isFollowedBy.value;

      if (isLoading) {
        return const SizedBox(
          height: 40,
          width: 40,
          child: Center(
            child: SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
          ),
        );
      }

      return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 40,
        decoration: BoxDecoration(
          color: isFollowing ? AppColors.white : null,
          gradient: isFollowing
              ? null
              : LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: .7),
                    AppColors.primary,
                  ],
                ),
          borderRadius: BorderRadius.circular(12),
          border: isFollowing
              ? Border.all(color: AppColors.primary.withValues(alpha: .4))
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextButton.icon(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            minimumSize: const Size(0, 40),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: isLoading
              ? null
              : () async {
                  if (isFollowing) {
                    await followController.unfollowUser(
                      currentUserId: currentUser.id,
                      currentUserFullName: currentUser.fullName,
                      targetUserId: user.id,
                    );
                  } else {
                    await followController.followUser(
                      currentUserId: currentUser.id,
                      currentUserFullName: currentUser.fullName,
                      targetUserId: user.id,
                    );
                  }
                },
          icon: Icon(
            isFollowing
                ? Icons.person_remove_outlined
                : Icons.person_add_outlined,
            color: isFollowing ? AppColors.primary : AppColors.white,
            size: 16,
          ),
          label: Text(
            isFollowing
                ? 'Following'
                : isFollowedByUser
                ? 'Follow Back'
                : 'Follow',
            style: tt.labelLarge?.copyWith(
              color: isFollowing ? AppColors.primary : AppColors.white,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      );
    });
  }
}
