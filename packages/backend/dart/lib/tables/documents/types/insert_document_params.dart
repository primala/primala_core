import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/content_blocks.dart';
import 'package:nokhte_backend/tables/documents.dart';

class InsertDocumentParams extends Equatable {
  final int groupId;
  final DocumentType type;
  final String documentTitle;
  final ContentBlockType contentBlockType;
  final String spotlightMessage;

  InsertDocumentParams({
    required this.groupId,
    required this.contentBlockType,
    required this.spotlightMessage,
    required this.documentTitle,
    this.type = DocumentType.evergreen,
  });

  @override
  List<Object> get props => [
        groupId,
        documentTitle,
        contentBlockType,
        spotlightMessage,
        type,
      ];
}
