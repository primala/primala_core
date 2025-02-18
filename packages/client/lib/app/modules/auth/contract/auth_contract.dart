import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/constants/failure_constants.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/core/mixins/response_to_status.dart';
import 'package:nokhte/app/core/utilities/contract_utils.dart';
import 'package:nokhte/app/modules/auth/auth.dart';
import 'package:nokhte/app/core/network/network_info.dart';

abstract class AuthContract {
  Future<Either<Failure, bool>> signInWithGoogle();
  Future<Either<Failure, bool>> signInWithApple();
  Future<Either<Failure, bool>> signUp(SignUpParams params);
  Future<Either<Failure, bool>> logIn(LogInParams params);
  Future<Either<Failure, bool>> addName();
  Stream<bool> getAuthState();
  Future<Either<Failure, bool>> versionIsUpToDate();
}

class AuthContractImpl
    with ResponseToStatus, ContractUtils
    implements AuthContract {
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
        return const Left(FailureConstants.authFailure);
      }
    } else {
      return const Left(FailureConstants.internetConnectionFailure);
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
      return const Left(FailureConstants.internetConnectionFailure);
    }
  }

  @override
  versionIsUpToDate() async {
    if (await networkInfo.isConnected) {
      final versionRes = await remoteSource.versionIsUpToDate();
      return Right(versionRes);
    } else {
      return const Left(FailureConstants.internetConnectionFailure);
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
      failure: FailureConstants.authFailure,
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
      failure: FailureConstants.authFailure,
    ).then((result) => result.fold(
          (failure) => Left(failure),
          (success) => fromSupabase(success),
        ));
  }
}
