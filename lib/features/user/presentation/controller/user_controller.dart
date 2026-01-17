import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:lifeline/features/user/domain/entity/user_entity.dart';
import 'package:lifeline/features/user/domain/usecases/get_user.dart';

class UserController extends GetxController {
  final GetUser getUserUseCase;

  UserController({required this.getUserUseCase});

  Rx<UserEntity?> currentUser = Rx<UserEntity?>(null);

  RxBool loading = false.obs;

  Future<void> loadUser(String uid) async {
    try {
      loading.value = true;

      final result = await getUserUseCase.call(uid);

      result.fold(
        (failure) {
          debugPrint("Error loading user: ${failure.message}");
        },
        (user) {
          currentUser.value = user;
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
