import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:lifeline/core/di/init_dependencies.dart';
import 'package:lifeline/core/snackbars/error_snackbar.dart';
import 'package:lifeline/features/social/domain/entity/follow_entity.dart';
import 'package:lifeline/features/social/domain/usecases/follow_user.dart';
import 'package:lifeline/features/social/domain/usecases/get_follow_status.dart';
import 'package:lifeline/features/social/domain/usecases/get_followers.dart';
import 'package:lifeline/features/social/domain/usecases/get_followings.dart';

class FollowController extends GetxController {
  final FollowUser followUserUseCase;
  final GetFollowStatus getFollowStatusUseCase;
  final GetFollowers getFollowersUseCase;
  final GetFollowings getFollowingsUseCase;

  FollowController({
    required this.followUserUseCase,
    required this.getFollowStatusUseCase,
    required this.getFollowersUseCase,
    required this.getFollowingsUseCase,
  });

  RxBool isFollowing = false.obs;
  RxBool isFollowedBy = false.obs;
  RxBool isLoading = false.obs;

  final RxList<FollowEntity> followers = <FollowEntity>[].obs;
  final RxList<FollowEntity> following = <FollowEntity>[].obs;

  final RxSet<String> followingIds = <String>{}.obs;

  Future<void> fetchFollowers() async {
    isLoading.value = true;
    final result = await getFollowersUseCase.call(
      sl<FirebaseAuth>().currentUser!.uid,
    );
    result.fold((err) => showErrorDialog(err.message), (r) {
      followers.value = r;
    });
    isLoading.value = false;
  }

  Future<void> fetchFollowing() async {
    final result = await getFollowingsUseCase.call(
      sl<FirebaseAuth>().currentUser!.uid,
    );
    result.fold((err) => showErrorDialog(err.message), (r) {
      following.value = r;
    });
    isLoading.value = false;
  }

  Future<void> toggleFollow(FollowEntity user) async {
    if (followingIds.contains(user.id)) {
      followingIds.remove(user.id);
      following.removeWhere((u) => u.id == user.id);
    } else {
      followingIds.add(user.id);
      following.add(user);
    }
    // TODO: Call your repository to persist the change
  }

  bool isFollowingUser(String userId) => followingIds.contains(userId);

  Future<void> followUser({
    required String currentUserId,
    required String currentUserFullName,
    required String currentUserAvatar,
    required String targetUserId,
    required String targetUserFullName,
    required String targetUserAvatar,
    required String currentUserName,
    required String targetUserName,
  }) async {
    isLoading.value = true;
    isFollowing.value = true;
    final params = FollowUserParams(
      currentUserId: currentUserId,
      currentUserName: currentUserName,
      currentUserAvatar: currentUserAvatar,
      targetUserId: targetUserId,
      targetUserName: targetUserName,
      targetUserAvatar: targetUserAvatar,
      currentUserFullName: currentUserFullName,
      targetUserFullName: targetUserFullName,
    );

    final result = await followUserUseCase.call(params);

    result.fold(
      (failure) {
        isLoading.value = false;
        isFollowing.value = false;
      },
      (_) {
        isLoading.value = false;
      },
    );
  }

  Future<void> checkFollowStatus({
    required String currentUserId,
    required String targetUserId,
  }) async {
    final params = {
      'currentUserId': currentUserId,
      'targetUserId': targetUserId,
    };
    isLoading.value = true;
    final result = await getFollowStatusUseCase.call(params);

    result.fold(
      (failure) {
        isFollowing.value = false;
        isFollowedBy.value = false;
      },
      (followStatus) {
        isFollowing.value = followStatus.isFollowing;
        isFollowedBy.value = followStatus.isFollowedBy;
      },
    );
    isLoading.value = false;
  }
}
