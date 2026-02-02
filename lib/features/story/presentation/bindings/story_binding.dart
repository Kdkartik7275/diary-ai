import 'package:get/get.dart';
import 'package:lifeline/core/di/init_dependencies.dart';
import 'package:lifeline/features/story/domain/usecases/get_drafts_count.dart';
import 'package:lifeline/features/story/domain/usecases/get_published_count.dart';
import 'package:lifeline/features/story/domain/usecases/get_published_stories.dart';
import 'package:lifeline/features/story/domain/usecases/get_user_drafts.dart';
import 'package:lifeline/features/story/domain/usecases/publish_story.dart';
import 'package:lifeline/features/story/domain/usecases/stories_total_wordcount.dart';
import 'package:lifeline/features/story/presentation/controller/story_controller.dart';

class StoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => StoryController(
        getUserDrafts: sl<GetUserDrafts>(),
        storiesTotalWordcount: sl<StoriesTotalWordcount>(),
        draftsCount: sl<GetDraftsCount>(),
        publishedCount: sl<GetPublishedCount>(),
        publishStory: sl<PublishStory>(),
        getPublishedStories: sl<GetPublishedStories>(),
      ),
    );
  }
}
