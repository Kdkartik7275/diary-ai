import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindloom/core/di/init_dependencies.dart';
import 'package:mindloom/core/errors/failure.dart';
import 'package:mindloom/features/streak/domain/entity/streak_entity.dart';
import 'package:mindloom/features/streak/domain/usecases/get_streak.dart';
import 'package:mindloom/features/streak/domain/usecases/update_streak.dart';

class StreakController extends GetxController {
  StreakController({
    required this.getStreakUseCase,
    required this.updateStreakUseCase,
  });

  final GetStreak getStreakUseCase;
  final UpdateStreak updateStreakUseCase;

  final RxInt currentStreak = 0.obs;
  final RxInt longestStreak = 0.obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  // ignore: unused_field
  Streak? _streak;

  Future<void> loadStreak() async {
    isLoading.value = true;
    error.value = '';

    final result = await getStreakUseCase(sl<FirebaseAuth>().currentUser!.uid);

    result.fold(
      (Failure failure) {
        error.value = failure.message;
      },
      (Streak streak) {
        _streak = streak;
        currentStreak.value = streak.current;
        longestStreak.value = streak.longest;
      },
    );

    isLoading.value = false;
  }

  Future<void> updateStreak(String userId) async {
    final result = await updateStreakUseCase(
      UpdateStreakParams(userId: userId, entryDate: Timestamp.now()),
    );

    result.fold(
      (failure) {
        error.value = failure.message;
      },
      (_) async {
        await loadStreak();
      },
    );
  }

  int get streak => currentStreak.value;

  bool get hasError => error.value.isNotEmpty;
}
