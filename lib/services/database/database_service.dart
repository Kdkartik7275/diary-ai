import 'package:flutter/cupertino.dart';
import 'package:lifeline/features/story/data/model/story_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseService {
  static Database? _db;
  static final DataBaseService instance = DataBaseService._constructor();

  DataBaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  // --------- User Table
  final String _userTableName = 'User';
  final String _userId = 'id';
  final String _userFullName = 'fullName';
  final String _username = 'username';
  final String _userBio = 'bio';
  final String _userIsStoriesPublic = 'isStoriesPublic';
  final String _userProfileVisibility = 'profileVisibility';
  final String _userEmail = 'email';
  final String _userProfileUrl = 'profileUrl';
  final String _userPhone = 'phone';
  final String _userLocation = 'location';
  final String _userCreatedAt = 'createdAt';

  // ---------- Diary Table
  final String _diaryTableName = 'Diary';
  final String _diaryId = 'id';
  final String _diaryUserId = 'userId';
  final String _diaryTitle = 'title';
  final String _diaryContent = 'content';
  final String _diaryMood = 'mood';
  final String _diaryCreatedAt = 'createdAt';
  final String _diaryUpdatedAt = 'updatedAt';
  final String _diaryTotalWordsCount = 'totalWordsCount';
  final String _readingTime = 'readingTime';
  final String _diaryIsFavourite = 'isFavorite';
  final String _diaryIsPrivate = 'isPrivate';
  final String _diaryStoryId = 'storyId';
  final String _diaryTags = 'tags';
  final String _isUsedInStory = 'isUsedInStory';

  // ----------- Story Table

  final String _storyTableName = 'stories';
  final String _storyId = 'id';
  final String _storyUserId = 'userId';
  final String _storyTitle = 'title';
  final String _storyTags = 'tags';
  final String _storyCoverImageUrl = 'coverImageUrl';
  final String _storyIsPublished = 'isPublished';
  final String _storyGeneratedByAI = 'generatedByAI';
  final String _storyPublishedAt = 'publishedAt';
  final String _storyCreatedAt = 'createdAt';
  final String _storyUpdatedAt = 'updatedAt';

  final String _chapterTableName = 'story_chapters';
  final String _chapterId = 'id';
  final String _chapterStoryId = 'storyId';
  final String _chapterTitle = 'title';
  final String _chapterContent = 'content';
  final String _chapterCreatedAt = 'createdAt';

  Future<void> _onCreate(Database db, int version) async {
    // USER TABLE
    await db.execute('''
  CREATE TABLE $_userTableName (
    $_userId TEXT PRIMARY KEY,
    $_userFullName TEXT NOT NULL,
    $_username TEXT,
    $_userBio TEXT,
    $_userIsStoriesPublic INTEGER,
    $_userProfileVisibility INTEGER,
    $_userEmail TEXT NOT NULL,
    $_userProfileUrl TEXT,
    $_userPhone TEXT,
    $_userLocation TEXT,
    $_userCreatedAt TEXT NOT NULL
  )
''');

    // DIARY TABLE
    await db.execute('''
    CREATE TABLE $_diaryTableName (
      $_diaryId TEXT PRIMARY KEY,
      $_diaryUserId TEXT NOT NULL,
      $_diaryTitle TEXT NOT NULL,
      $_diaryContent TEXT NOT NULL,
      $_diaryMood TEXT NOT NULL,
      $_diaryCreatedAt TEXT NOT NULL,
      $_diaryUpdatedAt TEXT,
      $_diaryTotalWordsCount INTEGER NOT NULL,
      $_readingTime INTEGER NOT NULL,
      $_diaryIsFavourite INTEGER NOT NULL,
      $_diaryIsPrivate INTEGER NOT NULL,
      $_isUsedInStory INTEGER,
      $_diaryStoryId TEXT,
      $_diaryTags TEXT
    )
  ''');

    await db.execute('''
  CREATE TABLE $_storyTableName (
    $_storyId TEXT PRIMARY KEY,
    $_storyUserId TEXT NOT NULL,
    $_storyTitle TEXT NOT NULL,
    $_storyCoverImageUrl TEXT,
    $_storyTags TEXT NOT NULL,
    $_storyIsPublished INTEGER NOT NULL DEFAULT 0,
    $_storyGeneratedByAI INTEGER NOT NULL,
    $_storyPublishedAt INTEGER,
    $_storyCreatedAt INTEGER NOT NULL,
    $_storyUpdatedAt INTEGER
  )
''');

    await db.execute('''
  CREATE TABLE $_chapterTableName (
    $_chapterId TEXT PRIMARY KEY,
    $_chapterStoryId TEXT NOT NULL,
    $_chapterTitle TEXT NOT NULL,
    $_chapterContent TEXT NOT NULL,
    $_chapterCreatedAt INTEGER NOT NULL,
    FOREIGN KEY ($_chapterStoryId)
      REFERENCES $_storyTableName ($_storyId)
      ON DELETE CASCADE
  )
''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    debugPrint("Upgrading DB from $oldVersion to $newVersion");

    bool needsRecreate = false;

    if (oldVersion < newVersion) {
      needsRecreate = true;
    }

    if (needsRecreate) {
      await db.execute("DROP TABLE IF EXISTS $_diaryTableName");
      await db.execute("DROP TABLE IF EXISTS $_userTableName");
      await db.execute("DROP TABLE IF EXISTS $_chapterTableName");
      await db.execute("DROP TABLE IF EXISTS $_storyTableName");

      // Create fresh tables
      await _onCreate(db, newVersion);

      debugPrint("Database schema recreated successfully");
    }
  }

  Future<Database> _initDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");

    return await openDatabase(
      databasePath,
      version: 9,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // ---------------------- USER DB METHODS -----------------------
  Future<void> insertUser({required Map<String, dynamic> data}) async {
    try {
      final db = await database;
      db.insert(_userTableName, data);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Map<String, dynamic>?> getUser({required String userId}) async {
    try {
      final db = await database;

      final List<Map<String, dynamic>> userData = await db.query(
        _userTableName,
        where: '$_userId = ?',
        whereArgs: [userId],
      );
      if (userData.isNotEmpty) {
        return userData.first;
      }
      return null;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> deleteUser({required String userId}) async {
    try {
      final db = await database;

      await db.transaction((txn) async {
        await txn.delete(
          _diaryTableName,
          where: '$_diaryUserId = ?',
          whereArgs: [userId],
        );

        await txn.delete(
          _chapterTableName,
          where:
              '$_chapterStoryId IN (SELECT $_storyId FROM $_storyTableName WHERE $_storyUserId = ?)',
          whereArgs: [userId],
        );

        await txn.delete(
          _storyTableName,
          where: '$_storyUserId = ?',
          whereArgs: [userId],
        );

        await txn.delete(
          _userTableName,
          where: '$_userId = ?',
          whereArgs: [userId],
        );
      });

      debugPrint('All user data deleted successfully');
      return true;
    } catch (e) {
      debugPrint('Error deleting user data: $e');
      return false;
    }
  }

  Future<void> updateUser({
    required Map<String, dynamic> data,
    required String userId,
  }) async {
    try {
      final db = await database;

      await db.update(
        _userTableName,
        data,
        where: '$_userId = ?',
        whereArgs: [userId],
      );
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> userExists(String userId) async {
    try {
      final db = await database;

      List<Map<String, dynamic>> result = await db.query(
        _userTableName,
        where: '$_userId = ?',
        whereArgs: [userId],
      );

      return result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // --------------------- DIARY DB METHODS ---------------------

  Future<void> createDiary({required Map<String, dynamic> data}) async {
    try {
      final db = await database;
      db.insert(_diaryTableName, data);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<Map<String, dynamic>?> getDiary({required String diaryId}) async {
    try {
      final db = await database;

      final List<Map<String, dynamic>> diaryData = await db.query(
        _diaryTableName,
        where: '$_diaryId = ?',
        whereArgs: [diaryId],
      );
      if (diaryData.isNotEmpty) {
        return diaryData.first;
      }
      return null;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<Map<String, dynamic>>> getDiaries({
    required String userId,
  }) async {
    try {
      final db = await database;

      final List<Map<String, dynamic>> diaryData = await db.query(
        _diaryTableName,
        where: '$_diaryUserId = ?',
        whereArgs: [userId],
      );
      return diaryData;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<Map<String, dynamic>>> getDiariesFromDateRange({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final db = await database;

      final startIso = DateTime(
        startDate.year,
        startDate.month,
        startDate.day,
      ).toIso8601String();

      final endIso = DateTime(
        endDate.year,
        endDate.month,
        endDate.day,
        23,
        59,
        59,
      ).toIso8601String();

      final result = await db.rawQuery(
        '''
      SELECT *
      FROM $_diaryTableName
      WHERE $_diaryUserId = ?
      AND (
        ($_diaryCreatedAt BETWEEN ? AND ?)
        OR
        ($_diaryUpdatedAt IS NOT NULL AND $_diaryUpdatedAt BETWEEN ? AND ?)
      )
      ORDER BY $_diaryCreatedAt ASC
      ''',
        [userId, startIso, endIso, startIso, endIso],
      );

      return result;
    } catch (e) {
      debugPrint('Error fetching diaries by date range: $e');
      return [];
    }
  }

  Future<bool> diaryExists(String diaryId) async {
    try {
      final db = await database;

      List<Map<String, dynamic>> result = await db.query(
        _diaryTableName,
        where: '$_diaryId = ?',
        whereArgs: [diaryId],
      );

      return result.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<bool> isDiaryTableEmpty() async {
    final db = await database;

    try {
      final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $_diaryTableName'),
      );

      if (count != null && count > 0) {
        debugPrint('Diary table is not empty');
        return false;
      } else {
        debugPrint('Diary table is empty');
        return true;
      }
    } catch (e) {
      debugPrint('Error checking if Diary table is empty: $e');
      return true;
    }
  }

  Future<void> updateDiary({
    required Map<String, dynamic> data,
    required String diaryId,
  }) async {
    try {
      final db = await database;

      await db.update(
        _diaryTableName,
        data,
        where: '$_diaryId = ?',
        whereArgs: [diaryId],
      );
    } catch (e) {
      throw e.toString();
    }
  }

  // ------------------- STORY DB METHODS ------------------------

  Future<void> addStory(StoryModel story) async {
    final db = await database;
    final batch = db.batch();

    batch.insert(
      _storyTableName,
      story.toSql(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    for (final chapter in story.chapters) {
      batch.insert(_chapterTableName, {
        'id': chapter.id,
        'storyId': story.id,
        'title': chapter.title,
        'content': chapter.content,
        'createdAt': chapter.createdAt.millisecondsSinceEpoch,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit(noResult: true);
  }

  Future<void> updateStory(StoryModel story) async {
    final db = await database;
    final batch = db.batch();

    batch.update(
      _storyTableName,
      story.toSql(),
      where: '$_storyId = ?',
      whereArgs: [story.id],
    );

    batch.delete(
      _chapterTableName,
      where: '$_chapterStoryId = ?',
      whereArgs: [story.id],
    );

    for (final chapter in story.chapters) {
      batch.insert(_chapterTableName, {
        _chapterId: chapter.id,
        _chapterStoryId: story.id,
        _chapterTitle: chapter.title,
        _chapterContent: chapter.content,
        _chapterCreatedAt: chapter.createdAt.millisecondsSinceEpoch,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit(noResult: true);
  }

  Future<List<StoryModel>> getDraftStories(String userId) async {
    final db = await database;

    final stories = await db.query(
      _storyTableName,
      where: '$_storyUserId = ? AND $_storyIsPublished = 0',
      whereArgs: [userId],
      orderBy: '$_storyCreatedAt DESC',
    );

    return _mapStoriesWithChapters(stories);
  }

  Future<List<StoryModel>> getPublishedStories(String userId) async {
    final db = await database;

    final stories = await db.query(
      _storyTableName,
      where: '$_storyUserId = ? AND $_storyIsPublished = 1',
      whereArgs: [userId],
      orderBy: '$_storyPublishedAt DESC',
    );

    return _mapStoriesWithChapters(stories);
  }

  Future<List<StoryModel>> getAllStories({required String userId}) async {
    final db = await database;
    final result = await db.query(
      _storyTableName,
      where: '$_storyUserId = ?',
      whereArgs: [userId],
      orderBy: '$_storyUpdatedAt DESC',
    );
    return _mapStoriesWithChapters(result);
  }

  Future<void> deleteStory(String storyId) async {
    final db = await database;

    await db.delete(
      _storyTableName,
      where: '$_storyId = ?',
      whereArgs: [storyId],
    );
  }

  Future<bool> isStoryTableEmpty() async {
    final db = await database;

    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM $_storyTableName'),
    );

    return count == null || count == 0;
  }

  Future<List<StoryModel>> _mapStoriesWithChapters(
    List<Map<String, dynamic>> storyMaps,
  ) async {
    final db = await database;
    final List<StoryModel> stories = [];

    for (final story in storyMaps) {
      final chaptersMap = await db.query(
        _chapterTableName,
        where: '$_chapterStoryId = ?',
        whereArgs: [story[_storyId]],
        orderBy: '$_chapterCreatedAt ASC',
      );

      final chapters = chaptersMap
          .map((e) => StoryChapterModel.fromSql(e))
          .toList();

      stories.add(StoryModel.fromSql(story, chapters: chapters));
    }

    return stories;
  }

  Future<int> getAllStoriesCount({required String userId}) async {
    final db = await database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery(
        'SELECT COUNT(*) FROM $_storyTableName WHERE $_storyUserId = ?',
        [userId],
      ),
    );
    return count ?? 0;
  }

  Future<int> getDraftStoriesCount({required String userId}) async {
    final db = await database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery(
        'SELECT COUNT(*) FROM $_storyTableName WHERE $_storyUserId = ? AND $_storyIsPublished = 0',
        [userId],
      ),
    );
    return count ?? 0;
  }

  Future<int> getPublishedStoriesCount({required String userId}) async {
    final db = await database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery(
        'SELECT COUNT(*) FROM $_storyTableName WHERE $_storyUserId = ? AND $_storyIsPublished = 1',
        [userId],
      ),
    );
    return count ?? 0;
  }

  Future<int> getTotalWordsCount({required String userId}) async {
    final db = await database;

    final chapters = await db.rawQuery(
      '''
    SELECT c.$_chapterContent
    FROM $_chapterTableName c
    INNER JOIN $_storyTableName s
    ON c.$_chapterStoryId = s.$_storyId
    WHERE s.$_storyUserId = ?
  ''',
      [userId],
    );

    int totalWords = 0;

    for (final chapter in chapters) {
      final content = chapter[_chapterContent] as String? ?? '';
      totalWords += content.trim().split(RegExp(r'\s+')).length;
    }

    return totalWords;
  }
}
