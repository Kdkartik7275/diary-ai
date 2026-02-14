// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/core/containers/rounded_container.dart';
import 'package:lifeline/core/empty/empty_diary.dart';
import 'package:lifeline/features/diary/presentation/controller/diary_controller.dart';
import 'package:lifeline/features/diary/presentation/widgets/diary_card.dart';

class DiariesView extends GetView<DiaryController> {
  const DiariesView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      body: Obx(
        () => controller.diariesLoading.value
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 2,
                ),
              )
            : SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.02),
                      Text(
                        'Your Diary',
                        style: theme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Text(
                        'All your memories in one place.',
                        style: theme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.textLighter,
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      Row(
                        children: [
                          Expanded(
                            child: TRoundedContainer(
                              height: height * 0.05,

                              radius: 14,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: .07),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],

                              child: TextField(
                                onChanged: (query) {
                                  if (query.isEmpty) {
                                    controller.searching.value = false;
                                  } else {
                                    controller.searchDiaries(query);
                                  }
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,

                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 12,
                                      right: 10,
                                    ),
                                    child: Icon(
                                      CupertinoIcons.search,
                                      color: AppColors.hintText,
                                      size: 20,
                                    ),
                                  ),

                                  prefixIconConstraints: const BoxConstraints(
                                    minWidth: 0,
                                    minHeight: 0,
                                  ),

                                  contentPadding: const EdgeInsets.only(
                                    top: 5,
                                    bottom: 10,
                                    right: 16,
                                  ),

                                  hintText: 'Search your entries...',
                                  hintStyle: theme.bodyLarge!.copyWith(
                                    color: AppColors.hintText,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),

                          TRoundedContainer(
                            height: height * 0.05,
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            radius: 14,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: .07),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            child: Icon(
                              Icons.filter_alt_outlined,
                              color: AppColors.hintText,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.02),

                      Expanded(
                        child:
                            (controller.diaries.isEmpty &&
                                !controller.diariesLoading.value &&
                                !controller.searching.value)
                            ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const EmptyDiaryState(),
                              ],
                            )
                            : RefreshIndicator(
                                backgroundColor: AppColors.white,
                                color: AppColors.primary,
                                onRefresh: () async {
                                  await controller.getDiaries();
                                },
                                child: ListView.separated(
                                  itemCount: controller.searching.value
                                      ? controller.searchedDiaries.length
                                      : controller.diaries.length,
                                  itemBuilder: (context, index) {
                                    final diary = controller.searching.value
                                        ? controller.searchedDiaries[index]
                                        : controller.diaries[index];
                                    return DiaryCard(
                                      width: width,
                                      theme: theme,
                                      height: height,
                                      diary: diary,
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                        return SizedBox(height: height * .02);
                                      },
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
