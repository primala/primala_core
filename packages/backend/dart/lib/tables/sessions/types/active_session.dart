import 'package:equatable/equatable.dart';

class ActiveSession extends Equatable {
  final int id;
  final String sessionHost;
  final bool canJoin;

  ActiveSession({
    required this.id,
    required this.sessionHost,
    required this.canJoin,
  });

  factory ActiveSession.initial() =>
      ActiveSession(id: -1, sessionHost: '', canJoin: false);

  @override
  List<Object> get props => [
        id,
        canJoin,
        sessionHost,
      ];
}
