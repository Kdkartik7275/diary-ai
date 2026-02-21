import 'package:get/get.dart';
import 'package:lifeline/features/social/domain/entity/follow_entity.dart';
import 'package:lifeline/features/social/domain/usecases/follow_user.dart';
import 'package:lifeline/features/social/domain/usecases/get_follow_status.dart';

class FollowController extends GetxController {
  final FollowUser followUserUseCase;
  final GetFollowStatus getFollowStatusUseCase;

  FollowController({
    required this.followUserUseCase,
    required this.getFollowStatusUseCase,
  });

  RxBool isFollowing = false.obs;
  RxBool isFollowedBy = false.obs;
  RxBool isLoading = false.obs;

  final RxList<FollowEntity> followers = <FollowEntity>[].obs;
  final RxList<FollowEntity> following = <FollowEntity>[].obs;

  final RxSet<String> followingIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFollowers();
    fetchFollowing();
  }

  Future<void> fetchFollowers() async {
    isLoading.value = true;
    // TODO: Replace with your actual repository call
    // e.g. final result = await _followRepository.getFollowers(userId);
    await Future.delayed(const Duration(milliseconds: 600)); // simulate network
    isLoading.value = false;
  }

  Future<void> fetchFollowing() async {
    // TODO: Replace with your actual repository call
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
    required String currentUserName,
    required String currentUserAvatar,
    required String targetUserId,
    required String targetUserName,
    required String targetUserAvatar,
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
