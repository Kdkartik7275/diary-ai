// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:lifeline/core/di/init_dependencies.dart';
import 'package:lifeline/core/snackbars/error_snackbar.dart';
import 'package:lifeline/core/snackbars/success_dialog.dart';
import 'package:lifeline/core/utils/helpers/functions.dart';
import 'package:lifeline/features/story/domain/entity/story_entity.dart';
import 'package:lifeline/features/story/domain/usecases/create_story.dart';
import 'package:lifeline/features/story/domain/usecases/edit_story.dart';
import 'package:lifeline/features/story/domain/usecases/upload_story_image.dart';
import 'package:lifeline/features/story/presentation/controller/story_controller.dart';

class Chapter {
  final String id;
  final TextEditingController titleController;
  final TextEditingController contentController;

  Chapter({required this.id, String? title, String? content})
    : titleController = TextEditingController(text: title),
      contentController = TextEditingController(text: content);

  void dispose() {
    titleController.dispose();
    contentController.dispose();
  }
}

class CreateStoryController extends GetxController {
  final CreateStory createStory;
  final EditStory editStory;
  final UploadStoryCoverImage uploadStoryCoverImageUsecase;

  CreateStoryController({
    required this.createStory,
    required this.editStory,
    required this.uploadStoryCoverImageUsecase,
  });

  final isEdit = false.obs;
  final uploading = false.obs;
  String? editingStoryId;

  final storyGenres = <String>[
    "Romance",
    "Adventure",
    "Fantasy",
    "Sci-Fi",
    "Mystery",
    "Thriller",
    "Horror",
    "Comedy",
    "Drama",
    "Slice of Life",
    "Inspirational",
    "Motivational",
    "Personal Growth",
    "Mindfulness",
    "Daily Life",
    "Crime",
    "Action",
    "Supernatural",
    "Historical",
  ];

  /// Selection
  final selectedGenre = RxnString();

  /// Controllers
  final titleController = TextEditingController();
  final storyController = Get.find<StoryController>();

  /// Chapters
  final chapters = <Chapter>[].obs;
  final currentChapterIndex = 0.obs;

  /// Word count
  final wordCount = 0.obs;

  final Rx<File?> storyImage = Rx<File?>(null);

  Future<void> pickStoryImage() async {
    final File? image = await pickImage();

    if (image != null) {
      storyImage.value = File(image.path);
    }
  }

  void removeStoryImage() {
    storyImage.value = null;
  }

  @override
  void onInit() {
    super.onInit();

    chapters.add(Chapter(id: DateTime.now().millisecondsSinceEpoch.toString()));

    currentChapterIndex.value = 0;
    _listenToCurrentChapter();
  }

  void loadEntryForEdit(StoryEntity story) {
    if (isEdit.value) return;

    isEdit.value = true;
    editingStoryId = story.id;

    titleController.clear();
    for (final chapter in chapters) {
      chapter.dispose();
    }
    chapters.clear();

    titleController.text = story.title;

    if (story.tags.isNotEmpty) {
      selectedGenre.value = story.tags.first;
    }

    for (final chapterEntity in story.chapters) {
      chapters.add(
        Chapter(
          id: chapterEntity.id,
          title: chapterEntity.title,
          content: chapterEntity.content,
        ),
      );
    }

    if (chapters.isEmpty) {
      chapters.add(
        Chapter(id: DateTime.now().millisecondsSinceEpoch.toString()),
      );
    }

    currentChapterIndex.value = 0;
    _listenToCurrentChapter();
  }

  void selectGenre(String genre) {
    selectedGenre.value = genre;
  }

  void addChapter() {
    chapters.add(Chapter(id: DateTime.now().millisecondsSinceEpoch.toString()));
    currentChapterIndex.value = chapters.length - 1;
    _listenToCurrentChapter();
  }

  void selectChapter(int index) {
    if (index >= 0 && index < chapters.length) {
      currentChapterIndex.value = index;
      _listenToCurrentChapter();
    }
  }

  Chapter? get currentChapter {
    if (chapters.isEmpty || currentChapterIndex.value >= chapters.length) {
      return null;
    }
    return chapters[currentChapterIndex.value];
  }

  void _listenToCurrentChapter() {
    final chapter = currentChapter;
    if (chapter == null) return;

    chapter.contentController.removeListener(_updateWordCount);
    chapter.contentController.addListener(_updateWordCount);
    _updateWordCount();
  }

  void _updateWordCount() {
    final chapter = currentChapter;
    if (chapter == null) {
      wordCount.value = 0;
      return;
    }

    final text = chapter.contentController.text.trim();
    wordCount.value = text.isEmpty ? 0 : text.split(RegExp(r'\s+')).length;
  }

  Future<void> saveStory({required bool isPublished}) async {
    try {
      if (!_validate()) return;
      uploading.value = true;
      final data = _buildPayload(
        userId: sl<FirebaseAuth>().currentUser!.uid,
        isPublished: isPublished,
      );

      final result = await createStory.call(data);

      result.fold((l) => showErrorDialog(l.message), (r) async {
        await storyController.getDrafts();
        await storyController.getUserPublishedStories();

        showSuccessDialog('Story updated successfully');
        Future.delayed(Duration(seconds: 1), () {
          Get.back();
        });
      });
    } catch (e) {
      showErrorDialog(e.toString());
    } finally {
      uploading.value = false;
    }
  }

  Future<void> editExistingStory({required bool isPublished}) async {
    try {
      if (!_validate()) return;

      uploading.value = true;
      if (editingStoryId == null) {
        showErrorDialog('Story ID not found');
        return;
      }
      String? coverImageUrl;

      if (storyImage.value != null) {
        final imageUrl = await uploadStoryCoverImageUsecase.call(
          storyImage.value!,
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

      final data = _buildPayload(
        userId: sl<FirebaseAuth>().currentUser!.uid,
        isPublished: isPublished,
        coverImageUrl: coverImageUrl,
      );

      debugPrint('Edit Story Payload: $data');

      final result = await editStory.call(data);

      result.fold((l) => showErrorDialog(l.message), (r) async {
        await storyController.getDrafts();
        await storyController.getUserPublishedStories();

        showSuccessDialog('Story updated successfully');
        Future.delayed(Duration(seconds: 1), () {
          Get.back();
        });
      });
    } catch (e) {
      showErrorDialog(e.toString());
    } finally {
      uploading.value = false;
    }
  }

  bool _validate() {
    if (titleController.text.trim().isEmpty) {
      showErrorDialog('Please enter a story title');
      return false;
    }

    if (chapters.isEmpty) {
      showErrorDialog('Please add at least one chapter');
      return false;
    }

    final hasContent = chapters.any(
      (c) => c.contentController.text.trim().isNotEmpty,
    );

    if (!hasContent) {
      showErrorDialog('Start writing your story first');
      return false;
    }

    return true;
  }

  Map<String, dynamic> _buildPayload({
    required String userId,
    required bool isPublished,
    String? coverImageUrl,
  }) {
    return {
      'userId': userId,
      if (isEdit.value) 'storyId': editingStoryId!,
      'title': titleController.text.trim(),
      'tags': selectedGenre.value != null ? [selectedGenre.value] : [],
      'chapters': chapters.map((chapter) {
        final content = chapter.contentController.text;
        return {
          'id': chapter.id,
          'title': chapter.titleController.text.trim(),
          'content': content,
          'wordCount': content.isEmpty
              ? 0
              : content.split(RegExp(r'\s+')).length,
        };
      }).toList(),
      if (isEdit.value) 'updatedAt': Timestamp.now(),
      if (!isEdit.value) 'createdAt': Timestamp.now(),
      'isPublished': isPublished,
      if (coverImageUrl != null) 'coverImageUrl': coverImageUrl,

      if (isPublished && !isEdit.value) 'publishedAt': Timestamp.now(),
      'generatedByAI': false,
    };
  }

  @override
  void onClose() {
    titleController.dispose();
    for (final chapter in chapters) {
      chapter.dispose();
    }
    super.onClose();
  }
}
