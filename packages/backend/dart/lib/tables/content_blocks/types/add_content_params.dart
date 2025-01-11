import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/content_blocks.dart';

class AddContentParams extends Equatable {
  final String content;
  final String parentUID;
  final ContentBlockType contentBlockType;

  AddContentParams({
    required this.content,
    required this.parentUID,
    required this.contentBlockType,
  });

  factory AddContentParams.initial() => AddContentParams(
        content: '',
        parentUID: '',
        contentBlockType: ContentBlockType.none,
      );

  @override
  List<Object> get props => [
        content,
        parentUID,
        contentBlockType,
      ];
}
