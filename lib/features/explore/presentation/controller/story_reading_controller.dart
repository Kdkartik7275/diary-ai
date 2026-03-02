// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mindloom/core/di/init_dependencies.dart';
import 'package:mindloom/core/snackbars/error_snackbar.dart';
import 'package:mindloom/features/explore/presentation/controller/explore_controller.dart';
import 'package:mindloom/features/notifications/domain/entity/app_notification.dart';
import 'package:mindloom/features/notifications/domain/usecases/create_notification.dart';
import 'package:mindloom/features/story/data/model/story_stats_model.dart';
import 'package:mindloom/features/story/domain/entity/story_entity.dart';
import 'package:mindloom/features/story/domain/entity/story_stats.dart';
import 'package:mindloom/features/story/domain/usecases/like_story.dart';
import 'package:mindloom/features/story/domain/usecases/mark_story_read.dart';
import 'package:mindloom/features/story/domain/usecases/unlike_story.dart';

class StoryReadingController extends GetxController {
  final LikeStory likeStoryUseCase;
  final UnlikeStory unlikeStoryUseCase;
  final MarkStoryRead markStoryReadUseCase;
  final CreateNotification createNotificationUseCase;

  StoryReadingController({
    required this.likeStoryUseCase,
    required this.markStoryReadUseCase,
    required this.unlikeStoryUseCase,
    required this.createNotificationUseCase,
  });

  final exploreController = Get.find<ExploreController>();

  final _currentPage = 0.obs;
  int get currentPage => _currentPage.value;

  final RxList<_ReaderPage> _pages = <_ReaderPage>[].obs;
  List<_ReaderPage> get pages => _pages;

  final Rx<StoryStatsEntity?> _stats = Rx<StoryStatsEntity?>(null);
  StoryStatsEntity? get stats => _stats.value;

  final _isLoadingStats = false.obs;
  bool get isLoadingStats => _isLoadingStats.value;

  void initializeStory({required StoryEntity story}) {
    _pages.value = _buildPages(story);
    loadStats(storyId: story.id);
  }

  List<_ReaderPage> _buildPages(StoryEntity story) {
    final result = <_ReaderPage>[];

    for (int i = 0; i < story.chapters.length; i++) {
      final chapter = story.chapters[i];
      final chapterPages = _paginateContent(chapter.content);

      for (final pageContent in chapterPages) {
        result.add(
          _ReaderPage(
            chapterNumber: i + 1,
            chapterTitle: chapter.title,
            content: pageContent,
          ),
        );
      }
    }

    return result;
  }

  List<String> _paginateContent(String content, {int charsPerPage = 1200}) {
    final pages = <String>[];

    for (int i = 0; i < content.length; i += charsPerPage) {
      int end = i + charsPerPage;

      if (end > content.length) {
        end = content.length;
      }

      pages.add(content.substring(i, end));
    }

    return pages;
  }

  void nextPage() {
    if (_currentPage.value < _pages.length - 1) {
      _currentPage.value++;
    }
  }

  void previousPage() {
    if (_currentPage.value > 0) {
      _currentPage.value--;
    }
  }

  bool get canGoNext => _currentPage.value < _pages.length - 1;
  bool get canGoPrevious => _currentPage.value > 0;

  _ReaderPage get currentReaderPage => _pages[_currentPage.value];

  Future<void> loadStats({required String storyId}) async {
    try {
      _isLoadingStats.value = true;
      final result = await exploreController.getStats(storyId: storyId);
      _stats.value = result;
    } catch (e) {
      _stats.value = StoryStatsModel.empty(storyId);
    } finally {
      _isLoadingStats.value = false;
    }
  }

  Future<void> likeStory({
    required String storyId,
    required String authorId,
    required String storyTitle,
    required String username,
    String? storyImageURL,
  }) async {
    final currentStats = _stats.value;

    if (currentStats?.isLikedByYou == true) return;

    if (currentStats != null) {
      _stats.value = StoryStatsModel(
        storyId: currentStats.storyId,
        reads: currentStats.reads,
        likes: currentStats.likes + 1,
        comments: currentStats.comments,
        saved: currentStats.saved,
        isLikedByYou: true,
        trendingScore: currentStats.trendingScore,
      );
    }

    try {
      final result = await likeStoryUseCase.call(
        LikeStoryParams(
          userId: sl<FirebaseAuth>().currentUser!.uid,
          storyId: storyId,
        ),
      );
      result.fold((err) => showErrorDialog('Something went wrong'), (_) async {
        await createLikeStoryNotification(
          authorId: authorId,
          storyTitle: storyTitle,
          username: username,
          referenceId: storyId,
          storyImage: storyImageURL,
        );
      });
    } catch (e) {
      if (currentStats != null) {
        _stats.value = currentStats;
      }

      showErrorDialog(e.toString());
    }
  }

  Future<void> unlikeStory({required String storyId}) async {
    final currentStats = _stats.value;

    if (currentStats?.isLikedByYou == false) return;

    if (currentStats != null) {
      _stats.value = StoryStatsModel(
        storyId: currentStats.storyId,
        reads: currentStats.reads,
        likes: currentStats.likes - 1,
        comments: currentStats.comments,
        saved: currentStats.saved,
        trendingScore: currentStats.trendingScore,
        isLikedByYou: false,
      );
    }

    try {
      await unlikeStoryUseCase.call({
        'userId': sl<FirebaseAuth>().currentUser!.uid,
        'storyId': storyId,
      });
    } catch (e) {
      if (currentStats != null) {
        _stats.value = currentStats;
      }

      showErrorDialog(e.toString());
    }
  }

  Future<void> createLikeStoryNotification({
    required String authorId,
    required String storyTitle,
    required String username,
    String? storyImage,
    String? referenceId,
  }) async {
    try {
      final Map<String, dynamic> notifData = {
        'userId': authorId,
        'type': NotificationType.storyLiked,
        'priority': NotificationPriority.normal,
        'actionType': NotificationActionType.openStory,
        'title': '$username liked your story',
        'body': '"$storyTitle" received a new like.',
        if (storyImage != null) 'imageUrl': storyImage,
        if (referenceId != null) 'referenceId': referenceId,
        'metaData': <String, dynamic>{},
      };
      final result = await createNotificationUseCase.call(notifData);
      result.fold((err) => showErrorDialog(err.message), (success) {});
    } catch (e) {
      debugPrint(e.toString());
      showErrorDialog(e.toString());
    }
  }

  Future<void> markStoryRead({required String storyId}) async {
    try {
      await markStoryReadUseCase.call(
        MarkStoryReadParams(
          userId: sl<FirebaseAuth>().currentUser!.uid,
          storyId: storyId,
        ),
      );
    } catch (e) {
      showErrorDialog(e.toString());
    }
  }
}

class _ReaderPage {
  final String chapterTitle;
  final String content;
  final int chapterNumber;

  const _ReaderPage({
    required this.chapterTitle,
    required this.content,
    required this.chapterNumber,
  });
}
