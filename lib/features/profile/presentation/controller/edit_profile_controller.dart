import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifeline/core/snackbars/error_snackbar.dart';
import 'package:lifeline/core/snackbars/success_dialog.dart';
import 'package:lifeline/core/utils/helpers/functions.dart';
import 'package:lifeline/features/user/domain/entity/user_entity.dart';
import 'package:lifeline/features/user/domain/usecases/edit_user.dart';
import 'package:lifeline/features/user/domain/usecases/upload_user_profile.dart';
import 'package:lifeline/features/user/presentation/controller/user_controller.dart';

class EditProfileController extends GetxController {
  final EditUser editUser;
  final UploadUserProfile uploadUserProfile;
  EditProfileController({
    required this.editUser,
    required this.uploadUserProfile,
  });

  var username = TextEditingController().obs;
  var fullname = TextEditingController().obs;
  var bio = TextEditingController().obs;
  var phone = TextEditingController().obs;
  var location = TextEditingController().obs;

  var profileUrl = 'asd'.obs;
  RxBool profileVisibilty = RxBool(false);
  RxBool makeStoriesPublic = RxBool(false);
  RxBool updatingProfile = RxBool(false);
  var selectedFile = Rx<File?>(null);

  final userController = Get.find<UserController>();

  void initData(UserEntity user) {
    fullname.value.text = user.fullName;
    username.value.text = user.username ?? '';
    bio.value.text = user.bio ?? '';
    phone.value.text = user.phone ?? '';
    location.value.text = user.location ?? '';
    profileUrl.value = user.profileUrl ?? '';
    profileVisibilty.value = user.profileVisibility ?? false;
    makeStoriesPublic.value = user.isStoriesPublic ?? false;
  }

  @override
  void onClose() {
    username.value.dispose();
    fullname.value.dispose();
    bio.value.dispose();
    phone.value.dispose();
    location.value.dispose();
    super.onClose();
  }

  Future<void> updateUser() async {
    try {
      updatingProfile.value = true;
      if (selectedFile.value != null) {
        final urlResult = await uploadUserProfile.call(selectedFile.value!);
        urlResult.fold((error) => showErrorDialog(error.message), (url) {
          profileUrl.value = url!;
        });
      }
      final Map<String, dynamic> data = {
        'fullName': fullname.value.text.trim(),
        'username': username.value.text.trim(),
        'bio': bio.value.text,
        'isStoriesPublic': makeStoriesPublic.value,
        'profileVisibility': profileVisibilty.value,
        'profileUrl': profileUrl.value,
        'phone': phone.value.text,
        'location': location.value.text,
      };
      debugPrint('Method called');
      final result = await editUser.call(data);

      result.fold((error) => showErrorDialog(error.message), (user) {
        showSuccessDialog('Profile Updated Successfully!');
        userController.updateUser(user);
      });
    } catch (e) {
      debugPrint(e.toString());
      showErrorDialog(e.toString());
    } finally {
      updatingProfile.value = false;
    }
  }

  Future<void> selectImage() async {
    selectedFile.value = await pickImage();
  }
}
