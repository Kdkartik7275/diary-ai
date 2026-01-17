import 'package:get/get.dart';
import 'package:lifeline/core/di/init_dependencies.dart';
import 'package:lifeline/features/profile/presentation/controller/edit_profile_controller.dart';
import 'package:lifeline/features/user/domain/usecases/edit_user.dart';

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditProfileController(editUser: sl<EditUser>()));
  }
}
