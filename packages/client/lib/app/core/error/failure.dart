import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String failureCode;

  const Failure({required this.message, required this.failureCode});

  @override
  List<Object> get props => [message, failureCode];
}

class SupabaseException implements Exception {}

class SupabaseFailure extends Failure {
  const SupabaseFailure({required super.message, required super.failureCode});
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message, required super.failureCode});
}

class AndroidPlatformFailure extends Failure {
  const AndroidPlatformFailure(
      {required super.message, required super.failureCode});
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure(
      {required super.message, required super.failureCode});
}

class NetworkConnectionFailure extends Failure {
  const NetworkConnectionFailure(
      {required super.message, required super.failureCode});
}

class CancelledPurchaseFailure extends Failure {
  const CancelledPurchaseFailure(
      {required super.message, required super.failureCode});
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({required super.message, required super.failureCode});
}

class GenericFailure extends Failure {
  const GenericFailure({required super.message, required super.failureCode});
}

class UserInputFailure extends Failure {
  const UserInputFailure({required super.message, required super.failureCode});
}
