// ignore_for_file: library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:lifeline/core/di/init_dependencies.dart';
import 'package:lifeline/core/snackbars/error_snackbar.dart';
import 'package:lifeline/features/explore/presentation/controller/explore_controller.dart';
import 'package:lifeline/features/story/data/model/story_stats_model.dart';
import 'package:lifeline/features/story/domain/entity/story_entity.dart';
import 'package:lifeline/features/story/domain/entity/story_stats.dart';
import 'package:lifeline/features/story/domain/usecases/like_story.dart';
import 'package:lifeline/features/story/domain/usecases/mark_story_read.dart';
import 'package:lifeline/features/story/domain/usecases/unlike_story.dart';

class StoryReadingController extends GetxController {
  final LikeStory likeStoryUseCase;
  final UnlikeStory unlikeStoryUseCase;
  final MarkStoryRead markStoryReadUseCase;

  StoryReadingController({
    required this.likeStoryUseCase,
    required this.markStoryReadUseCase,
    required this.unlikeStoryUseCase,
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

  Future<void> likeStory({required String storyId}) async {
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
      );
    }

    try {
      await likeStoryUseCase.call(
        LikeStoryParams(
          userId: sl<FirebaseAuth>().currentUser!.uid,
          storyId: storyId,
        ),
      );
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
