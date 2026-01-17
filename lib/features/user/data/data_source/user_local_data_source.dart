import 'package:lifeline/features/user/data/model/user_model.dart';
import 'package:lifeline/services/database/database_service.dart';

abstract interface class UserLocalDataSource {
  Future<void> insertUser({required Map<String, dynamic> data});

  Future<UserModel> getUser({required String userId});
  Future<void> updateUser({required UserModel user});
  Future<bool> userExists({required String userId});
}

class UserLocalDataSourceImpl extends UserLocalDataSource {
  final _db = DataBaseService.instance;

  @override
  Future<UserModel> getUser({required String userId}) async {
    try {
      final data = await _db.getUser(userId: userId);
      if (data != null) {
        final user = UserModel.fromSql(data);
        return user;
      } else {
        throw 'User Not Found.';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> insertUser({required Map<String, dynamic> data}) async {
    try {
      await _db.insertUser(data: data);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<bool> userExists({required String userId}) async {
    try {
      return await _db.userExists(userId);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Future<void> updateUser({required UserModel user}) async {
    try {
      await _db.updateUser(data: user.toSql(), userId: user.id);
    } catch (e) {
      throw e.toString();
    }
  }
}
