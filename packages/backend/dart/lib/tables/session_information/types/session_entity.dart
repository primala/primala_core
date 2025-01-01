import 'package:equatable/equatable.dart';

typedef SessionList = List<SessionEntity>;

class GroupSessions extends Equatable {
  final SessionList finishedSessions;
  final SessionList dormantSessions;

  GroupSessions({
    required this.finishedSessions,
    required this.dormantSessions,
  });

  factory GroupSessions.initial() => GroupSessions(
        finishedSessions: [],
        dormantSessions: [],
      );

  @override
  List<Object> get props => [finishedSessions, dormantSessions];
}

class SessionEntity extends Equatable {
  final String title;
  final String createdAt;
  final String uid;
  const SessionEntity({
    required this.title,
    required this.uid,
    required this.createdAt,
  });

  factory SessionEntity.empty() => const SessionEntity(
        title: '',
        uid: '',
        createdAt: '',
      );

  @override
  List<Object> get props => [title, uid, createdAt];
}
