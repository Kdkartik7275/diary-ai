// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:lifeline/config/constants/colors.dart';
import 'package:lifeline/config/routes/app_routes.dart';
import 'package:lifeline/core/containers/rounded_container.dart';
import 'package:lifeline/features/profile/presentation/views/upgrade_premium_view.dart';
import 'package:lifeline/features/profile/presentation/widgets/personal_info_tile.dart';
import 'package:lifeline/features/user/presentation/controller/user_controller.dart';

class AccountDetailsView extends GetView<UserController> {
  const AccountDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(),
      body: Obx(() {
        final user = controller.currentUser.value;

        return SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: width * 0.04),
            children: [
              SizedBox(height: height * 0.01),
              Text(
                'Account Details',
                style: theme.titleMedium!.copyWith(fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 2),
              Text(
                'Manage your account information',
                style: theme.titleSmall!.copyWith(
                  color: AppColors.textLighter,
                  fontWeight: FontWeight.w500,
                ),
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
                      child: Text(
                        'Personal Information',
                        style: theme.titleLarge,
                      ),
                    ),
                    Divider(color: AppColors.border.withValues(alpha: .3)),
                    PersonalInfoTile(
                      height: height,
                      width: width,
                      backgroundColor: const Color(0xFF8BC6FF),
                      icon: CupertinoIcons.mail,
                      title: 'Email Address',
                      value: user!.email,
                    ),
                    if (user.phone != null && user.phone!.isNotEmpty)
                      PersonalInfoTile(
                        height: height,
                        width: width,
                        backgroundColor: const Color(0xFFB095FF),
                        icon: CupertinoIcons.phone,
                        title: 'Phone Number',
                        value: user.phone!,
                      ),
                    if (user.location != null && user.location!.isNotEmpty)
                      PersonalInfoTile(
                        height: height,
                        width: width,
                        backgroundColor: const Color(0xFFFFB175),
                        icon: CupertinoIcons.location_solid,
                        title: 'Location',
                        value: user.location!,
                      ),
                    PersonalInfoTile(
                      height: height,
                      width: width,
                      backgroundColor: const Color(0xFF8BC6FF),
                      icon: CupertinoIcons.calendar,
                      title: 'Member Since',
                      value: DateFormat(
                        'MMMM d, yyyy',
                      ).format(user.createdAt.toDate()),
                    ),
                    Divider(color: AppColors.border.withValues(alpha: .3)),
                    GestureDetector(
                      onTap: () =>
                          Get.toNamed(Routes.editProfile, arguments: user),
                      child: TRoundedContainer(
                        margin: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        height: height * .05,
                        width: width,
                        radius: 14,
                        backgroundColor: AppColors.primary.withValues(
                          alpha: .2,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Edit Information',
                          style: theme.titleLarge!.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
                      child: Text('Security', style: theme.titleLarge),
                    ),
                    Divider(color: AppColors.border.withValues(alpha: .3)),
                    ListTile(
                      leading: Icon(
                        Icons.security_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      title: Text(
                        'Change Password',
                        style: theme.titleLarge!.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        'Last changed 3 months ago',
                        style: theme.titleSmall!.copyWith(
                          color: AppColors.textLighter,
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
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
                      leading: Icon(
                        Icons.security_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      title: Text(
                        'Two-Factor Authentication',
                        style: theme.titleLarge!.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        'Not enabled',
                        style: theme.titleSmall!.copyWith(
                          color: AppColors.textLighter,
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
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
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Subscription Plan',
                                style: theme.titleLarge,
                              ),
                              Text(
                                'Free Plan',
                                style: theme.titleSmall!.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: AppColors.textLighter.withValues(
                                    alpha: .7,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TRoundedContainer(
                            height: height * .04,
                            width: width * .19,
                            radius: 14,
                            backgroundColor: const Color(
                              0xFFB095FF,
                            ).withValues(alpha: .1),
                            alignment: Alignment.center,
                            child: Text(
                              'Active',
                              style: theme.titleLarge!.copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: const Color(0xFFB095FF),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.02),
                      InkWell(
                        onTap: () => Get.to(() => UpgradePremiumView()),
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          height: height * .05,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary.withValues(alpha: .4),
                                AppColors.primary.withValues(alpha: .8),
                              ],
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Upgrade to Premium',
                            style: theme.titleLarge!.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: height * 0.03),

              TRoundedContainer(
                width: width,

                borderColor: Colors.red,
                radius: 16,
                showBorder: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
                      child: Text(
                        'Danger Zone',
                        style: theme.titleLarge!.copyWith(color: Colors.red),
                      ),
                    ),
                    Divider(color: AppColors.border.withValues(alpha: .3)),
                    ListTile(
                      leading: Icon(
                        CupertinoIcons.delete,
                        color: AppColors.primary,
                      ),
                      title: Text(
                        'Delete Account',
                        style: theme.titleLarge!.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      ),
                      subtitle: Text(
                        'Permanently delete your account and all data',
                        style: theme.titleSmall!.copyWith(
                          color: AppColors.textLighter,
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 0,
                      ),
                      minVerticalPadding: 0,
                      visualDensity: const VisualDensity(vertical: -4),
                    ),
                    SizedBox(height: height * 0.02),
                  ],
                ),
              ),
              SizedBox(height: height * 0.06),
            ],
          ),
        );
      }),
    );
  }
}
