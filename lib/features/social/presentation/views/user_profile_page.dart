// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/config/theme/theme_controller.dart';
import 'package:mindloom/features/social/presentation/controllers/follow_controller.dart';
import 'package:mindloom/features/social/presentation/widgets/stories.dart';
import 'package:mindloom/features/social/presentation/widgets/user_profile_header.dart';
import 'package:mindloom/features/social/presentation/widgets/user_profile_placeholder.dart';
import 'package:mindloom/features/user/domain/entity/user_entity.dart';
import 'package:mindloom/features/user/domain/entity/user_stats.dart';
import 'package:mindloom/features/user/presentation/controller/user_controller.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key, required this.userId});
  final String userId;

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late UserController _controller;
  late FollowController _followController;
  late UserEntity _currentUser;
  late bool _isDarkMode;
  final ScrollController _scrollController = ScrollController();

  late Future<UserEntity> _userFuture;
  late Future<UserStats> _statsFuture;

  bool get _isOwnProfile => _currentUser.id == widget.userId;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<UserController>();
    _isDarkMode = Get.find<ThemeController>().isDarkMode;
    _followController = Get.find<FollowController>();
    _currentUser = _controller.currentUser.value!;

    _userFuture = _controller.getUserById(userId: widget.userId);
    _statsFuture = _controller.getUserStats(userId: widget.userId);

    _scrollController.addListener(() {
      final pos = _scrollController.position;

      if (pos.pixels >= pos.maxScrollExtent - 200) {
        _controller.loadMoreUserStories(userId: widget.userId);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _followController.checkFollowStatus(
        currentUserId: _currentUser.id,
        targetUserId: widget.userId,
      );
    });
    _controller.getUserStories(userId: widget.userId);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    setState(() {
      _userFuture = _controller.getUserById(userId: widget.userId);
      _statsFuture = _controller.getUserStats(userId: widget.userId);
    });
    await _userFuture;
    _followController.checkFollowStatus(
      currentUserId: _currentUser.id,
      targetUserId: widget.userId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<UserEntity>(
        future: _userFuture,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2,
              ),
            );
          }
          if (snap.hasError) {
            return _buildMessage(context, snap.error.toString(), isError: true);
          }
          if (!snap.hasData) {
            return _buildMessage(
              context,
              'Something went wrong.',
              isError: true,
            );
          }

          final user = snap.data!;

          if (user.isDeleted ?? false) {
            return DeletedUserView(isDarkMode: _isDarkMode);
          }

          return SafeArea(
            child: RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: _isDarkMode
                  ? AppColors.darkSurface
                  : AppColors.white,
              onRefresh: _onRefresh,
              child: Obx(() {
                final isFollowing = _followController.isFollowing.value;
                final isProfilePrivate = !(user.profileVisibility ?? true);

                if (isProfilePrivate && !isFollowing && !_isOwnProfile) {
                  return PrivateProfileView(
                    user: user,
                    currentUser: _currentUser,
                    isDarkMode: _isDarkMode,
                    followController: _followController,
                  );
                }

                return ListView(
                  controller: _scrollController, // add
                  children: [
                    UserProfileHeader(
                      user: user,
                      currentUser: _currentUser,
                      isDarkMode: _isDarkMode,
                      controller: _controller,
                      followController: _followController,
                      statsFuture: _statsFuture,
                    ),
                    _buildStoriesSection(user, isFollowing),
                  ],
                );
              }),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStoriesSection(UserEntity user, bool isFollowing) {
    final canSeeStories =
        _isOwnProfile || (user.isStoriesPublic ?? true) || isFollowing;

    if (canSeeStories) {
      return Stories(userId: user.id);
    }
    return StoriesLockedView(isDarkMode: _isDarkMode);
  }

  Widget _buildMessage(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    return Center(
      child: Text(
        message,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: isError ? AppColors.error : null,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
