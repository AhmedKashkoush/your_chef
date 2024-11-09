import 'package:dartz/dartz.dart';

import '../errors/failures.dart';

abstract class UseCase<Type, Params> {
  const UseCase();
  Future<Either<Failure, Type>> call(Params params);
}

abstract class NoParamsUseCase<Type> {
  const NoParamsUseCase();
  Future<Either<Failure, Type>> call();
}
