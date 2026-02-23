import 'package:lifeline/config/constants/typedefs.dart';
import 'package:lifeline/core/usecases/usecases.dart';
import 'package:lifeline/features/social/domain/entity/follow_entity.dart';
import 'package:lifeline/features/social/domain/repository/social_repository.dart';

class GetFollowers implements UseCaseWithParams<List<FollowEntity>, String> {
  final SocialRepository repository;

  GetFollowers({required this.repository});
  @override
  ResultFuture<List<FollowEntity>> call(String params) async {
    return await repository.getFollowers(params);
  }
}
