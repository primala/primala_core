import 'package:flutter/material.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/modules/docs/docs.dart';
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
        end: Seconds.get(0, milli: 300),
      )
          .tween(
            'c1',
            ColorTween(
              begin: grad1.colors[0],
              end: grad2.colors[0],
            ),
          )
          .tween(
            'c2',
            ColorTween(
              begin: grad1.colors[1],
              end: grad2.colors[1],
            ),
          )
          .tween(
            'ic1',
            ColorTween(
              begin: iconGrad1.colors[0],
              end: iconGrad2.colors[0],
            ),
          )
          .tween(
            'ic2',
            ColorTween(
              begin: iconGrad1.colors[1],
              end: iconGrad2.colors[1],
            ),
          )
          .tween(
            's1',
            Tween<double>(
              begin: grad1.stops?[0] ?? 0.0,
              end: grad2.stops?[0] ?? 0.0,
            ),
          )
          .tween(
            's2',
            Tween<double>(
              begin: grad1.stops?[1] ?? 1.0,
              end: grad2.stops?[1] ?? 1.0,
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

      movie
          .scene(
            begin: Seconds.get(0),
            end: Seconds.get(0, milli: 1),
          )
          .tween(
            '${block.name}_bottom_position',
            Tween<double>(
              begin: i == blocks.length - 1 ? 0 : (5.0 * (i < 2 ? i + 1 : 1)),
              end: 5.0,
            ),
          );
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
            end: Seconds.get(0, milli: 300),
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
  }

  static List<double> getRestingPositions(
    List<ContentBlockType> currentList,
  ) {
    return List.filled(currentList.length, 0.0);
  }
}
