import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/core/di/init_dependencies.dart';
import 'package:lifeline/features/social/presentation/controllers/follow_controller.dart';
import 'package:lifeline/features/social/presentation/widgets/user_tile.dart';

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
    controller = Get.put(
      FollowController(followUserUseCase: sl(), getFollowStatusUseCase: sl()),
    );
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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            pinned: true,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F8FC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            title: Text(
              'Connections',
              style: theme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                letterSpacing: 0.4,
              ),
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
        ],
        body: Material(
          color: AppColors.white,
          child: TabBarView(
            controller: _tabController,
            children: [
              _FollowList(type: _ListType.followers, searchQuery: _searchQuery),
              _FollowList(type: _ListType.following, searchQuery: _searchQuery),
            ],
          ),
        ),
      ),
    );
  }
}

enum _ListType { followers, following }

class _FollowList extends StatelessWidget {
  const _FollowList({required this.type, required this.searchQuery});

  final _ListType type;
  final RxString searchQuery;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FollowController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      }

      final source = type == _ListType.followers
          ? controller.followers
          : controller.following;

      final filtered = searchQuery.value.isEmpty
          ? source
          : source.where((u) {
              final q = searchQuery.value;
              return u.fullName.toLowerCase().contains(q) ||
                  u.username.toLowerCase().contains(q);
            }).toList();

      if (filtered.isEmpty) {
        return _EmptyState(type: type, hasQuery: searchQuery.value.isNotEmpty);
      }

      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemCount: filtered.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return UserTile(user: filtered[index]);
        },
      );
    });
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.type, required this.hasQuery});

  final _ListType type;
  final bool hasQuery;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final isFollowers = type == _ListType.followers;

    final icon = hasQuery
        ? Icons.search_off_rounded
        : (isFollowers
              ? Icons.people_outline_rounded
              : Icons.person_add_alt_1_outlined);

    final title = hasQuery
        ? 'No results found'
        : (isFollowers ? 'No followers yet' : 'Not following anyone');

    final subtitle = hasQuery
        ? 'Try a different name or username'
        : (isFollowers
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
