import 'package:equatable/equatable.dart';

class CreateQueueParams extends Equatable {
  final String groupId;
  final List<String> content;
  final String title;

  const CreateQueueParams({
    required this.groupId,
    required this.content,
    required this.title,
  });

  @override
  List<Object> get props => [groupId, content, title];
}
