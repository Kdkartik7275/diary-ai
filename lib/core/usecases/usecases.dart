
import 'package:lifeline/config/constants/typedefs.dart';

abstract interface class UseCaseWithParams<Type, Params> {
  ResultFuture<Type> call(Params params);
}

abstract interface class UseCaseWithoutParams<Type> {
  ResultFuture<Type> call();
}

abstract interface class StreamUseCaseWithParams<Type, Params> {
  Stream<Type> call(Params params);
}