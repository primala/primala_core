import 'package:flutter/material.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte_backend/tables/session_content.dart';
import 'package:simple_animations/simple_animations.dart';

mixin BlockTextFieldMovies {
  MovieTween getTextFieldTransition(
    ContentBlockType startingBlockType,
    ContentBlockType endingBlockType,
  ) {
    final grad1 = getGradient(startingBlockType);
    final grad2 = getGradient(endingBlockType);

    final iconGrad1 = getGradient(startingBlockType, isIcon: true);
    final iconGrad2 = getGradient(endingBlockType, isIcon: true);

    return MovieTween()
      ..scene(
        begin: Seconds.get(0),
        end: Seconds.get(1),
      )
          .tween(
            'c1',
            ColorTween(
              begin: grad1[0].color,
              end: grad2[0].color,
            ),
          )
          .tween(
            'c2',
            ColorTween(
              begin: grad1[1].color,
              end: grad2[1].color,
            ),
          )
          .tween(
            'ic1',
            ColorTween(
              begin: iconGrad1[0].color,
              end: iconGrad2[0].color,
            ),
          )
          .tween(
            'ic2',
            ColorTween(
              begin: iconGrad1[1].color,
              end: iconGrad2[1].color,
            ),
          )
          .tween(
            's1',
            Tween<double>(
              begin: grad1[0].stop,
              end: grad2[0].stop,
            ),
          )
          .tween(
            's2',
            Tween<double>(
              begin: grad1[1].stop,
              end: grad2[1].stop,
            ),
          );
  }

  MovieTween getRestingIcons(
    List<ContentBlockType> currentList,
  ) {
    final blocks = currentList.toList();
    final movie = MovieTween();

    for (int i = 0; i < blocks.length; i++) {
      final block = blocks[i];

      if (i == blocks.length) {
        movie
            .scene(
              begin: Seconds.get(0),
              end: Seconds.get(0, milli: 1),
            )
            .tween(
              '${block.name}_bottom_position',
              Tween<double>(
                begin: 0,
                end: 0,
              ),
            );
      } else {
        movie
            .scene(
              begin: Seconds.get(0),
              end: Seconds.get(0, milli: 1),
            )
            .tween(
              '${block.name}_bottom_position',
              Tween<double>(
                begin: 5.0 * (i < 2 ? i + 1 : 1),
                end: 5.0,
              ),
            );
      }
    }

    return movie;
  }

  MovieTween getExpandingIcons(
    List<ContentBlockType> currentList,
  ) {
    final movie = MovieTween();
    final startingPositions = getRestingPositions(currentList);

    for (int i = 0; i < currentList.length; i++) {
      final item = currentList[i];
      movie
          .scene(
            begin: Seconds.get(0),
            end: Seconds.get(
              0,
              milli: 300,
            ),
          )
          .tween(
            '${item.name}_bottom_position',
            Tween<double>(
              begin: startingPositions[i],
              end: (currentList.length - 1 - i) * 49.0,
            ),
          );
    }

    return movie;
    //
  }

  static List<double> getRestingPositions(
    List<ContentBlockType> currentList,
  ) {
    final blocks = currentList.toList();
    final positions = <double>[];
    for (int i = 0; i < blocks.length; i++) {
      if (i == blocks.length - 1) {
        positions.add(0);
      } else {
        positions.add(0);
      }
    }
    return positions;
  }

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
}
