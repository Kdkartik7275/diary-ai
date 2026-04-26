import 'package:get/get.dart';
import 'package:mindloom/features/authentication/presentation/bindings/login_binding.dart';
import 'package:mindloom/features/authentication/presentation/bindings/signup_binding.dart';
import 'package:mindloom/features/authentication/presentation/views/login_view.dart';
import 'package:mindloom/features/authentication/presentation/views/signup_view.dart';
import 'package:mindloom/features/comments/presentation/binding/comment_binding.dart';
import 'package:mindloom/features/comments/presentation/view/comment_view.dart';
import 'package:mindloom/features/diary/presentation/binding/create_diary_binding.dart';
import 'package:mindloom/features/diary/presentation/binding/diary_binding.dart';
import 'package:mindloom/features/diary/presentation/view/create_entry.dart';
import 'package:mindloom/features/explore/presentation/binding/explore_binding.dart';
import 'package:mindloom/features/feedback/presentation/binding/add_feedback_binding.dart';
import 'package:mindloom/features/feedback/presentation/views/add_feedback_view.dart';
import 'package:mindloom/features/home/presentation/home_binding.dart';
import 'package:mindloom/features/notifications/presentation/binding/notification_binding.dart';
import 'package:mindloom/features/notifications/presentation/views/notification_view.dart';
import 'package:mindloom/features/profile/presentation/bindings/edit_profile_binding.dart';
import 'package:mindloom/features/profile/presentation/bindings/settings_binding.dart';
import 'package:mindloom/features/profile/presentation/views/edit_profile_view.dart';
import 'package:mindloom/features/profile/presentation/views/settings_view.dart';
import 'package:mindloom/features/search/presentation/binding/search_story_binding.dart';
import 'package:mindloom/features/search/presentation/view/search_story_view.dart';
import 'package:mindloom/features/social/presentation/bindings/follow_binding.dart';
import 'package:mindloom/features/story/presentation/bindings/create_story_binding.dart';
import 'package:mindloom/features/story/presentation/bindings/generate_story_binding.dart';
import 'package:mindloom/features/story/presentation/bindings/story_binding.dart';
import 'package:mindloom/features/story/presentation/views/create_manual_story.dart';
import 'package:mindloom/features/story/presentation/views/create_story_view.dart';
import 'package:mindloom/features/story/presentation/views/story_summary_view.dart';
import 'package:mindloom/features/story/presentation/views/story_type_view.dart';
import 'package:mindloom/features/streak/presentation/binding/streak_binding.dart';
import 'package:mindloom/features/user/presentation/binding/user_binding.dart';
import 'package:mindloom/tabs.dart';
import 'package:mindloom/features/onboarding/binding/onboarding_binding.dart';
import 'package:mindloom/features/onboarding/presentation/views/onboarding_view.dart';

import 'package:mindloom/config/routes/app_routes.dart';

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
      bindings: [
        UserBinding(),
        HomeBinding(),
        DiaryBinding(),
        StoryBinding(),
        ExploreBinding(),
        FollowBinding(),
        NotificationBinding(),
        StreakBinding(),
      ],
    ),
    GetPage(
      name: Routes.writeDiary,
      page: () => const CreateEntryView(),
      binding: CreateDiaryBinding(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 200),
    ),
    GetPage(
      name: Routes.editProfile,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: Routes.createStory,
      page: () => CreateStoryView(),
      binding: GenerateStoryBinding(),
    ),
    GetPage(name: Routes.storyType, page: () => StoryTypeView()),
    GetPage(
      name: Routes.createStoryManually,
      page: () => CreateManualStory(),
      binding: CreateStoryBinding(),
    ),
    GetPage(
      name: Routes.comments,
      binding: CommentBinding(),
      page: () => CommentView(),
    ),

    GetPage(name: Routes.notification, page: () => NotificationView()),
    GetPage(
      name: Routes.addFeedback,
      binding: AddFeedbackBinding(),
      page: () => AddFeedbackView(),
    ),
    GetPage(
      name: Routes.search,
      page: () => SearchStoryView(),
      binding: SearchStoryBinding(),
    ),
    GetPage(name: Routes.storySummary, page: () => StorySummaryView()),
    GetPage(
      name: Routes.settings,
      binding: SettingsBinding(),
      page: () => SettingsView(),
      
      
    ),
  ];
}
