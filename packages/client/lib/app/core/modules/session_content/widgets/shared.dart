import 'package:flutter/material.dart';
import 'package:nokhte_backend/tables/content_blocks.dart';
import 'package:equatable/equatable.dart';

class ColorAndStop extends Equatable {
  final Color color;
  final double stop;
  const ColorAndStop(this.color, this.stop);

  @override
  List<Object> get props => [color, stop];
}

mixin BlockTextConstants {
  static List<ColorAndStop> getGradient(
    ContentBlockType blockType, {
    bool isIcon = false,
  }) {
    switch (blockType) {
      case ContentBlockType.quotation:
        return isIcon
            ? const [
                ColorAndStop(Color(0xFF000000), 1),
                ColorAndStop(Color(0xFF000000), 1),
              ]
            : [
                const ColorAndStop(Color(0xFFFFFFFF), 0),
                const ColorAndStop(Color(0xFF000000), 1),
              ];
      case ContentBlockType.question:
        return [
          const ColorAndStop(Color(0xFFFF68E1), 0),
          const ColorAndStop(Color(0xFFFFBB68), 1),
        ];

      case ContentBlockType.idea:
        return [
          const ColorAndStop(Color(0xFF4AC0FF), 0),
          const ColorAndStop(Color(0xFF56F3A7), 1),
        ];
      case ContentBlockType.purpose:
        return [
          const ColorAndStop(Color(0xFF5A8BFF), 0),
          const ColorAndStop(Color(0xFFAD87FF), 1),
        ];
      case ContentBlockType.conclusion:
        return [
          const ColorAndStop(Color(0xFFFF5A5D), 0),
          const ColorAndStop(Color(0xFFFF87C7), 1),
        ];
      case ContentBlockType.none:
        return [];
    }
  }

  static String getAssetPath(ContentBlockType type) {
    return 'assets/blocks/${type.name}_icon.png';
  }

  static const whiteSpace = '      ';
}
