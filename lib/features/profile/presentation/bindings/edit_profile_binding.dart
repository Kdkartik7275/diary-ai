import 'package:get/get.dart';
import 'package:mindloom/core/di/init_dependencies.dart';
import 'package:mindloom/features/profile/presentation/controller/edit_profile_controller.dart';
import 'package:mindloom/features/user/domain/usecases/edit_user.dart';
import 'package:mindloom/features/user/domain/usecases/upload_user_profile.dart';

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => EditProfileController(
        editUser: sl<EditUser>(),
        uploadUserProfile: sl<UploadUserProfile>(),
      ),
    );
  }
}
