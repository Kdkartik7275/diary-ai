// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/config/theme/theme_controller.dart';
import 'package:mindloom/features/explore/presentation/view/reading_view.dart';
import 'package:mindloom/features/story/domain/entity/story_entity.dart';
import 'package:mindloom/features/user/presentation/controller/user_controller.dart';

class Stories extends StatefulWidget {
  final String userId;
  const Stories({super.key, required this.userId});

  @override
  State<Stories> createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  late UserController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<UserController>();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final stories = _controller.userStories[widget.userId];
      final isLoadingMore =
          _controller.userStoriesLoadingMore[widget.userId] == true;

      if (_controller.userStoriesLoading.value) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 22),
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2,
            ),
          ),
        );
      }

      if (stories == null || stories.isEmpty) {
        return const _ProfileStoriesEmptyState();
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: stories.length + (isLoadingMore ? 2 : 0),
        itemBuilder: (_, i) {
          if (i >= stories.length) {
            return const _StoryShimmerCard();
          }

          return UserStoryCard(story: stories[i]);
        },
      );
    });
  }
}

class _ProfileStoriesEmptyState extends StatelessWidget {
  const _ProfileStoriesEmptyState();

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 28),
          Text(
            'No stories published',
            style: tt.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'When they publish their first story,\nit will appear here.',
            style: tt.titleSmall?.copyWith(
              color: AppColors.hintText,
              fontWeight: FontWeight.normal,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class UserStoryCard extends StatelessWidget {
  const UserStoryCard({super.key, required this.story});
  final StoryEntity story;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final isDarkMode = Get.find<ThemeController>().isDarkMode;

    return GestureDetector(
      onTap: () =>
          Get.to(() => StoryReadingView(story: story, authorId: story.userId)),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkSurface : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isDarkMode
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDarkMode ? AppColors.darkSurface : AppColors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: story.coverImageUrl != null
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: CachedNetworkImage(
                          height: double.infinity,
                          width: double.infinity,
                          imageUrl: story.coverImageUrl!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        'assets/icons/logo_new.png',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    story.title,
                    style: tt.titleSmall?.copyWith(
                      color: isDarkMode
                          ? AppColors.textDarkSecondary
                          : AppColors.text,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${story.chapters.length} Chapters',
                    style: tt.titleSmall?.copyWith(
                      color: isDarkMode
                          ? AppColors.textDarkSecondary
                          : AppColors.hintText,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryShimmerCard extends StatelessWidget {
  const _StoryShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade500,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 12,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 10,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
