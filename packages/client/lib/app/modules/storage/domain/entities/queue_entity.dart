import 'package:equatable/equatable.dart';

class QueueEntity extends Equatable {
  final String title;
  final String createdAt;
  final String uid;
  final List content;
  const QueueEntity({
    required this.title,
    required this.content,
    required this.uid,
    required this.createdAt,
  });

  factory QueueEntity.empty() => const QueueEntity(
        title: '',
        content: [],
        uid: '',
        createdAt: '',
      );

  @override
  List<Object?> get props => [title, content, uid, createdAt];
}
