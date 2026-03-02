import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/story/domain/repository/story_repository.dart';

class StoriesTotalWordcount implements UseCaseWithParams<int,String>{
  final StoryRepository repository;

  StoriesTotalWordcount({required this.repository});
  @override
  ResultFuture<int> call(String userID) async{
   
   return await repository.getStoriesTotalWordCounts(userId: userID);
  }
}