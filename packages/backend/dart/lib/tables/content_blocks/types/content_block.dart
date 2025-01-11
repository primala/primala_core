import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/content_blocks.dart';

class ContentBlock extends Equatable with SessionContentConstants {
  final String content;
  final String uid;
  final ContentBlockType contentBlockType;
  final String? parentUID;

  ContentBlock({
    required this.content,
    required this.uid,
    required this.contentBlockType,
    required this.parentUID,
  });

  static List<ContentBlock> fromSupabase(List res) {
    List<ContentBlock> temp = [];
    for (var block in res) {
      temp.add(ContentBlock(
        content: block[SessionContentConstants.S_CONTENT],
        uid: block[SessionContentConstants.S_UID],
        contentBlockType: SessionContentUtils.mapStringToContentBlockType(
          block[SessionContentConstants.S_TYPE],
        ),
        parentUID: block[SessionContentConstants.S_PARENT_UID],
      ));
    }
    return temp;
  }

  @override
  List<Object> get props => [
        content,
        uid,
        contentBlockType,
        parentUID ?? '',
      ];
}
