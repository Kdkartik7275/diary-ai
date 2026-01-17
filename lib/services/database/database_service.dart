import 'package:flutter/cupertino.dart';
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
      version: 7,
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

      final int deletedCount = await db.delete(
        _userTableName,
        where: '$_userId = ?',
        whereArgs: [userId],
      );

      return deletedCount > 0;
    } catch (e) {
      debugPrint('Error deleting user: $e');
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
}
