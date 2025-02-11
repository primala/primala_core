import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/documents.dart';

class UpdateDocumentTypeParams extends Equatable {
  final int documentId;
  final DocumentType type;

  UpdateDocumentTypeParams({
    required this.documentId,
    required this.type,
  });

  @override
  List<Object> get props => [documentId, type];
}
