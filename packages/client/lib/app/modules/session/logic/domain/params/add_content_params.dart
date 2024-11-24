import 'package:equatable/equatable.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';

class AddContentParams extends Equatable {
  final String content;
  final int insertAt;

  const AddContentParams({
    required this.content,
    this.insertAt = -1,
  });

  @override
  List<Object> get props => [content, insertAt];
}

class InsertAtEndParams extends NoParams {}
