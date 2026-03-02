import 'package:mindloom/config/constants/typedefs.dart';
import 'package:mindloom/core/usecases/usecases.dart';
import 'package:mindloom/features/social/domain/entity/follow_entity.dart';
import 'package:mindloom/features/social/domain/repository/social_repository.dart';

class GetFollowers implements UseCaseWithParams<List<FollowEntity>, String> {
  final SocialRepository repository;

  GetFollowers({required this.repository});
  @override
  ResultFuture<List<FollowEntity>> call(String params) async {
    return await repository.getFollowers(params);
  }
}
