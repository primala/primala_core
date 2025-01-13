import 'package:equatable/equatable.dart';
import 'package:nokhte_backend/tables/documents.dart';

class InsertDocumentParams extends Equatable {
  final int groupId;
  final DocumentType type;
  final int? parentDocumentId;

  InsertDocumentParams({
    required this.groupId,
    required this.type,
    this.parentDocumentId,
  });

  @override
  List<Object> get props => [groupId, type, parentDocumentId ?? -1];
}
