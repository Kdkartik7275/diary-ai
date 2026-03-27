import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mindloom/core/di/init_dependencies.dart';
import 'package:mindloom/core/snackbars/error_snackbar.dart';
import 'package:mindloom/features/notifications/domain/entity/app_notification.dart';
import 'package:mindloom/features/notifications/domain/usecases/create_notification.dart';
import 'package:mindloom/features/social/domain/entity/follow_entity.dart';
import 'package:mindloom/features/social/domain/usecases/follow_user.dart';
import 'package:mindloom/features/social/domain/usecases/get_follow_status.dart';
import 'package:mindloom/features/social/domain/usecases/get_followers.dart';
import 'package:mindloom/features/social/domain/usecases/get_followings.dart';
import 'package:mindloom/features/social/domain/usecases/unfollow_user.dart';
import 'package:mindloom/features/user/presentation/controller/user_controller.dart';

class FollowController extends GetxController {
  FollowController({
    required this.followUserUseCase,
    required this.getFollowStatusUseCase,
    required this.getFollowersUseCase,
    required this.getFollowingsUseCase,
    required this.createNotificationUseCase,
    required this.unFollowUserUseCase,
  });
  final FollowUser followUserUseCase;
  final UnFollowUser unFollowUserUseCase;
  final GetFollowStatus getFollowStatusUseCase;
  final GetFollowers getFollowersUseCase;
  final GetFollowings getFollowingsUseCase;
  final CreateNotification createNotificationUseCase;

  RxBool isFollowing = false.obs;
  RxBool isFollowedBy = false.obs;
  RxBool isLoading = false.obs;

  final RxList<FollowEntity> followers = <FollowEntity>[].obs;
  final RxList<FollowEntity> following = <FollowEntity>[].obs;

  final RxSet<String> followingIds = <String>{}.obs;

  final userController = Get.find<UserController>();

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

  bool isFollowingUser(String userId) => followingIds.contains(userId);

  Future<void> followUser({
    required String currentUserId,
    required String targetUserId,
    required String currentUserFullName,
  }) async {
    isFollowing.value = true;
    final params = FollowUserParams(
      currentUserId: currentUserId,
      targetUserId: targetUserId,
    );

    final result = await followUserUseCase.call(params);

    result.fold(
      (failure) {
        isLoading.value = false;
        isFollowing.value = false;
      },
      (_) {
        userController.updateFollowingCount(1);
        isLoading.value = false;
        sendFollowNotification(
          to: targetUserId,
          username: currentUserFullName,
          referenceId: currentUserId,
        );
      },
    );
  }

  Future<void> unfollowUser({
    required String currentUserId,
    required String targetUserId,
    required String currentUserFullName,
  }) async {
    isFollowing.value = false;
    final params = UnfollowUserParams(
      currentUserId: currentUserId,
      targetUserId: targetUserId,
    );

    final result = await unFollowUserUseCase.call(params);

    result.fold(
      (failure) {
        isLoading.value = false;
        isFollowing.value = false;
      },
      (_) {
        userController.updateFollowingCount(-1);
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

  Future<void> sendFollowNotification({
    required String to,
    required String username,
    String? referenceId,
  }) async {
    try {
      final Map<String, dynamic> notifData = {
        'userId': to,
        'type': NotificationType.newFollower,
        'priority': NotificationPriority.normal,
        'actionType': NotificationActionType.openProfile,
        'title': '$username started following you',
        'body': 'See their profile and discover their stories.',
        if (referenceId != null) 'referenceId': referenceId,
        'metaData': <String, dynamic>{},
      };
      final result = await createNotificationUseCase.call(notifData);
      result.fold((err) => showErrorDialog(err.message), (success) {});
    } catch (e) {
      throw e.toString();
    }
  }
}
