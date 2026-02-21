// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lifeline/core/animation/publish_success_dialog.dart';

import 'package:lifeline/core/di/init_dependencies.dart';
import 'package:lifeline/core/snackbars/error_snackbar.dart';
import 'package:lifeline/features/story/domain/entity/story_entity.dart';
import 'package:lifeline/features/story/domain/usecases/get_drafts_count.dart';
import 'package:lifeline/features/story/domain/usecases/get_published_count.dart';
import 'package:lifeline/features/story/domain/usecases/get_published_stories.dart';
import 'package:lifeline/features/story/domain/usecases/get_user_drafts.dart';
import 'package:lifeline/features/story/domain/usecases/publish_story.dart';
import 'package:lifeline/features/story/domain/usecases/stories_total_wordcount.dart';

class StoryController extends GetxController {
  final GetUserDrafts getUserDrafts;
  final StoriesTotalWordcount storiesTotalWordcount;
  final GetDraftsCount draftsCount;
  final GetPublishedCount publishedCount;
  final PublishStory publishStory;
  final GetPublishedStories getPublishedStories;

  StoryController({
    required this.getUserDrafts,
    required this.storiesTotalWordcount,
    required this.draftsCount,
    required this.publishedCount,
    required this.publishStory,
    required this.getPublishedStories,
  });
  RxList<StoryEntity> drafts = RxList([]);
  RxList<StoryEntity> published = RxList([]);
  RxBool loading = RxBool(false);
  RxBool publishingStory = RxBool(false);
  RxInt totalWordsCount = RxInt(0);
  RxInt draftStoriesCount = RxInt(0);
  RxInt publishedStoriesCount = RxInt(0);
  RxString publishingStoryId = RxString('');

  @override
  void onInit() {
    super.onInit();
    getUserPublishedStories();
    getDrafts();
  }

  Future<void> publishUserStory({required String storyId}) async {
    try {
      publishingStory.value = true;
      publishingStoryId.value = storyId;

      final userId = sl<FirebaseAuth>().currentUser!.uid;

      final result = await publishStory.call(
        PublishStoryParams(userId: userId, storyId: storyId),
      );

      result.fold((l) => showErrorDialog(l.message), (publishedStory) {
        drafts.removeWhere((story) => story.id == storyId);

        published.insert(0, publishedStory);

        draftStoriesCount.value = (draftStoriesCount.value - 1).clamp(0, 9999);
        publishedStoriesCount.value += 1;
        final context = Get.context!;
        showPublishSuccessDialog(context, storyTitle: publishedStory.title);
      });
    } catch (e) {
      showErrorDialog(e.toString());
    } finally {
      publishingStory.value = false;
      publishingStoryId.value = '';
    }
  }

  Future<void> getDrafts() async {
    try {
      loading.value = true;
      final result = await getUserDrafts.call(
        sl<FirebaseAuth>().currentUser!.uid,
      );
      result.fold(
        (l) => showErrorDialog(l.message),
        (stories) => drafts.value = stories,
      );
      await getTotalWordsCount();
      await getDraftsCount();
      await getPublishedCount();
    } catch (e) {
      showErrorDialog(e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<void> getUserPublishedStories() async {
    try {
      loading.value = true;
      final result = await getPublishedStories.call(
        sl<FirebaseAuth>().currentUser!.uid,
      );
      result.fold(
        (l) => showErrorDialog(l.message),
        (stories) => published.value = stories,
      );
      await getPublishedCount();
    } catch (e) {
      showErrorDialog(e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<void> getTotalWordsCount() async {
    try {
      final result = await storiesTotalWordcount.call(
        sl<FirebaseAuth>().currentUser!.uid,
      );
      result.fold(
        (err) {
          totalWordsCount.value = 0;
        },
        (count) {
          totalWordsCount.value = count;
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      totalWordsCount.value = 0;
    }
  }

  Future<void> getDraftsCount() async {
    try {
      final result = await draftsCount.call(
        sl<FirebaseAuth>().currentUser!.uid,
      );
      result.fold(
        (err) {
          draftStoriesCount.value = 0;
        },
        (count) {
          draftStoriesCount.value = count;
        },
      );
    } catch (e) {
      draftStoriesCount.value = 0;
    }
  }

  Future<void> getPublishedCount() async {
    try {
      final result = await publishedCount.call(
        sl<FirebaseAuth>().currentUser!.uid,
      );
      result.fold(
        (err) {
          publishedStoriesCount.value = 0;
        },
        (count) {
          publishedStoriesCount.value = count;
        },
      );
    } catch (e) {
      publishedStoriesCount.value = 0;
    }
  }

  String formatUpdatedText({
    Timestamp? updatedAt,
    required Timestamp createdAt,
  }) {
    final date = (updatedAt ?? createdAt).toDate();
    final now = DateTime.now();

    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Updated just now';
    } else if (difference.inHours < 1) {
      return 'Updated ${difference.inMinutes} min ago';
    } else if (difference.inDays < 1) {
      return 'Updated ${difference.inHours} hrs ago';
    } else if (difference.inDays == 1) {
      return 'Updated yesterday';
    } else {
      return 'Updated ${difference.inDays} days ago';
    }
  }
}
