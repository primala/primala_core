import 'package:flutter/material.dart';
import 'package:nokhte_backend/tables/content_blocks.dart';

mixin BlockTextConstants {
  static LinearGradient getGradient(
    ContentBlockType blockType, {
    bool isIcon = false,
  }) {
    switch (blockType) {
      case ContentBlockType.quotation:
        return LinearGradient(
          colors: isIcon
              ? const [
                  Color(0xFF000000),
                  Color(0xFF000000),
                ]
              : const [
                  Color(0xFF6D6D6D),
                  Color(0xFF000000),
                ],
          stops: isIcon ? const [1, 1] : const [0, 1],
        );

      case ContentBlockType.question:
        return const LinearGradient(
          colors: [
            Color(0xFFFF68E1),
            Color(0xFFFFBB68),
          ],
          stops: [0, 1],
        );

      case ContentBlockType.idea:
        return const LinearGradient(
          colors: [
            Color(0xFF4AC0FF),
            Color(0xFF56F3A7),
          ],
          stops: [0, 1],
        );

      case ContentBlockType.purpose:
        return const LinearGradient(
          colors: [
            Color(0xFF5A8BFF),
            Color(0xFFAD87FF),
          ],
          stops: [0, 1],
        );

      case ContentBlockType.conclusion:
        return const LinearGradient(
          colors: [
            Color(0xFFFF5A5D),
            Color(0xFFFF87C7),
          ],
          stops: [0, 1],
        );

      case ContentBlockType.none:
        return const LinearGradient(
          colors: [],
          stops: [],
        );
    }
  }

  static String getName(ContentBlockType type) {
    switch (type) {
      case ContentBlockType.quotation:
        return 'Quote';
      case ContentBlockType.question:
        return 'Question';
      case ContentBlockType.idea:
        return 'Idea';
      case ContentBlockType.purpose:
        return 'Purpose';
      case ContentBlockType.conclusion:
        return 'Conclusion';
      case ContentBlockType.none:
        return '';
    }
  }

  static String getAssetPath(ContentBlockType type) {
    return 'assets/blocks/${type.name}_icon.png';
  }

  static const whiteSpace = '      ';
}
