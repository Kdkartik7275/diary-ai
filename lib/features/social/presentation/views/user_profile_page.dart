// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/core/utils/helpers/functions.dart';
import 'package:mindloom/features/social/presentation/controllers/follow_controller.dart';
import 'package:mindloom/features/social/presentation/widgets/stories.dart';
import 'package:mindloom/features/user/domain/entity/user_entity.dart';
import 'package:mindloom/features/user/domain/entity/user_stats.dart';
import 'package:mindloom/features/user/presentation/controller/user_controller.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key, required this.userId});
  final String userId;

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
    with SingleTickerProviderStateMixin {
  late UserController controller;
  late FollowController followController;
  late UserEntity currentUser;

  @override
  void initState() {
    super.initState();

    controller = Get.find<UserController>();

    followController = Get.find<FollowController>();

    currentUser = controller.currentUser.value!;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      followController.checkFollowStatus(
        currentUserId: currentUser.id,
        targetUserId: widget.userId,
      );
    });
    controller.getUserStories(userId: widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(),
      body: FutureBuilder<UserEntity>(
        future: controller.getUserById(userId: widget.userId),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2,
              ),
            );
          }
          if (asyncSnapshot.hasError) {
            return Center(
              child: Text(
                asyncSnapshot.error.toString(),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.normal,
                ),
              ),
            );
          }
          if (!asyncSnapshot.hasData) {
            return Center(
              child: Text(
                'Something went wrong.',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.normal,
                ),
              ),
            );
          }
          final user = asyncSnapshot.data!;
          return SafeArea(
            child: RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.white,
              onRefresh: () async {
                setState(() {});
                followController.checkFollowStatus(
                  currentUserId: currentUser.id,
                  targetUserId: widget.userId,
                );
              },
              child: ListView(
                children: [
                  _buildHeader(tt, user),
                  Stories(userId: user.id),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(TextTheme tt, UserEntity user) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor: AppColors.primary,

            child: (user.profileUrl == null || user.profileUrl!.isEmpty)
                ? Text(
                    user.fullName[0].toUpperCase(),
                    style: tt.headlineMedium?.copyWith(color: AppColors.white),
                  )
                : ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: user.profileUrl!,
                      width: 84,
                      height: 84,
                      fit: BoxFit.cover,
                      errorWidget: (context, error, stackTrace) {
                        return Center(
                          child: Text(
                            nameInitials(user.fullName),
                            style: tt.titleSmall!.copyWith(
                              color: AppColors.text,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
          const SizedBox(height: 14),
          // Name
          Text(
            user.fullName,
            style: tt.titleLarge?.copyWith(
              fontWeight: FontWeight.normal,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 4),
          if (user.username != null && user.username!.isNotEmpty) ...[
            Text(
              '@${user.username!}',

              style: tt.titleSmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 10),
          ],
          if (user.bio != null && user.bio!.isNotEmpty) ...[
            Text(
              user.bio!,
              style: const TextStyle(
                fontSize: 13.5,
                color: AppColors.textLighter,
                height: 1.55,
              ),
            ),
            const SizedBox(height: 10),
          ],

          // Stats row
          FutureBuilder<UserStats>(
            future: controller.getUserStats(userId: user.id),
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.filled.withValues(alpha: .4),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _statLoadingItem(),
                      _vertDivider(),
                      _statLoadingItem(),
                      _vertDivider(),
                      _statLoadingItem(),
                    ],
                  ),
                );
              }
              if (asyncSnapshot.hasError) {
                return Center(
                  child: Text(
                    asyncSnapshot.error.toString(),
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                );
              }
              if (!asyncSnapshot.hasData) {
                return Center(
                  child: Text(
                    'Something went wrong.',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                );
              }
              final stat = asyncSnapshot.data;
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.filled.withValues(alpha: .4),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _statItem(
                      tt,
                      (stat?.storiesCount ?? 0).toString(),
                      'Stories',
                    ),
                    _vertDivider(),
                    _statItem(
                      tt,
                      formatCount(stat?.followersCount ?? 0),
                      'Followers',
                    ),
                    _vertDivider(),
                    _statItem(
                      tt,
                      formatCount(stat?.followingCount ?? 0),
                      'Following',
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _followButton(tt, user)),
              const SizedBox(width: 10),
              _messageButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(TextTheme tt, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: tt.titleSmall?.copyWith(
            color: AppColors.hintText,
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _statLoadingItem() {
    return Column(
      children: [
        Container(
          height: 20,
          width: 40,
          decoration: BoxDecoration(
            color: AppColors.hintText.withValues(alpha: .2),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 12,
          width: 60,
          decoration: BoxDecoration(
            color: AppColors.hintText.withValues(alpha: .15),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _vertDivider() => Container(
    height: 32,
    width: 1,
    color: AppColors.border.withValues(alpha: .6),
  );

  Widget _followButton(TextTheme tt, UserEntity user) {
    if (currentUser.id == user.id) {
      return const SizedBox.shrink();
    }

    return Obx(() {
      final isFollowing = followController.isFollowing.value;
      final isLoading = followController.isLoading.value;
      final isFollowedByUser = followController.isFollowedBy.value;

      return isLoading
          ? Center(
              child: const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
            )
          : AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 46,
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
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextButton.icon(
                onPressed: isLoading
                    ? null
                    : () async {
                        await followController.followUser(
                          currentUserId: currentUser.id,
                          currentUserFullName: currentUser.fullName,
                          targetUserId: user.id,
                        );
                      },
                icon: Icon(
                  isFollowing
                      ? Icons.person_remove_outlined
                      : Icons.person_add_outlined,
                  color: isFollowing ? AppColors.primary : AppColors.white,
                  size: 18,
                ),
                label: Text(
                  isFollowing
                      ? 'Following'
                      : isFollowedByUser
                      ? 'Follow Back'
                      : 'Follow',
                  style: tt.titleLarge?.copyWith(
                    color: isFollowing ? AppColors.primary : AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            );
    });
  }

  Widget _messageButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 46,
        width: 46,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.chat_bubble_outline_rounded,
          size: 20,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
