import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/content_blocks.dart';

class ContentBlock extends Equatable {
  final String content;
  final int id;
  final ContentBlockType contentBlockType;
  final int? parentID;

  ContentBlock({
    required this.content,
    required this.id,
    required this.contentBlockType,
    required this.parentID,
  });

  static List<ContentBlock> fromSupabase(List res) {
    List<ContentBlock> temp = [];
    for (var block in res) {
      temp.add(ContentBlock(
        content: block[ContentBlocksConstants.S_CONTENT],
        id: block[ContentBlocksConstants.S_ID],
        contentBlockType: SessionContentUtils.mapStringToContentBlockType(
          block[ContentBlocksConstants.S_TYPE],
        ),
        parentID: block[ContentBlocksConstants.S_PARENT_ID],
      ));
    }
    return temp;
  }

  @override
  List<Object> get props => [
        content,
        id,
        contentBlockType,
        parentID ?? -1,
      ];
}
