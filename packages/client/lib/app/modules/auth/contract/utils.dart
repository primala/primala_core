import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/constants/constants.dart';
import 'package:nokhte/app/core/error/failure.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

mixin AuthUtils {
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
}
