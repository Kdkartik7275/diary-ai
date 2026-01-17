// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:lifeline/core/di/init_dependencies.dart';
import 'package:lifeline/core/snackbars/error_snackbar.dart';
import 'package:lifeline/core/snackbars/success_dialog.dart';
import 'package:lifeline/features/diary/domain/entity/diary_entity.dart';
import 'package:lifeline/features/diary/domain/usecases/create_diary.dart';
import 'package:lifeline/features/diary/domain/usecases/update_diary.dart';
import 'package:lifeline/features/diary/presentation/controller/diary_controller.dart';

class CreateDiaryController extends GetxController {
  final CreateDiary createDiary;
  final UpdateDiary updateDiary;

  CreateDiaryController({required this.createDiary, required this.updateDiary});

  RxBool creating = false.obs;
  RxString mood = ''.obs;
  RxBool isEdit = false.obs;
  String? editingId;

  var title = TextEditingController().obs;
  var content = TextEditingController().obs;

  RxInt totalWordsCount = 0.obs;

  RxList<String> selectedTags = <String>[].obs;
  RxList<String> customTags = <String>[].obs;
  TextEditingController customTagController = TextEditingController();

  final diaryController = Get.find<DiaryController>();

  void loadEntryForEdit(DiaryEntity entry) {
    isEdit.value = true;
    editingId = entry.id;
    title.value.text = entry.title;
    content.value.text = entry.content;
    mood.value = entry.mood;
    totalWordsCount.value = entry.totalWordsCount;
    selectedTags.value = [...entry.tags];
    customTags.value = entry.tags
        .where((t) => !suggestedTags.contains(t))
        .toList();
  }

  final List<String> suggestedTags = [
    "Work",
    "Mood",
    "Health",
    "Focus",
    "Gratitude",
    "Personal",
    "Family",
    "Friends",
    "Fitness",
    "Stress",
    "Sleep",
    "Habits",
    "Goals",
    "Learning",
    "Nature",
    "Travel",
    "Productivity",
    "Mindfulness",
    "Finance",
    "Creativity",
    "Memories",
    "Hobby",
    "Relationships",
    "Food",
    "Relaxation",
    "Growth",
  ];

  void addCustomTag(String tag) {
    if (tag.isNotEmpty && !selectedTags.contains(tag)) {
      customTags.add(tag);
      selectedTags.add(tag);
      customTagController.clear();
    }
  }

  void toggleTag(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
      if (customTags.contains(tag)) customTags.remove(tag);
    } else {
      selectedTags.add(tag);
      if (!suggestedTags.contains(tag)) customTags.add(tag);
    }
  }

  @override
  void onInit() {
    super.onInit();
    content.value.addListener(() {
      totalWordsCount.value = _countWords(content.value.text);
    });
  }

  int _countWords(String text) {
    if (text.trim().isEmpty) return 0;
    return text
        .trim()
        .split(RegExp(r"\s+"))
        .where((word) => word.isNotEmpty)
        .length;
  }

  bool validateEntry() {
    return mood.value.isNotEmpty &&
        totalWordsCount.value > 100 &&
        title.value.text.isNotEmpty &&
        !creating.value;
  }

  int calculateReadingTimeInSeconds(int words) {
    if (words == 0) return 0;
    double seconds = words / 2.5;
    return seconds.round();
  }

  Future<void> createEntry() async {
    try {
      if (!validateEntry()) {
        showErrorDialog('All Fields are required');
        return;
      }
      creating.value = true;
      int readingTime = calculateReadingTimeInSeconds(totalWordsCount.value);
      Map<String, dynamic> diary = {
        'userId': sl<FirebaseAuth>().currentUser!.uid,
        'title': title.value.text.trim(),
        'content': content.value.text,
        'mood': mood.value,
        'totalWordsCount': totalWordsCount.value,
        'readingTime': readingTime,
        'tags': selectedTags,
      };
      final result = await createDiary.call(diary);
      result.fold((error) => showErrorDialog(error.message), (entry) {
        showSuccessDialog(
          'Your entry has been saved. Thanks for taking a moment for yourself today.',
        );
        isEdit.value = true;
        editingId = entry.id;
        diaryController.updateDiary(entry);
      });
    } catch (e) {
      showErrorDialog(e.toString());
    } finally {
      creating.value = false;
    }
  }

  Future<void> updateEntry() async {
    try {
      if (!validateEntry()) {
        showErrorDialog('All Fields are required');
        return;
      }
      creating.value = true;
      int readingTime = calculateReadingTimeInSeconds(totalWordsCount.value);
      Map<String, dynamic> diary = {
        'title': title.value.text.trim(),
        'content': content.value.text,
        'mood': mood.value,
        'totalWordsCount': totalWordsCount.value,
        'readingTime': readingTime,
        'tags': selectedTags,
        'updatedAt': Timestamp.now(),
      };
      final result = await updateDiary.call(
        UpdateDiaryParams(diaryId: editingId!, data: diary),
      );
      result.fold((error) => showErrorDialog(error.message), (entry) {
        showSuccessDialog(
          'Your entry has been saved. Thanks for taking a moment for yourself today.',
        );
        isEdit.value = true;
        editingId = entry.id;
        diaryController.updateDiary(entry);
      });
    } catch (e) {
      showErrorDialog(e.toString());
    } finally {
      creating.value = false;
    }
  }

  String formattedEffectiveDate(Timestamp? updatedAt, Timestamp createdAt) {
    final effective = updatedAt?.toDate() ?? createdAt.toDate();
    return DateFormat('MMMM d, yyyy').format(effective);
  }
}
