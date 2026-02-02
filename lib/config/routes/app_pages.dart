import 'package:get/get.dart';
import 'package:lifeline/features/authentication/presentation/bindings/login_binding.dart';
import 'package:lifeline/features/authentication/presentation/bindings/signup_binding.dart';
import 'package:lifeline/features/authentication/presentation/views/login_view.dart';
import 'package:lifeline/features/authentication/presentation/views/signup_view.dart';
import 'package:lifeline/features/diary/presentation/binding/create_diary_binding.dart';
import 'package:lifeline/features/diary/presentation/binding/diary_binding.dart';
import 'package:lifeline/features/diary/presentation/view/create_entry.dart';
import 'package:lifeline/features/profile/presentation/bindings/edit_profile_binding.dart';
import 'package:lifeline/features/profile/presentation/views/edit_profile_view.dart';
import 'package:lifeline/features/story/presentation/bindings/create_story_binding.dart';
import 'package:lifeline/features/story/presentation/bindings/story_binding.dart';
import 'package:lifeline/features/story/presentation/views/create_manual_story.dart';
import 'package:lifeline/features/story/presentation/views/create_story_view.dart';
import 'package:lifeline/features/story/presentation/views/story_type_view.dart';
import 'package:lifeline/features/user/presentation/binding/user_binding.dart';
import 'package:lifeline/tabs.dart';
import 'package:lifeline/features/onboarding/binding/onboarding_binding.dart';
import 'package:lifeline/features/onboarding/presentation/views/onboarding_view.dart';

import 'app_routes.dart';

class AppPages {
  static const initial = Routes.onboarding;

  static final routes = [
    GetPage(
      name: Routes.login,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.signup,
      page: () => SignUpView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.tabs,
      page: () => const Tabs(),
      bindings: [UserBinding(), DiaryBinding(), StoryBinding()],
    ),
    GetPage(
      name: Routes.writeDiary,
      page: () => const CreateEntryView(),
      binding: CreateDiaryBinding(),
    ),
    GetPage(
      name: Routes.editProfile,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(name: Routes.createStory, page: () => CreateStoryView()),
    GetPage(name: Routes.storyType, page: () => StoryTypeView()),
    GetPage(
      name: Routes.createStoryManually,
      page: () => CreateManualStory(),
      binding: CreateStoryBinding(),
    ),
  ];
}
