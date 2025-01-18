import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/modules/auth/domain/domain.dart';

abstract class AuthContract {
  Future<Either<Failure, bool>> signInWithGoogle();

  Future<Either<Failure, bool>> signInWithApple();

  Future<Either<Failure, bool>> signUp(SignUpParams params);

  Future<Either<Failure, bool>> logIn(LogInParams params);

  Future<Either<Failure, bool>> addName();

  Stream<bool> getAuthState();

  Future<Either<Failure, bool>> versionIsUpToDate();
}
