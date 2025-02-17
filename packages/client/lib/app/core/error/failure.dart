import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String message;
  final String failureCode;

  const Failure({required this.message, required this.failureCode});

  @override
  List<Object> get props => [message, failureCode];
}
