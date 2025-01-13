import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/content_blocks.dart';
import 'package:nokhte_backend/tables/documents/documents.dart';
import 'package:nokhte_backend/types/types.dart';

class DocumentEntity extends Equatable {
  final int documentId;
  final int? parentDocumentId;
  final ContentBlockEntity spotlightContent;
  final DocumentType type;
  final String title;
  final DateTime? expirationDate;

  DocumentEntity({
    required this.documentId,
    required this.parentDocumentId,
    required this.spotlightContent,
    required this.type,
    required this.title,
    required this.expirationDate,
  });

  @override
  List<Object> get props => [
        documentId,
        parentDocumentId ?? -1,
        spotlightContent,
        type,
        title,
        expirationDate ?? const ConstDateTime.fromMillisecondsSinceEpoch(0),
      ];
}
