import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/config/constants/genres.dart';
import 'package:lifeline/core/containers/rounded_container.dart';
import 'package:lifeline/features/story/domain/entity/story_entity.dart';
import 'package:lifeline/features/story/presentation/controller/create_story_controller.dart';

class CreateManualStory extends GetView<CreateStoryController> {
  const CreateManualStory({super.key});

  @override
  Widget build(BuildContext context) {
    final story = Get.arguments as StoryEntity?;
    if (story != null && !controller.isEdit.value) {
      controller.loadEntryForEdit(story);
    }
    final theme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    double horizontalPadding = width * 0.04;
    double verticalPadding = height * 0.015;
    double moodSelectorHeight = height * 0.1;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary.withValues(alpha: .1),
        title: Text('Manual Story', style: theme.titleLarge),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: controller.pickStoryImage,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .7),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.image_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            // Scrollable content area
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      final image = controller.storyImage.value;

                      return image == null
                          ? SizedBox.shrink()
                          : GestureDetector(
                              onTap: controller.pickStoryImage,
                              child: TRoundedContainer(
                                radius: 0,
                                height: height * 0.22,
                                width: double.infinity,
                                backgroundColor: AppColors.primary.withValues(
                                  alpha: .1,
                                ),
                                child: Stack(
                                  children: [
                                    Image.file(
                                      image,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: GestureDetector(
                                        child: CircleAvatar(
                                          backgroundColor: Colors.black54,
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                    }),

                    SizedBox(
                      height: moodSelectorHeight,
                      child: Container(
                        color: AppColors.primary.withValues(alpha: .1),
                        height: 80,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: genres.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final genre = genres[index];
                            return GestureDetector(
                              onTap: () {
                                controller.selectGenre(genre);
                              },
                              child: Align(
                                alignment: Alignment.center,
                                child: Obx(() {
                                  final isSelected =
                                      genre == controller.selectedGenre.value;
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 150),
                                    height: 34,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primary
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        genre,
                                        style: theme.titleSmall!.copyWith(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: controller.titleController,
                            style: theme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText: "Story Title",
                              hintStyle: theme.titleMedium!.copyWith(
                                fontWeight: FontWeight.normal,
                                color: AppColors.hintText,
                              ),
                              border: InputBorder.none,
                              errorBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                            ),
                            maxLines: 1,
                          ),
                          Divider(
                            color: AppColors.border.withValues(alpha: .5),
                          ),

                          Obx(
                            () => Row(
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        for (
                                          int i = 0;
                                          i < controller.chapters.length;
                                          i++
                                        )
                                          Padding(
                                            padding: EdgeInsets.only(
                                              right:
                                                  i <
                                                      controller
                                                              .chapters
                                                              .length -
                                                          1
                                                  ? 12
                                                  : 0,
                                            ),
                                            child: GestureDetector(
                                              onTap: () =>
                                                  controller.selectChapter(i),
                                              child: TRoundedContainer(
                                                backgroundColor:
                                                    controller
                                                            .currentChapterIndex
                                                            .value ==
                                                        i
                                                    ? AppColors.primary
                                                    : AppColors.primary
                                                          .withValues(
                                                            alpha: .3,
                                                          ),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 8,
                                                ),
                                                radius: 12,
                                                child: Text(
                                                  'Chapter ${i + 1}',
                                                  style: theme.titleSmall!.copyWith(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color:
                                                        controller
                                                                .currentChapterIndex
                                                                .value ==
                                                            i
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                GestureDetector(
                                  onTap: () => controller.addChapter(),
                                  child: TRoundedContainer(
                                    backgroundColor: AppColors.primary
                                        .withValues(alpha: .2),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    radius: 12,
                                    child: Icon(
                                      Icons.add,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Divider(
                            color: AppColors.border.withValues(alpha: .5),
                          ),
                          Obx(() {
                            final currentChapter = controller.currentChapter;
                            if (currentChapter == null) {
                              return SizedBox.shrink();
                            }
                            return TextField(
                              controller: currentChapter.titleController,
                              style: theme.titleMedium!.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText: "Chapter Title",
                                hintStyle: theme.titleLarge!.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: AppColors.hintText,
                                ),
                                border: InputBorder.none,
                                errorBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                focusedErrorBorder: InputBorder.none,
                              ),
                              maxLines: 1,
                            );
                          }),
                          SizedBox(height: height * 0.01),

                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: height * 0.3,
                            ),
                            child: Obx(() {
                              final currentChapter = controller.currentChapter;
                              if (currentChapter == null) {
                                return SizedBox.shrink();
                              }
                              return TextField(
                                controller: currentChapter.contentController,
                                style: theme.titleLarge!.copyWith(
                                  fontSize: width * 0.04,
                                  color: Colors.grey.shade500,
                                ),
                                decoration: InputDecoration(
                                  hintText:
                                      "Start writing your story here... Let your imagination flow freely.",
                                  border: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                ),
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.newline,
                              );
                            }),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Text(
                      '${controller.wordCount.value} words',
                      style: theme.titleLarge,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 6),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                height: height * .058,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.wordCount.value == 0
                        ? null
                        : () => controller.isEdit.value
                              ? controller.editExistingStory(
                                  isPublished: story?.isPublished ?? false,
                                )
                              : controller.saveStory(isPublished: false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.primary.withValues(
                        alpha: .35,
                      ),
                      elevation: 0,
                      side: BorderSide.none,

                      shape: RoundedRectangleBorder(
                        side: BorderSide.none,
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: controller.uploading.value
                        ? CircularProgressIndicator(
                            color: AppColors.white,
                            strokeWidth: 2,
                          )
                        : Text(
                            controller.isEdit.value
                                ? 'Update Draft'
                                : 'Save Draft',
                            style: theme.titleLarge!.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
