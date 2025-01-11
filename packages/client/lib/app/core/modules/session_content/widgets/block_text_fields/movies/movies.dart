import 'package:flutter/material.dart';
import 'package:nokhte/app/core/modules/session_content/widgets/widgets.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte_backend/tables/content_blocks.dart';
import 'package:simple_animations/simple_animations.dart';

mixin BlockTextFieldMovies {
  MovieTween getTextFieldTransition(
    ContentBlockType startingBlockType,
    ContentBlockType endingBlockType,
  ) {
    final grad1 = BlockTextConstants.getGradient(startingBlockType);
    final grad2 = BlockTextConstants.getGradient(endingBlockType);

    final iconGrad1 =
        BlockTextConstants.getGradient(startingBlockType, isIcon: true);
    final iconGrad2 =
        BlockTextConstants.getGradient(endingBlockType, isIcon: true);

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
}
