import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:lifeline/features/user/domain/entity/user_entity.dart';
import 'package:lifeline/features/user/domain/entity/user_stats.dart';
import 'package:lifeline/features/user/domain/usecases/get_user.dart';
import 'package:lifeline/features/user/domain/usecases/get_user_stats.dart';

class UserController extends GetxController {
  final GetUser getUserUseCase;
  final GetUserStats getUserStatsUseCase;

  UserController({
    required this.getUserUseCase,
    required this.getUserStatsUseCase,
  });

  Rx<UserEntity?> currentUser = Rx<UserEntity?>(null);
  Rx<UserStats?> userStats = Rx<UserStats?>(null);

  RxBool loading = false.obs;

  Future<void> loadUser(String uid) async {
    try {
      loading.value = true;

      final result = await getUserUseCase.call(uid);

      result.fold(
        (failure) {
          debugPrint("Error loading user: ${failure.message}");
        },
        (user) async {
          currentUser.value = user;
          final statsResult = await getUserStatsUseCase.call(user.id);
          statsResult.fold(
            (statsFailure) {
              debugPrint("Error loading user stats: ${statsFailure.message}");
            },
            (stats) {
              userStats.value = stats;
            },
          );
        },
      );
    } catch (e) {
      debugPrint("Exception loading user: $e");
    } finally {
      loading.value = false;
    }
  }

  void updateUser(UserEntity user) {
    currentUser.value = user;
    update();
  }
}
