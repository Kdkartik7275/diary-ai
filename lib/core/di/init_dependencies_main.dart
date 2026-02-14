part of 'init_dependencies.dart';

final sl = GetIt.instance;

class DependencyInjection {
  static Future<void> init() async {
    _initFirebase();
    _initCore();
    _initUser();
    _initAuth();
    _initDiary();
    _initStory();
    _initExplore();
    _initComments();
  }
}

// ----------------------- FIREBASE -----------------------
void _initFirebase() {
  // LazySingleton ensures only one instance is created
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<StorageService>(() => StorageService());
  sl.registerLazySingleton<AIStoryService>(
    () => AIStoryService(apiKey: dotenv.env['OPENAI_API_KEY']!),
  );
}

// ----------------------- CORE -----------------------
void _initCore() {
  sl.registerLazySingleton<InternetConnection>(() => InternetConnection());

  sl.registerLazySingleton<ConnectionChecker>(
    () => ConnectionCheckerImpl(sl<InternetConnection>()),
  );
}

// ----------------------- AUTH -----------------------
void _initAuth() {
  // DATASOURCE
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: sl<FirebaseAuth>()),
  );

  // REPOSITORY
  sl.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(
      connectionChecker: sl<ConnectionChecker>(),
      remoteDataSource: sl<AuthRemoteDataSource>(),
      userRemoteDataSource: sl<UserRemoteDataSource>(),
    ),
  );
  // USECASES
  sl.registerLazySingleton(() => SignInWithEmailAndPassword(repository: sl()));
  sl.registerLazySingleton(() => SignupEmailUsecase(repository: sl()));
}

void _initUser() {
  // DATASOURCE
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(
      firestore: sl<FirebaseFirestore>(),
      auth: sl<FirebaseAuth>(),
      storageService: sl<StorageService>(),
    ),
  );
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      connectionChecker: sl<ConnectionChecker>(),
      remoteDataSource: sl<UserRemoteDataSource>(),
      localDataSource: sl<UserLocalDataSource>(),
    ),
  );
  // USECASES
  sl.registerLazySingleton(() => SaveUser(repository: sl()));
  sl.registerLazySingleton(() => GetUser(repository: sl()));
  sl.registerLazySingleton(() => EditUser(repository: sl()));
  sl.registerLazySingleton(() => UploadUserProfile(repository: sl()));
}

void _initDiary() {
  // DATASOURCE
  sl.registerLazySingleton<DiaryRemoteDataSource>(
    () => DiaryRemoteDataSourceImpl(firestore: sl<FirebaseFirestore>()),
  );
  sl.registerLazySingleton<DiaryLocalDataSource>(
    () => DiaryLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<DiaryRepository>(
    () => DiaryRepositoryImpl(
      connectionChecker: sl<ConnectionChecker>(),
      remoteDataSource: sl<DiaryRemoteDataSource>(),
      localDataSource: sl<DiaryLocalDataSource>(),
    ),
  );
  // USECASES
  sl.registerLazySingleton(() => CreateDiary(repository: sl()));
  sl.registerLazySingleton(() => GetUserDiaries(repository: sl()));
  sl.registerLazySingleton(() => UpdateDiary(repository: sl()));
  sl.registerLazySingleton(() => GetDiariesByRange(repository: sl()));
}

void _initStory() {
  // DATASOURCE
  sl.registerLazySingleton<StoryRemoteDataSource>(
    () => StoryRemoteDataSourceImpl(
      firestore: sl<FirebaseFirestore>(),
      storageService: sl<StorageService>(),
      aiStoryService: sl<AIStoryService>(),
    ),
  );
  sl.registerLazySingleton<StoryLocalDataSource>(
    () => StoryLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<StoryRepository>(
    () => StoryRepositoryImpl(
      connectionChecker: sl<ConnectionChecker>(),
      remoteDataSource: sl<StoryRemoteDataSource>(),
      localDataSource: sl<StoryLocalDataSource>(),
    ),
  );
  // USECASES
  sl.registerLazySingleton(() => CreateStory(repository: sl()));
  sl.registerLazySingleton(() => EditStory(repository: sl()));
  sl.registerLazySingleton(() => GetUserDrafts(repository: sl()));
  sl.registerLazySingleton(() => StoriesTotalWordcount(repository: sl()));
  sl.registerLazySingleton(() => GetDraftsCount(repository: sl()));
  sl.registerLazySingleton(() => GetPublishedCount(repository: sl()));
  sl.registerLazySingleton(() => PublishStory(repository: sl()));
  sl.registerLazySingleton(() => GetPublishedStories(repository: sl()));
  sl.registerLazySingleton(() => GetStoryStats(repository: sl()));
  sl.registerLazySingleton(() => LikeStory(repository: sl()));
  sl.registerLazySingleton(() => UnlikeStory(sl()));
  sl.registerLazySingleton(() => MarkStoryRead(repository: sl()));
  sl.registerLazySingleton(() => UploadStoryCoverImage(repository: sl()));
  sl.registerLazySingleton(() => GenerateStoryFromDiaries(repository: sl()));
}

void _initExplore() {
  // DATASOURCE
  sl.registerLazySingleton<ExploreRemoteDataSource>(
    () => ExploreRemoteDataSourceImpl(firestore: sl<FirebaseFirestore>()),
  );

  sl.registerLazySingleton<ExploreRepository>(
    () => ExploreRepositoryImpl(
      connectionChecker: sl<ConnectionChecker>(),
      remoteDataSource: sl<ExploreRemoteDataSource>(),
    ),
  );
  // USECASES
  sl.registerLazySingleton(() => GetRecentlyAddedStory(repository: sl()));
  sl.registerLazySingleton(() => GetTrendingStories(repository: sl()));
}

void _initComments() {
  // DATASOURCE
  sl.registerLazySingleton<CommentRemoteDataSource>(
    () => CommentRemoteDataSourceImpl(firestore: sl<FirebaseFirestore>()),
  );

  sl.registerLazySingleton<CommentRepository>(
    () => CommentRepositoryImpl(
      connectionChecker: sl<ConnectionChecker>(),
      remoteDataSource: sl<CommentRemoteDataSource>(),
    ),
  );
  // USECASES
  sl.registerLazySingleton(() => AddComment(repository: sl()));
  sl.registerLazySingleton(() => LikeComment(repository: sl()));
  sl.registerLazySingleton(() => UnlikeComment(repository: sl()));
  sl.registerLazySingleton(() => GetComments(repository: sl()));
  sl.registerLazySingleton(() => AddReply(repository: sl()));
  sl.registerLazySingleton(() => GetReplies(repository: sl()));
  sl.registerLazySingleton(() => LikeReply(repository: sl()));
  sl.registerLazySingleton(() => UnlikeReply(repository: sl()));
}
