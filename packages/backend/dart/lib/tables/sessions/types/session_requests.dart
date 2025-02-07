import 'package:equatable/equatable.dart';

class SessionRequest extends Equatable {
  final int id;
  final String sessionHost;

  SessionRequest({
    required this.id,
    required this.sessionHost,
  });

  factory SessionRequest.initial() => SessionRequest(id: -1, sessionHost: '');

  @override
  List<Object> get props => [
        id,
        sessionHost,
      ];
}
