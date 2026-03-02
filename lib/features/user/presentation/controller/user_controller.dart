import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mindloom/features/story/domain/entity/story_entity.dart';
import 'package:mindloom/features/story/domain/usecases/get_published_stories_by_user.dart';
import 'package:mindloom/features/user/domain/entity/user_entity.dart';
import 'package:mindloom/features/user/domain/entity/user_stats.dart';
import 'package:mindloom/features/user/domain/usecases/get_user.dart';
import 'package:mindloom/features/user/domain/usecases/get_user_stats.dart';

class UserController extends GetxController {
  final GetUser getUserUseCase;
  final GetUserStats getUserStatsUseCase;
  final GetPublishedStoriesByUser getPublishedStoriesByUserUseCase;

  UserController({
    required this.getUserUseCase,
    required this.getPublishedStoriesByUserUseCase,
    required this.getUserStatsUseCase,
  });

  Rx<UserEntity?> currentUser = Rx<UserEntity?>(null);
  Rx<UserStats?> userStats = Rx<UserStats?>(null);

  final Map<String, UserEntity> usersCache = {};

  RxMap<String, List<StoryEntity>> userStories = RxMap({});

  RxBool loading = false.obs;
  RxBool userStoryLoading = false.obs;

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

  Future<UserEntity> getUserById({required String userId}) async {
    try {
      if (usersCache.containsKey(userId)) {
        return usersCache[userId]!;
      }
      final result = await getUserUseCase.call(userId);

      return result.fold((err) => throw err.message, (user) {
        return usersCache[user.id] = user;
      });
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserStats> getUserStats({required String userId}) async {
    try {
      userStoryLoading.value = true;
      final result = await getUserStatsUseCase.call(userId);
      return result.fold((err) => throw err.message, (stat) {
        return stat;
      });
    } catch (e) {
      throw e.toString();
    } finally {
      userStoryLoading.value = false;
    }
  }

  Future<void> getUserStories({required String userId}) async {
    try {
      if (userStories.containsKey(userId)) {
        userStories[userId]!;
        return;
      }
      final result = await getPublishedStoriesByUserUseCase.call(userId);

      result.fold((err) => throw err.message, (r) {
        userStories[userId] = r;
      });
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateFollowingCount(int delta) async {
    if (userStats.value == null) return;

    userStats.value = userStats.value!.copyWith(
      followingCount: userStats.value!.followingCount + delta,
    );
  }

  void updateUser(UserEntity user) {
    currentUser.value = user;
    update();
  }
}
