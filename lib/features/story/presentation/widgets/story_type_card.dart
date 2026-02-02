// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/core/containers/rounded_container.dart';
import 'package:lifeline/features/story/presentation/views/story_type_view.dart';

class StoryTypeCard extends StatelessWidget {
  final String title;
  final String description;
  final Color borderColor;
  final Color gradientColor;
  final List<StoryTag> tags;
  final void Function()? onTap;

  const StoryTypeCard({
    super.key,
    required this.title,
    required this.description,
    required this.borderColor,
    required this.gradientColor,
    required this.tags,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: TRoundedContainer(
        showBorder: true,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        borderColor: borderColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: size.height * .08,
              width: size.width * .16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  colors: [
                    gradientColor.withValues(alpha: .5),
                    gradientColor.withValues(alpha: .8),
                  ],
                ),
              ),
              child: const Icon(
                CupertinoIcons.wand_rays,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    description,
                    style: theme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textLighter,
                    ),
                  ),
                  SizedBox(height: size.height * .01),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: tags
                        .map(
                          (tag) => TRoundedContainer(
                            radius: 16,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            backgroundColor: tag.color.withValues(alpha: .2),
                            child: Text(
                              tag.label,
                              style: theme.titleSmall!.copyWith(
                                fontSize: 13,
                                color: tag.color,
                              ),
                            ),
                          ),
                        )
                        .toList(),
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
