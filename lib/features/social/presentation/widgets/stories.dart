// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/features/explore/presentation/view/reading_view.dart';
import 'package:mindloom/features/story/domain/entity/story_entity.dart';
import 'package:mindloom/features/user/presentation/controller/user_controller.dart';

class Stories extends GetView<UserController> {
  final String userId;
  const Stories({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final stories = controller.userStories[userId];

      if (controller.userStatLoading.value) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 22),
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2,
            ),
          ),
        );
      }
      return (stories == null || stories.isEmpty)
          ? _ProfileStoriesEmptyState()
          : GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: stories.length,
              itemBuilder: (_, i) => UserStoryCard(story: stories[i]),
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
            "No stories published",
            style: tt.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
              color: AppColors.text,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            "When they publish their first story,\nit will appear here.",
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

    return GestureDetector(
      onTap: () =>
          Get.to(() => StoryReadingView(story: story, authorId: story.userId)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
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
            // Thumbnail
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: story.coverImageUrl != null
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.network(
                          height: double.infinity,
                          width: double.infinity,
                          story.coverImageUrl!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        CupertinoIcons.book,
                        color: AppColors.white,
                        size: 40,
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
                    style: tt.titleSmall?.copyWith(color: AppColors.text),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${story.chapters.length} Chapters",
                    style: tt.titleSmall?.copyWith(
                      color: AppColors.hintText,
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
