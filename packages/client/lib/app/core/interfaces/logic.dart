import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:nokhte/app/core/error/failure.dart';

abstract class AbstractFutureLogic<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

abstract class AbstractFutureNoFailureLogic<Type, Params> {
  Future<Type> call(Params params);
}

abstract class AbstractSyncLogic<Type, Params> {
  Either<Failure, Type> call(Params params);
}

abstract class AbstractSyncNoFailureLogic<Type, Params> {
  Type call(Params params);
}

abstract class AbstractStreamLogic<Type, Params> {
  Stream<Either<Failure, Type>> call(Params params);
}

abstract class AbstractNoFailureStreamLogic<Type, Params> {
  Stream<Type> call(Params params);
}

abstract class AbstractNoFailureAsyncLogic<Type, Params> {
  Future<Type> call(Params params);
}

class NoEntity extends Equatable {
  @override
  List<Object> get props => [];
}

class NoParams extends Equatable {
  const NoParams();
  @override
  List<Object> get props => [];
}

class Void extends Equatable {
  @override
  List<Object> get props => [];
}
