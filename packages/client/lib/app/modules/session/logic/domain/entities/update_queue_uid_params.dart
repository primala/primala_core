import 'package:equatable/equatable.dart';

class UpdateQueueUIDParams extends Equatable {
  final String queueUID;
  final List content;

  const UpdateQueueUIDParams({
    required this.queueUID,
    required this.content,
  });
  @override
  List<Object> get props => [queueUID, content];
}
