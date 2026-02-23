import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lifeline/core/di/init_dependencies.dart';
import 'package:lifeline/core/snackbars/error_snackbar.dart';
import 'package:lifeline/core/snackbars/success_dialog.dart';
import 'package:lifeline/features/diary/domain/entity/diary_entity.dart';
import 'package:lifeline/features/diary/domain/usecases/delete_diary.dart';
import 'package:lifeline/features/diary/domain/usecases/get_user_diaries.dart';

class DiaryController extends GetxController {
  final GetUserDiaries getUserDiaries;
  final DeleteDiary deleteDiaryUseCase;

  DiaryController({
    required this.getUserDiaries,
    required this.deleteDiaryUseCase,
  });

  RxList<DiaryEntity> diaries = RxList([]);
  RxList<DiaryEntity> searchedDiaries = RxList([]);

  RxBool diariesLoading = RxBool(false);
  RxBool searching = RxBool(false);
  @override
  void onInit() {
    super.onInit();
    getDiaries();
  }

  Future<void> getDiaries() async {
    try {
      diariesLoading.value = true;
      final userId = sl<FirebaseAuth>().currentUser!.uid;
      final result = await getUserDiaries.call(userId);
      result.fold((error) => showErrorDialog(error.message), (data) {
        diaries.value = data;
      });
    } catch (e) {
      showErrorDialog(e.toString());
    } finally {
      diariesLoading.value = false;
    }
  }

  List<DiaryEntity> get recentDiaries {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    return diaries.where((entry) {
      final created = entry.createdAt.toDate();
      final updated = entry.updatedAt?.toDate();

      final effectiveDate = updated ?? created;

      return effectiveDate.isAfter(sevenDaysAgo);
    }).toList();
  }

  void updateDiary(DiaryEntity diary) {
    final index = diaries.indexWhere((d) => d.id == diary.id);

    if (index != -1) {
      diaries[index] = diary;
    } else {
      diaries.add(diary);
    }
  }

  void searchDiaries(String query) {
    searching.value = true;

    final q = query.trim().toLowerCase();

    searchedDiaries.value = diaries.where((d) {
      return d.title.toLowerCase().contains(q) ||
          d.content.toLowerCase().contains(q);
    }).toList();
  }

  Future<void> deleteDiary({required String diaryId}) async {
    try {
      final result = await deleteDiaryUseCase.call(diaryId);

      result.fold((err) => showErrorDialog(err.message), (r) {
        diaries.removeWhere((diary)=> diary.id == diaryId);
        showSuccessDialog("Diary moved to Trash.");
        update();
      });
    } catch (e) {
      showErrorDialog(e.toString());
    }
  }

  int calculateTotalWordsCount() {
    return diaries.fold(
      0,
      (previousValue, element) => previousValue + element.totalWordsCount,
    );
  }

  String formattedEffectiveDate(Timestamp? updatedAt, Timestamp createdAt) {
    final effective = updatedAt?.toDate() ?? createdAt.toDate();
    return DateFormat('MMM d').format(effective);
  }
}
