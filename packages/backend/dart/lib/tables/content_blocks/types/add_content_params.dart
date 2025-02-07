import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/content_blocks.dart';

class AddContentParams extends Equatable {
  final String content;
  final int parentId;
  final int groupId;
  final ContentBlockType contentBlockType;
  final int documentId;

  AddContentParams({
    required this.groupId,
    required this.content,
    required this.contentBlockType,
    required this.documentId,
    this.parentId = -1,
  });

  factory AddContentParams.initial() => AddContentParams(
        content: '',
        groupId: -1,
        parentId: -1,
        documentId: -1,
        contentBlockType: ContentBlockType.none,
      );

  @override
  List<Object> get props => [
        content,
        groupId,
        parentId,
        contentBlockType,
        documentId,
      ];
}
