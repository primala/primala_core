import 'package:nokhte_backend/tables/session_content.dart';

mixin SessionContentUtils {
  static ContentBlockType mapStringToContentBlockType(String type) {
    switch (type) {
      case 'question':
        return ContentBlockType.question;
      case 'idea':
        return ContentBlockType.idea;
      case 'purpose':
        return ContentBlockType.purpose;
      case 'conclusion':
        return ContentBlockType.conclusion;
      case 'quotation':
        return ContentBlockType.quotation;

      default:
        return ContentBlockType.none;
    }
  }

  static String mapContentBlockTypeToString(ContentBlockType type) {
    switch (type) {
      case ContentBlockType.question:
        return 'question';
      case ContentBlockType.idea:
        return 'idea';
      case ContentBlockType.purpose:
        return 'purpose';
      case ContentBlockType.conclusion:
        return 'conclusion';
      case ContentBlockType.quotation:
        return 'quotation';

      default:
        return 'none';
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
