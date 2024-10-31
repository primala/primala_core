import 'package:flutter/material.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:simple_animations/movie_tween/movie_tween.dart';

class NotesDemoMovies {
  static MovieTween get multifocal => TwoSecondBeachTransitionMovie.getMovie(
        TwoSecondBeachTransitionMovie.getMovie(
          MovieTween(),
          WaterColorsAndStops.sky,
          WaterColorsAndStops.halfWaterAndSand,
          start: Seconds.get(8),
          end: Seconds.get(10),
          prefix: 'l',
        ),
        WaterColorsAndStops.halfWaterAndSand,
        WaterColorsAndStops.sky,
        start: Seconds.get(2),
        end: Seconds.get(4),
        prefix: 'l',
      )
        ..scene(
          begin: Seconds.get(2),
          end: Seconds.get(3),
        )
            .tween(
              'p1Text',
              Tween<double>(
                begin: 1,
                end: 0,
              ),
            )
            .tween(
              'p2AboveTextOpacity',
              Tween<double>(
                begin: 0,
                end: 1,
              ),
            )
        ..scene(
          begin: Seconds.get(4),
          end: Seconds.get(5),
        ).tween(
          'p2AboveTextProgress',
          Tween<double>(
            begin: 0,
            end: 1,
          ),
        )
        ..scene(
          begin: Seconds.get(5),
          end: Seconds.get(6),
        ).tween(
          'p2BelowText',
          Tween<double>(
            begin: 0,
            end: 1,
          ),
        )
        ..scene(
          begin: Seconds.get(8),
          end: Seconds.get(9),
        )
            .tween(
              'p2BelowText',
              Tween<double>(
                begin: 1,
                end: 0,
              ),
            )
            .tween(
              'p2AboveTextOpacity',
              Tween<double>(
                begin: 1,
                end: 0,
              ),
            )
        ..scene(
          begin: Seconds.get(10),
          end: Seconds.get(11),
        ).tween(
          'p1Text',
          Tween<double>(
            begin: 0,
            end: 1,
          ),
        );

  static MovieTween get monoFocal => TwoSecondBeachTransitionMovie.getMovie(
        multifocal,
        WaterColorsAndStops.halfWaterAndSand,
        WaterColorsAndStops.halfWaterAndSand,
        prefix: 'r',
      )
        ..scene(
          begin: Seconds.get(2),
          end: Seconds.get(3),
        ).tween(
          'p1Text',
          Tween<double>(
            begin: 1,
            end: 0,
          ),
        )
        ..scene(
          begin: Seconds.get(4),
          end: Seconds.get(5),
        ).tween(
          'p2AboveTextProgress',
          Tween<double>(
            begin: 0,
            end: 1,
          ),
        )
        ..scene(
          begin: Seconds.get(5),
          end: Seconds.get(6),
        ).tween(
          'p2BelowText',
          Tween<double>(
            begin: 0,
            end: 1,
          ),
        )
        ..scene(
          begin: Seconds.get(8),
          end: Seconds.get(9),
        )
            .tween(
              'p2BelowText',
              Tween<double>(
                begin: 1,
                end: 0,
              ),
            )
            .tween(
              'p2AboveTextOpacity',
              Tween<double>(
                begin: 1,
                end: 0,
              ),
            )
        ..scene(
          begin: Seconds.get(10),
          end: Seconds.get(11),
        ).tween(
          'p1Text',
          Tween<double>(
            begin: 0,
            end: 1,
          ),
        );
}
