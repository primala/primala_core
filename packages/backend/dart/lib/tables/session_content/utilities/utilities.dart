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

      default:
        return 'None';
    }
  }

  static bool areContentListsEqual(
      SessionContentList list1, SessionContentList list2) {
    if (list1.length != list2.length) return false;

    for (int i = 0; i < list1.length; i++) {
      if (list1[i].uid != list2[i].uid ||
          list1[i].content != list2[i].content ||
          list1[i].blockType != list2[i].blockType) {
        return false;
      }
    }
    return true;
  }
}
