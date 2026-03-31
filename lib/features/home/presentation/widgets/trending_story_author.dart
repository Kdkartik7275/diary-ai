import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/config/theme/theme_controller.dart';
import 'package:mindloom/core/utils/helpers/functions.dart';
import 'package:mindloom/features/explore/presentation/widgets/user_place_holder.dart';
import 'package:mindloom/features/story/domain/entity/story_entity.dart';
import 'package:mindloom/features/user/domain/entity/user_entity.dart';
import 'package:mindloom/features/user/presentation/controller/user_controller.dart';

class TrendingStoryAuthorDetails extends GetView<ThemeController> {
  const TrendingStoryAuthorDetails({
    super.key,
    required this.story,
    required this.theme,
  });

  final StoryEntity story;
  final TextTheme theme;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = controller.isDarkMode;
    return FutureBuilder<UserEntity>(
      future: Get.find<UserController>().getUserById(userId: story.userId),

      builder: (context, AsyncSnapshot<UserEntity> asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return StoryUserLoading();
        }

        if (asyncSnapshot.hasError) {
          return Container();
        }

        if (!asyncSnapshot.hasData) {
          return Container();
        }

        final user = asyncSnapshot.data!;
        final isDeleted = user.isDeleted ?? false;

        if (isDeleted) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey.shade300,
                  child: const Icon(
                    Icons.person_off,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Deleted User',
                  style: theme.titleSmall!.copyWith(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),

          child: Row(
            children: [
              CircleAvatar(
                radius: 18,

                backgroundColor: AppColors.primary,

                child: user.profileUrl != null
                    ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: user.profileUrl!,

                          width: 36,

                          height: 36,

                          fit: BoxFit.cover,

                          errorWidget: (context, url, error) => Center(
                            child: Text(
                              nameInitials(user.fullName),

                              style: theme.titleSmall!.copyWith(
                                color: isDarkMode
                                    ? AppColors.white
                                    : AppColors.text,

                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
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

                    style: theme.titleLarge!.copyWith(
                      color: isDarkMode
                          ? AppColors.white.withValues(alpha: .8)
                          : AppColors.textLighter,

                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  if (user.username != null && user.username!.isNotEmpty)
                    Text(
                      '@${user.username}',

                      style: theme.titleSmall!.copyWith(
                        color: isDarkMode
                            ? AppColors.white.withValues(alpha: .8)
                            : AppColors.textLighter,
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
