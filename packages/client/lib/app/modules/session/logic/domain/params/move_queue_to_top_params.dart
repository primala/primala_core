import 'package:equatable/equatable.dart';

class MoveQueueToTopParams extends Equatable {
  final String content;
  final int queueIndex;

  const MoveQueueToTopParams({
    required this.content,
    required this.queueIndex,
  });

  @override
  List<Object> get props => [content, queueIndex];
}
