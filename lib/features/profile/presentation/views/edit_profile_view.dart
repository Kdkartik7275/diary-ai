// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/core/containers/rounded_container.dart';
import 'package:lifeline/features/profile/presentation/controller/edit_profile_controller.dart';
import 'package:lifeline/features/user/domain/entity/user_entity.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late EditProfileController controller;
  @override
  void initState() {
    super.initState();
    controller = Get.find<EditProfileController>();
    final user = Get.arguments as UserEntity?;
    if (user != null) {
      controller.initData(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final theme = Theme.of(context).textTheme;

    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Profile',
            style: theme.titleMedium!.copyWith(fontWeight: FontWeight.normal),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await controller.updateUser();
              },
              child:controller.updatingProfile.value ?CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2,
              ) : Text(
                'Save',
                style: theme.titleLarge!.copyWith(color: AppColors.primary),
              ),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 62,
                    backgroundColor: AppColors.primary.withValues(alpha: .3),
                    backgroundImage: controller.selectedFile.value != null
                        ? FileImage(controller.selectedFile.value!)
                        : controller.profileUrl.value.isNotEmpty
                        ? NetworkImage(controller.profileUrl.value)
                        : null,
                  ),
                  Positioned(
                    bottom: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () async {
                        await controller.selectImage();
                      },
                      child: TRoundedContainer(
                        height: 40,
                        width: 40,
                        radius: 30,
                        backgroundColor: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .1),
                            blurRadius: 6,
                          ),
                        ],
                        alignment: Alignment.center,
                        child: const Icon(
                          CupertinoIcons.camera,
                          size: 22,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * .01),

            Center(
              child: Text(
                "Tap to change photo",
                style: theme.titleSmall!.copyWith(
                  color: AppColors.textLighter,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),

            SizedBox(height: height * .03),

            /// Full Name
            UserInputBox(
              height: height,
              title: 'Full Name',
              hintText: 'Enter your full name',
              controller: controller.fullname.value,
            ),
            SizedBox(height: height * .02),

            UserInputBox(
              height: height,
              title: 'Username',
              hintText: 'Choose a unique username',
              controller: controller.username.value,
            ),
            SizedBox(height: height * .02),

            UserInputBox(
              height: height,
              title: 'Phone Number',
              hintText: 'Enter your phone number',
              controller: controller.phone.value,
            ),
            SizedBox(height: height * .02),

            UserInputBox(
              height: height,
              title: 'Location',
              hintText: 'Enter your city or location',
              controller: controller.location.value,
            ),
            SizedBox(height: height * .02),

            /// Bio
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bio', style: theme.titleLarge),
                SizedBox(height: height * .01),
                TRoundedContainer(
                  radius: 14,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .07),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  child: TextField(
                    maxLines: 5,
                    maxLength: 250,
                    controller: controller.bio.value,
                    style: theme.titleLarge!.copyWith(
                      color: AppColors.hintText,
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      hintText: 'Enter your bio...',
                      hintStyle: theme.titleLarge!.copyWith(
                        color: AppColors.hintText,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.02),
            TRoundedContainer(
              margin: EdgeInsets.zero,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .07),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                    child: Text('Privacy', style: theme.titleLarge),
                  ),
                  Divider(color: AppColors.border.withValues(alpha: .3)),
                  ListTile(
                    title: Text(
                      'Make Stories Public',
                      style: theme.titleLarge!.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      'Allow others to read your stories',
                      style: theme.titleSmall!.copyWith(
                        color: AppColors.textLighter,
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                    trailing: Switch.adaptive(
                      activeThumbColor: AppColors.primary,
                      value: controller.makeStoriesPublic.value,
                      onChanged: (value) {
                        controller.makeStoriesPublic.value = value;
                      },
                    ),
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 0,
                    ),
                    minVerticalPadding: 0,
                    visualDensity: const VisualDensity(vertical: -4),
                  ),
                  Divider(color: AppColors.border.withValues(alpha: .3)),
                  ListTile(
                    title: Text(
                      'Profile Visibility',
                      style: theme.titleLarge!.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: Text(
                      'Show profile to other users',
                      style: theme.titleSmall!.copyWith(
                        color: AppColors.textLighter,
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                    trailing: Switch.adaptive(
                      activeThumbColor: AppColors.primary,
                      value: controller.profileVisibilty.value,
                      onChanged: (value) {
                        controller.profileVisibilty.value = value;
                      },
                    ),
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 0,
                    ),
                    minVerticalPadding: 0,
                    visualDensity: const VisualDensity(vertical: -4),
                  ),
                  SizedBox(height: height * 0.01),
                ],
              ),
            ),
            SizedBox(height: height * 0.1),
          ],
        ),
      );
    });
  }
}

class UserInputBox extends StatelessWidget {
  const UserInputBox({
    super.key,
    required this.height,
    required this.title,
    required this.hintText,
    required this.controller,
  });

  final double height;
  final String title;
  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.titleLarge),
        SizedBox(height: height * .01),
        TRoundedContainer(
          height: height * 0.055,
          radius: 14,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .07),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          child: TextField(
            controller: controller,
            style: theme.titleLarge!.copyWith(
              color: AppColors.hintText,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              hintText: hintText,
              hintStyle: theme.titleLarge!.copyWith(
                color: AppColors.hintText,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
