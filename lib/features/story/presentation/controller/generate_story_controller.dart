import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mindloom/config/constants/colors.dart';
import 'package:mindloom/config/routes/app_routes.dart';
import 'package:mindloom/core/di/init_dependencies.dart';
import 'package:mindloom/core/snackbars/error_snackbar.dart';
import 'package:mindloom/core/snackbars/success_dialog.dart';
import 'package:mindloom/core/utils/helpers/functions.dart';
import 'package:mindloom/features/diary/domain/usecases/get_diaries_by_range.dart';
import 'package:mindloom/features/story/data/model/story_model.dart';
import 'package:mindloom/features/story/domain/entity/story_entity.dart';
import 'package:mindloom/features/story/domain/usecases/create_story.dart';
import 'package:mindloom/features/story/domain/usecases/generate_story_from_diaries.dart';
import 'package:mindloom/features/story/domain/usecases/upload_story_image.dart';
import 'package:mindloom/features/story/presentation/views/draft_preview.dart';
import 'package:mindloom/features/story/presentation/widgets/generating_story.dart';
import 'package:uuid/uuid.dart';

class GenerateStoryController extends GetxController {
  GenerateStoryController({
    required this.generateStoryFromDiariesUseCase,
    required this.getDiariesByRangeUseCase,
    required this.createStoryUseCase,
    required this.uploadStoryCoverImageUsecase,
  });
  final GenerateStoryFromDiaries generateStoryFromDiariesUseCase;
  final GetDiariesByRange getDiariesByRangeUseCase;
  final CreateStory createStoryUseCase;
  final UploadStoryCoverImage uploadStoryCoverImageUsecase;

  final mainCharacter = ''.obs;
  final selectedTone = ''.obs;
  final selectedGenre = ''.obs;
  RxString summary = ''.obs;
  final storyCover = Rx<File?>(null);

  Rxn<DateTime> startDate = Rxn<DateTime>();
  Rxn<DateTime> endDate = Rxn<DateTime>();
  void setCharacter(String value) {
    mainCharacter.value = value;
  }

  void setTone(String tone) {
    selectedTone.value = tone;
  }

  void setGenre(String genre) {
    selectedGenre.value = genre;
  }

  void setSummary(String value) => summary.value = value;

  Future<void> pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),

      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogTheme: DialogThemeData(backgroundColor: AppColors.white),
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),

            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (isStart) {
        startDate.value = picked;
      } else {
        endDate.value = picked;
      }
    }
  }

  void pickStoryCover() async {
    final image = await pickImage();
    if (image != null) {
      storyCover.value = image;
    }
  }

  void goToSummaryPage() {
    if (startDate.value == null ||
        endDate.value == null ||
        mainCharacter.value.isEmpty ||
        selectedTone.value.isEmpty) {
      showErrorDialog('Please fill all fields');
      return;
    }

    Get.toNamed(Routes.storySummary);
  }

  Future<void> navigateToAnimation() async {
    final result = await Get.to(
      () => GeneratingStoryView(
        startDate: startDate.value!,
        endDate: endDate.value!,
        genre: selectedGenre.value,
        tone: selectedTone.value,
        characterName: mainCharacter.value,
      ),
    );

    if (result != null) {
      showSuccessDialog(
        'Your diary has been transformed into a captivating story.',
      );
      Get.to(() => DraftPreview(story: result as StoryEntity));
    }
  }

  Future<void> generateStory({
    required DateTime startDate,
    required DateTime endDate,
    required String genre,
    required String tone,
    required String characterName,
  }) async {
    final stopwatch = Stopwatch()..start();

    debugPrint('========== STORY GENERATION STARTED ==========');
    debugPrint('Start Date: $startDate');
    debugPrint('End Date: $endDate');
    debugPrint('Genre: $genre');
    debugPrint('Tone: $tone');
    debugPrint('Character Name: $characterName');

    try {
      final userId = sl<FirebaseAuth>().currentUser!.uid;
      debugPrint('User ID: $userId');

      debugPrint('Fetching diaries...');
      final diariesResult = await getDiariesByRangeUseCase.call(
        GetDiariesByRangeParams(
          userId: userId,
          startDate: startDate,
          endDate: endDate,
        ),
      );

      debugPrint('Diaries fetch completed');

      List<Map<String, dynamic>> diaries = diariesResult.fold(
        (l) {
          debugPrint('❌ Error fetching diaries: $l');
          return [];
        },
        (r) {
          debugPrint('✅ Diaries fetched: ${r.length}');

          if (r.isNotEmpty) {
            debugPrint('Sample diary:');
            debugPrint('Date: ${r.first.createdAt}');
            debugPrint('Mood: ${r.first.mood}');
            debugPrint('Content length: ${r.first.content.length}');
          }

          return r
              .map(
                (diary) => {
                  'date': diary.createdAt.toDate().toString(),
                  'mood': diary.mood,
                  'content': diary.content,
                },
              )
              .toList();
        },
      );

      debugPrint('Prepared diaries list: ${diaries.length}');

      debugPrint('Calling story generation API...');
      final result = await generateStoryFromDiariesUseCase.call({
        'diaries': diaries,
        'genre': genre,
        'tone': tone,
        'characterName': characterName,
        'summary': summary.value,
      });

      debugPrint('Story generation response received');

      result.fold(
        (l) {
          debugPrint('❌ Story generation failed: $l');
          debugPrint('========== STORY GENERATION FAILED ==========');
          stopwatch.stop();
          debugPrint('Total time: ${stopwatch.elapsed.inSeconds}s');
          Get.back(result: null);
        },
        (r) async {
          debugPrint('✅ Story generated successfully');
          debugPrint('Story length: ${r.toString().length}');
          debugPrint('========== STORY GENERATION COMPLETED ==========');
          stopwatch.stop();
          debugPrint('Total time: ${stopwatch.elapsed.inSeconds}s');

          final chapters = (r['chapters'] as List)
              .map(
                (e) => StoryChapterModel(
                  content: e['content'],
                  title: e['title'],
                  id: Uuid().v4(),
                  createdAt: Timestamp.now(),
                ),
              )
              .toList();
          String? coverImageUrl;

          if (storyCover.value != null) {
            final imageUrl = await uploadStoryCoverImageUsecase.call(
              storyCover.value!,
            );
            imageUrl.fold(
              (l) {
                showErrorDialog(l.message);
                return null;
              },
              (r) {
                coverImageUrl = r;
              },
            );
          }

          final storyResult = await createStoryUseCase.call({
            'userId': userId,
            'title': r['title'],
            'tags': selectedGenre.value.isNotEmpty ? [selectedGenre.value] : [],
            'chapters': chapters.map((chapter) {
              final content = chapter.content;
              return {
                'id': chapter.id,
                'title': chapter.title.trim(),
                'content': content,
                'wordCount': content.isEmpty
                    ? 0
                    : content.split(RegExp(r'\s+')).length,
              };
            }).toList(),
            'createdAt': Timestamp.now(),
            'isPublished': false,
            'generatedByAI': true,
            if (coverImageUrl != null) 'coverImageUrl': coverImageUrl,
          });

          storyResult.fold(
            (err) => Get.back(result: null),
            (story) => Get.back(result: story),
          );
        },
      );
    } catch (e, stack) {
      debugPrint('🔥 Unexpected Error: $e');
      debugPrint('Stacktrace: $stack');
      debugPrint('========== STORY GENERATION CRASHED ==========');
      stopwatch.stop();
      debugPrint('Total time: ${stopwatch.elapsed.inSeconds}s');
      Get.back(result: null);
    }
  }
}
