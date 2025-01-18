import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/constants/failure_constants.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/core/mixins/response_to_status.dart';
import 'package:nokhte/app/modules/auth/auth.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<Either<Failure, T>> handleRemoteOperation<T>({
  required Future<T> Function() operation,
  required NetworkInfo networkInfo,
}) async {
  if (await networkInfo.isConnected) {
    try {
      final result = await operation();
      return Right(result);
    } catch (e) {
      // You can add more specific error handling here based on the error type
      if (e is AuthException) {
        return Left(AuthFailure(
          message: e.message,
          failureCode: e.toString(),
        ));
      }
      return Left(FailureConstants.authFailure);
    }
  } else {
    return Left(FailureConstants.internetConnectionFailure);
  }
}

class AuthContractImpl with ResponseToStatus implements AuthContract {
  final AuthRemoteSource remoteSource;
  final NetworkInfo networkInfo;

  AuthContractImpl({
    required this.remoteSource,
    required this.networkInfo,
  });

  Future<Either<Failure, bool>> _signInWith(Function getOAuthProvider) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteAuth = await getOAuthProvider();
        return Right(remoteAuth);
      } catch (err) {
        return Left(FailureConstants.authFailure);
      }
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  getAuthState() => remoteSource.getAuthState();

  @override
  addName() async {
    if (await networkInfo.isConnected) {
      final res = await remoteSource.addName();
      return fromSupabase(res);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  versionIsUpToDate() async {
    if (await networkInfo.isConnected) {
      final versionRes = await remoteSource.versionIsUpToDate();
      return Right(versionRes);
    } else {
      return Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  signInWithApple() async =>
      await _signInWith(() => remoteSource.signInWithApple());

  @override
  signInWithGoogle() async =>
      await _signInWith(() => remoteSource.signInWithGoogle());
  @override
  Future<Either<Failure, bool>> signUp(SignUpParams params) async {
    return handleRemoteOperation<List>(
      operation: () => remoteSource.signUp(params),
      networkInfo: networkInfo,
    ).then((result) => result.fold(
          (failure) => Left(failure),
          (success) => fromSupabase(success),
        ));
  }

  @override
  Future<Either<Failure, bool>> logIn(LogInParams params) async {
    return handleRemoteOperation<List>(
      operation: () => remoteSource.logIn(params),
      networkInfo: networkInfo,
    ).then((result) => result.fold(
          (failure) => Left(failure),
          (success) => fromSupabase(success),
        ));
  }
}
