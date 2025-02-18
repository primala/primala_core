import 'package:dartz/dartz.dart';
import 'package:nokhte/app/core/error/failure.dart';

mixin ResponseToStatus {
  Either<Failure, bool> fromSupabase(List response) {
    if (response.isEmpty) {
      return const Right(false);
    } else {
      return const Right(true);
    }
  }

  Either<Failure, bool> fromSupabaseSingle(Map response) {
    if (response.isEmpty) {
      return const Right(false);
    } else {
      return const Right(true);
    }
  }

  Either<Failure, T> fromSupabaseProperty<T>(
      List res, String property, T defaultType) {
    if (res.isEmpty) {
      return Right(defaultType);
    } else {
      return Right(res.first[property]);
    }
  }
}
