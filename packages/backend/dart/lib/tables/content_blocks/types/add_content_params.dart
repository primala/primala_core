import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/content_blocks.dart';

class AddContentParams extends Equatable {
  final String content;
  final int parentId;
  final ContentBlockType contentBlockType;

  AddContentParams({
    required this.content,
    required this.parentId,
    required this.contentBlockType,
  });

  factory AddContentParams.initial() => AddContentParams(
        content: '',
        parentId: -1,
        contentBlockType: ContentBlockType.none,
      );

  @override
  List<Object> get props => [
        content,
        parentId,
        contentBlockType,
      ];
}
