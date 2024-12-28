import 'package:nokhte_backend/tables/session_content.dart';

mixin SessionContentUtils {
  static ContentBlockType mapStringToContentBlockType(String type) {
    switch (type) {
      case 'Question':
        return ContentBlockType.question;
      case 'Idea':
        return ContentBlockType.idea;
      case 'Purpose':
        return ContentBlockType.purpose;
      case 'Conclusion':
        return ContentBlockType.conclusion;
      case 'Quotation':
        return ContentBlockType.quotation;
      case 'Queue':
        return ContentBlockType.queue;
      default:
        return ContentBlockType.none;
    }
  }

  static String mapContentBlockTypeToString(ContentBlockType type) {
    switch (type) {
      case ContentBlockType.question:
        return 'Question';
      case ContentBlockType.idea:
        return 'Idea';
      case ContentBlockType.purpose:
        return 'Purpose';
      case ContentBlockType.conclusion:
        return 'Conclusion';
      case ContentBlockType.quotation:
        return 'Quotation';
      case ContentBlockType.queue:
        return 'Queue';
      default:
        return 'None';
    }
  }
}
