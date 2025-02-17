import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/constants/constants.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

mixin ContractUtils {
  Future<Either<Failure, T>> handleRemoteOperation<T>({
    required Future<T> Function() operation,
    required NetworkInfo networkInfo,
    required Failure failure,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await operation();
        return Right(result);
      } catch (e) {
        if (e is AuthException) {
          return Left(failure);
        }
        return Left(failure);
      }
    } else {
      return const Left(FailureConstants.internetConnectionFailure);
    }
  }
}
