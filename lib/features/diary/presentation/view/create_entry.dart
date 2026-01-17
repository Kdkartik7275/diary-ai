// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/core/containers/rounded_container.dart';
import 'package:lifeline/features/diary/domain/entity/diary_entity.dart';
import 'package:lifeline/features/diary/presentation/controller/create_diary_controller.dart';
import 'package:lifeline/features/diary/presentation/widgets/mood_selector.dart';

class CreateEntryView extends GetView<CreateDiaryController> {
  const CreateEntryView({super.key});

  @override
  Widget build(BuildContext context) {
    final diary = Get.arguments as DiaryEntity?;
    if (diary != null && !controller.isEdit.value) {
      controller.loadEntryForEdit(diary);
    }
    final theme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    double horizontalPadding = width * 0.04;
    double verticalPadding = height * 0.015;
    double iconButtonSize = width * 0.12;
    double saveButtonHeight = height * 0.065;
    double saveButtonHorizontalPadding = width * 0.06;
    double moodSelectorHeight = height * 0.1;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary.withValues(alpha: .1),
        title: Text(
          diary != null
              ? controller.formattedEffectiveDate(
                  diary.updatedAt,
                  diary.createdAt,
                )
              : DateFormat('MMMM d').format(DateTime.now()),
          style: theme.titleLarge,
        ),
      ),
      body: Obx(
        () => SafeArea(
          bottom: true,
          child: Column(
            children: [
              SizedBox(
                height: moodSelectorHeight,
                child: MoodSelector(
                  initialEmoji: controller.mood.value,
                  onSelected: (emoji) {
                    controller.mood.value = emoji;
                  },
                ),
              ),
              SizedBox(height: height * 0.02),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: controller.title.value,
                        style: theme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: "Give your day a title...",
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
                      SizedBox(height: height * 0.01),
                      Expanded(
                        child: TextField(
                          controller: controller.content.value,
                          style: theme.titleLarge!.copyWith(
                            fontSize: width * 0.04,
                            color: Colors.grey.shade500,
                          ),
                          decoration: InputDecoration(
                            hintText:
                                "What happened today? How do you feel? Write freely...",

                            border: InputBorder.none,
                            errorBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                          ),
                          maxLines: null,
                        ),
                      ),
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
                    Text(
                      '${controller.totalWordsCount.value} words',
                      style: theme.titleLarge,
                    ),
                    Row(
                      children: [
                        Container(
                          height: iconButtonSize,
                          width: iconButtonSize,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              iconButtonSize * 0.35,
                            ),
                            color: AppColors.primary.withValues(alpha: .1),
                          ),
                          child: Icon(
                            Icons.mic,
                            color: AppColors.primary,
                            size: iconButtonSize * 0.5,
                          ),
                        ),
                        SizedBox(width: width * 0.03),
                        Container(
                          height: saveButtonHeight,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary.withValues(alpha: 0.6),
                                AppColors.primary.withValues(alpha: 1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(
                              saveButtonHeight * 0.35,
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(
                                saveButtonHeight * 0.35,
                              ),
                              onTap: () => showTagSheet(context, controller),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: saveButtonHeight * 0.25,
                                  horizontal: saveButtonHorizontalPadding,
                                ),
                                child: Center(
                                  child: controller.creating.value
                                      ? SizedBox(
                                          height: height * .05,
                                          width: width * .07,
                                          child: CircularProgressIndicator(
                                            color: AppColors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : Text(
                                          'Save Entry',
                                          style: theme.titleLarge!.copyWith(
                                            fontWeight: FontWeight.normal,
                                            color: AppColors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showTagSheet(BuildContext context, CreateDiaryController controller) {
  final size = MediaQuery.of(context).size;
  final width = size.width;
  final height = size.height;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(width * 0.06),
          ),
        ),
        child: SafeArea(
          bottom: true,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: width * 0.05,
              right: width * 0.05,
              top: height * 0.02,
            ),
            child: Obx(() {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag indicator
                  Center(
                    child: Container(
                      width: width * 0.1,
                      height: height * 0.005,
                      margin: EdgeInsets.only(bottom: height * 0.025),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(height * 0.0025),
                      ),
                    ),
                  ),
                  Text(
                    "Add Tags",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: height * 0.02),

                  // Custom tag TextField
                  TRoundedContainer(
                    height: height * 0.06,
                    radius: width * 0.035,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .07),
                        blurRadius: width * 0.025,
                        offset: Offset(0, height * 0.005),
                      ),
                    ],
                    child: TextField(
                      controller: controller.customTagController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(
                            left: width * 0.03,
                            right: width * 0.025,
                          ),
                          child: Icon(
                            Icons.add_circle_outline,
                            color: AppColors.hintText,
                            size: width * 0.05,
                          ),
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                        ),
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(right: width * 0.015),
                          child: Container(
                            width: width * 0.09,
                            height: width * 0.09,
                            margin: EdgeInsets.symmetric(
                              vertical: height * 0.0075,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary.withValues(alpha: 0.85),
                                  AppColors.primary,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(
                                width * 0.025,
                              ),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(Icons.add, size: width * 0.05),
                              color: Colors.white,
                              onPressed: () => controller.addCustomTag(
                                controller.customTagController.text.trim(),
                              ),
                            ),
                          ),
                        ),
                        suffixIconConstraints: const BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                        ),
                        contentPadding: EdgeInsets.only(
                          top: height * 0.0175,
                          bottom: height * 0.0175,
                          right: width * 0.015,
                        ),
                        hintText: 'Create custom tag...',
                        hintStyle: TextStyle(
                          color: AppColors.hintText,
                          fontSize: width * 0.0375,
                        ),
                      ),
                    ),
                  ),

                  if (controller.customTags.isNotEmpty) ...[
                    SizedBox(height: height * 0.02),
                    Wrap(
                      spacing: width * 0.015,
                      runSpacing: height * 0.0075,
                      children: controller.customTags.map((tag) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          padding: EdgeInsets.only(
                            left: width * 0.03,
                            right: width * 0.015,
                            top: height * 0.0075,
                            bottom: height * 0.0075,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary.withValues(alpha: 0.85),
                                AppColors.primary,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(width * 0.04),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: width * 0.035,
                                color: Colors.white,
                              ),
                              SizedBox(width: width * 0.01),
                              Text(
                                tag,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: width * 0.0325,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              SizedBox(width: width * 0.01),
                              GestureDetector(
                                onTap: () => controller.toggleTag(tag),
                                child: Container(
                                  padding: EdgeInsets.all(width * 0.005),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: width * 0.035,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  SizedBox(height: height * 0.025),

                  if (controller.selectedTags.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(bottom: height * 0.015),
                      child: Text(
                        "${controller.selectedTags.length} tag${controller.selectedTags.length != 1 ? 's' : ''} selected",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: width * 0.0325,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: height * 0.3),
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: width * 0.015,
                        runSpacing: height * 0.0075,
                        children: controller.suggestedTags.map((tag) {
                          final isSelected = controller.selectedTags.contains(
                            tag,
                          );
                          return GestureDetector(
                            onTap: () => controller.toggleTag(tag),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.03,
                                vertical: height * 0.0075,
                              ),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? LinearGradient(
                                        colors: [
                                          AppColors.primary.withValues(
                                            alpha: 0.85,
                                          ),
                                          AppColors.primary,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : null,
                                color: isSelected ? null : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(
                                  width * 0.04,
                                ),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary.withValues(alpha: 0.3)
                                      : Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isSelected)
                                    Padding(
                                      padding: EdgeInsets.only(
                                        right: width * 0.01,
                                      ),
                                      child: Icon(
                                        Icons.check_circle,
                                        size: width * 0.035,
                                        color: Colors.white,
                                      ),
                                    ),
                                  Text(
                                    tag,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.grey.shade700,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                      fontSize: width * 0.0325,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.025),

                  Container(
                    width: double.infinity,
                    height: height * 0.0625,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.9),
                          AppColors.primary,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(width * 0.04),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: width * 0.03,
                          offset: Offset(0, height * 0.005),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(width * 0.04),
                        ),
                      ),
                      onPressed: () async {
                        Get.back();
                        if(controller.isEdit.value){
                          await controller.updateEntry();
                        }
                        else{await controller.createEntry();}
                        
                      },
                      child: Text(
                        controller.selectedTags.isEmpty
                            ? "Skip"
                            : "Add ${controller.selectedTags.length} Tag${controller.selectedTags.length != 1 ? 's' : ''}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.02),
                ],
              );
            }),
          ),
        ),
      );
    },
  );
}
