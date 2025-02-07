import 'package:nokhte_backend/tables/documents.dart';

mixin DocumentUtils {
  DocumentType mapStringToDocumentType(String role) {
    switch (role) {
      case 'ephemeral':
        return DocumentType.ephemeral;
      case 'evergreen':
        return DocumentType.evergreen;
      default:
        return DocumentType.none;
    }
  }

  String mapDocumentTypeToString(DocumentType type) {
    switch (type) {
      case DocumentType.ephemeral:
        return 'ephemeral';
      case DocumentType.evergreen:
        return 'evergreen';
      default:
        return 'none';
    }
  }
}
