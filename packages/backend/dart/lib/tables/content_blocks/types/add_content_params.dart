import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/content_blocks.dart';

class AddContentParams extends Equatable {
  final String content;
  final int parentId;
  final ContentBlockType contentBlockType;
  final int documentId;

  AddContentParams({
    required this.content,
    required this.contentBlockType,
    required this.documentId,
    this.parentId = -1,
  });

  factory AddContentParams.initial() => AddContentParams(
        content: '',
        parentId: -1,
        documentId: -1,
        contentBlockType: ContentBlockType.none,
      );

  @override
  List<Object> get props => [
        content,
        parentId,
        contentBlockType,
        documentId,
      ];
}
