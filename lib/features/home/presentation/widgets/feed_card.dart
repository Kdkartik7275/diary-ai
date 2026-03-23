import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/config/theme/theme_controller.dart';
import 'package:mindloom/core/utils/helpers/functions.dart';
import 'package:mindloom/features/explore/presentation/controller/explore_controller.dart';
import 'package:mindloom/features/explore/presentation/view/reading_view.dart';
import 'package:mindloom/features/explore/presentation/widgets/user_place_holder.dart';
import 'package:mindloom/features/home/presentation/widgets/trending_story_stats.dart';
import 'package:mindloom/features/story/domain/entity/story_entity.dart';
import 'package:mindloom/features/user/domain/entity/user_entity.dart';
import 'package:mindloom/features/user/presentation/controller/user_controller.dart';

class FeedCard extends GetView<ThemeController> {
  const FeedCard({super.key, required this.story});

  final StoryEntity story;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final theme = Theme.of(context).textTheme;
    final isDarkMode = controller.isDarkMode;
    return GestureDetector(
      onTap: () =>
          Get.to(() => StoryReadingView(story: story, authorId: story.userId)),
      child: Container(
        height: height * .2,
        width: width,
        margin: EdgeInsets.all(12),
        padding: EdgeInsets.symmetric(horizontal: 12),

        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.darkSurface : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .07),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: height * .16,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.white,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),

                child: story.coverImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: story.coverImageUrl!,

                        height: height * .16,

                        width: width,

                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/icons/logo_new.png',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    story.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  FutureBuilder<UserEntity>(
                    future: Get.find<UserController>().getUserById(
                      userId: story.userId,
                    ),

                    builder:
                        (context, AsyncSnapshot<UserEntity> asyncSnapshot) {
                          if (asyncSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return StoryUserLoading();
                          }

                          if (asyncSnapshot.hasError) {
                            return Container();
                          }

                          if (!asyncSnapshot.hasData) {
                            return Container();
                          }

                          final user = asyncSnapshot.data!;

                          return Row(
                            children: [
                              CircleAvatar(
                                radius: 14,

                                backgroundColor: AppColors.primary,

                                child: user.profileUrl != null
                                    ? ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: user.profileUrl!,

                                          width: 36,

                                          height: 36,

                                          fit: BoxFit.cover,

                                          errorWidget:
                                              (context, error, stackTrace) {
                                                return Center(
                                                  child: Text(
                                                    nameInitials(user.fullName),

                                                    style: theme.titleSmall!
                                                        .copyWith(
                                                          color: isDarkMode
                                                              ? AppColors.white
                                                              : AppColors.text,

                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                  ),
                                                );
                                              },
                                        ),
                                      )
                                    : Center(
                                        child: Text(
                                          nameInitials(user.fullName),

                                          style: theme.titleLarge!.copyWith(
                                            color: isDarkMode
                                                ? AppColors.white
                                                : AppColors.text,

                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                              ),

                              SizedBox(width: 6),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.fullName,

                                    style: theme.titleSmall!.copyWith(
                                      color: isDarkMode
                                          ? AppColors.white
                                          : AppColors.textLighter,

                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),

                    decoration: BoxDecoration(
                      color: AppColors.primary,

                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Text(
                      story.tags.first,

                      style: theme.titleSmall!.copyWith(
                        fontWeight: FontWeight.normal,

                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TrendingStoryStats(
                    exploreController: Get.find<ExploreController>(),
                    story: story,
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
