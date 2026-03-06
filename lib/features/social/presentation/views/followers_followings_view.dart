import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/features/social/presentation/controllers/follow_controller.dart';
import 'package:mindloom/features/social/presentation/widgets/user_tile.dart';

class FollowersFollowingView extends StatefulWidget {
  const FollowersFollowingView({
    super.key,
    this.initialTab = 0,
    this.followersCount = 0,
    this.followingCount = 0,
  });

  final int initialTab;
  final int followersCount;
  final int followingCount;

  @override
  State<FollowersFollowingView> createState() => _FollowersFollowingViewState();
}

class _FollowersFollowingViewState extends State<FollowersFollowingView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final RxString _searchQuery = ''.obs;

  late final FollowController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<FollowController>();
    controller.fetchFollowers();
    controller.fetchFollowing();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab,
    );
    _searchController.addListener(() {
      _searchQuery.value = _searchController.text.trim().toLowerCase();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Connections',
          style: theme.titleLarge?.copyWith(letterSpacing: 0.4),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                labelStyle: theme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                unselectedLabelStyle: theme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.black45,
                indicatorColor: AppColors.primary,
                indicatorWeight: 2.5,
                indicatorSize: TabBarIndicatorSize.label,
                dividerColor: Colors.black.withValues(alpha: 0.06),
                tabs: [
                  Tab(text: 'Followers  ${widget.followersCount}'),
                  Tab(text: 'Following  ${widget.followingCount}'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Material(
        color: AppColors.white,
        child: TabBarView(
          controller: _tabController,

          children: [
            _FollowList(type: _ListType.followers),
            _FollowList(type: _ListType.following),
          ],
        ),
      ),
    );
  }
}

enum _ListType { followers, following }

class _FollowList extends StatelessWidget {
  const _FollowList({required this.type});

  final _ListType type;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FollowController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        );
      }

      final source = type == _ListType.followers
          ? controller.followers
          : controller.following;

      if (source.isEmpty) {
        return _EmptyState(type: type);
      }

      return RefreshIndicator(
        backgroundColor: AppColors.white,
        color: AppColors.primary,
        onRefresh: () async {
          if (type == _ListType.followers) {
            await controller.fetchFollowers();
          } else {
            await controller.fetchFollowing();
          }
        },
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          itemCount: source.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            return UserTile(userId: source[index].id);
          },
        ),
      );
    });
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.type});

  final _ListType type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final isFollowers = type == _ListType.followers;

    final icon = (isFollowers
        ? Icons.people_outline_rounded
        : Icons.person_add_alt_1_outlined);

    final title = (isFollowers ? 'No followers yet' : 'Not following anyone');

    final subtitle = (isFollowers
        ? 'When people follow you, they\'ll appear here'
        : 'Start following people to see them here');

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 36,
                color: AppColors.primary.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: theme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: theme.titleSmall?.copyWith(
                color: AppColors.textLighter,
                fontWeight: FontWeight.normal,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
