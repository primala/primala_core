import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/content_blocks.dart';
import 'package:nokhte_backend/tables/documents.dart';

typedef DocumentEntities = List<DocumentEntity>;

class DocumentEntity extends Equatable with DocumentConstants {
  final int documentId;
  final int? parentDocumentId;
  final ContentBlockEntity spotlightContent;
  final String title;

  DocumentEntity({
    required this.documentId,
    required this.parentDocumentId,
    required this.spotlightContent,
    required this.title,
  });

  @override
  List<Object> get props => [
        documentId,
        parentDocumentId ?? -1,
        spotlightContent,
        title,
      ];

  static DocumentEntity fromSupabase(Map<String, dynamic> doc) {
    return DocumentEntity(
      documentId: doc[DocumentConstants.S_ID],
      parentDocumentId: doc[DocumentConstants.S_PARENT_DOCUMENT_ID],
      spotlightContent: ContentBlockEntity.initial(),
      title: doc[DocumentConstants.S_TITLE],
    );
  }
}
