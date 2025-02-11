// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

typedef SessionList = List<SessionEntity>;

class GroupSessions extends Equatable {
  SessionList finishedSessions;
  SessionList dormantSessions;
  SessionList recruitingSessions;
  SessionList startedSessions;

  GroupSessions({
    required this.finishedSessions,
    required this.dormantSessions,
    required this.recruitingSessions,
    required this.startedSessions,
  });

  factory GroupSessions.initial() => GroupSessions(
        finishedSessions: [],
        dormantSessions: [],
        recruitingSessions: [],
        startedSessions: [],
      );

  @override
  List<Object> get props => [
        finishedSessions,
        dormantSessions,
        recruitingSessions,
        startedSessions,
      ];
}

class SessionEntity extends Equatable {
  final String title;
  final String createdAt;
  final int id;
  const SessionEntity({
    required this.title,
    required this.id,
    required this.createdAt,
  });

  factory SessionEntity.empty() => const SessionEntity(
        title: '',
        id: -1,
        createdAt: '',
      );

  @override
  List<Object> get props => [title, id, createdAt];
}
