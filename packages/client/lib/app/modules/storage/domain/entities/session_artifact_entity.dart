import 'package:equatable/equatable.dart';

class SessionArtifactEntity extends Equatable {
  final String title;
  final String date;
  final String sessionUID;
  final List content;
  const SessionArtifactEntity({
    required this.title,
    required this.content,
    required this.sessionUID,
    required this.date,
  });

  factory SessionArtifactEntity.initial() => const SessionArtifactEntity(
        title: '',
        content: [],
        sessionUID: '',
        date: '',
      );

  @override
  List<Object?> get props => [title, content, sessionUID];
}
