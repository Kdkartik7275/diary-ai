import 'package:lifeline/features/story/data/model/story_model.dart';
import 'package:lifeline/services/database/database_service.dart';

abstract interface class StoryLocalDataSource {
  Future<void> createStory({required StoryModel data});
  Future<void> updateeStory({required StoryModel data});
  Future<void> deleteStory({required String storyId});
  Future<List<StoryModel>> getDraftStories({required String userId});
  Future<List<StoryModel>> getPublishedStories({required String userId});
  Future<List<StoryModel>> getAllStories({required String userId});
  Future<int> getStoriesTotalWordCounts({required String userId});
  Future<int> getDraftCounts({required String userId});
  Future<int> getPublishedCounts({required String userId});
  Future<bool> isStoryTableEmpty();
}

class StoryLocalDataSourceImpl implements StoryLocalDataSource {
  final _db = DataBaseService.instance;

  @override
  Future<void> createStory({required StoryModel data}) async {
    try {
      await _db.addStory(data);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> deleteStory({required String storyId}) async {
    try {
      await _db.deleteStory(storyId);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<List<StoryModel>> getDraftStories({required String userId}) async {
    try {
      return await _db.getDraftStories(userId);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<List<StoryModel>> getPublishedStories({required String userId}) async {
    try {
      return await _db.getPublishedStories(userId);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<List<StoryModel>> getAllStories({required String userId}) async {
    try {
      return await _db.getAllStories(userId: userId);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<bool> isStoryTableEmpty() async {
    try {
      return await _db.isStoryTableEmpty();
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<int> getStoriesTotalWordCounts({required String userId}) async {
    try {
      return await _db.getTotalWordsCount(userId: userId);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<int> getDraftCounts({required String userId}) async {
    try {
      return await _db.getDraftStoriesCount(userId: userId);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<int> getPublishedCounts({required String userId}) async {
    try {
      return await _db.getPublishedStoriesCount(userId: userId);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> updateeStory({required StoryModel data}) async {
    try {
      await _db.updateStory(data);
    } catch (e) {
      throw e.toString();
    }
  }
}
