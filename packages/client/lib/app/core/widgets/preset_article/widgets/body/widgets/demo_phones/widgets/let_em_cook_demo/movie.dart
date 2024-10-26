import 'package:flutter/material.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/widgets/widgets.dart';
import 'package:simple_animations/simple_animations.dart';

MovieTween letEmCook = TwoSecondBeachTransitionMovie.getMovie(
        TwoSecondBeachTransitionMovie.getMovie(
          TwoSecondBeachTransitionMovie.getMovie(
            MovieTween(),
            WaterColorsAndStops.condensedDrySand,
            WaterColorsAndStops.halfWaterAndSand,
            start: Seconds.get(11, milli: 500),
            end: Seconds.get(13, milli: 500),
            prefix: 'l',
          ),
          prefix: 'l',
          WaterColorsAndStops.halfWaterAndSand,
          WaterColorsAndStops.condensedDrySand,
          start: Seconds.get(2),
          end: Seconds.get(4),
        ),
        prefix: 'r',
        WaterColorsAndStops.halfWaterAndSand,
        WaterColorsAndStops.halfWaterAndSand,
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
              'p2Text',
              Tween<double>(
                begin: 0,
                end: 1,
              ),
            )
        ..scene(
          begin: Seconds.get(4),
          end: Seconds.get(5),
        )
            .tween(
              'glowStroke',
              Tween<double>(
                begin: 0,
                end: 5,
              ),
            )
            .tween(
              'glowColor',
              ColorTween(
                begin: BorderGlowConstants.transparentGreen,
                end: BorderGlowConstants.greenGlowColor,
              ),
            )
        ..scene(
          begin: Seconds.get(7),
          end: Seconds.get(8),
        )
            .tween(
              'glowColor',
              ColorTween(
                begin: BorderGlowConstants.greenGlowColor,
                end: BorderGlowConstants.yellowGlowColor,
              ),
            )
            .tween(
              'cookOpacity',
              Tween<double>(
                begin: 0,
                end: 1,
              ),
            )
        ..scene(
          begin: Seconds.get(9),
          end: Seconds.get(10),
        )
            .tween(
              'glowColor',
              ColorTween(
                begin: BorderGlowConstants.yellowGlowColor,
                end: BorderGlowConstants.greenGlowColor,
              ),
            )
            .tween(
              'cookOpacity',
              Tween<double>(
                begin: 1,
                end: 0,
              ),
            )
            .tween(
              'checkMarkCapacity',
              Tween<double>(
                begin: 0,
                end: 1,
              ),
            )
        ..scene(
          begin: Seconds.get(10),
          end: Seconds.get(10, milli: 250),
        ).tween(
          'l1',
          Tween<double>(
            begin: 0,
            end: 1,
          ),
        )
        ..scene(
          begin: Seconds.get(10, milli: 250),
          end: Seconds.get(10, milli: 500),
        ).tween(
          'l2',
          Tween<double>(
            begin: 0,
            end: 1,
          ),
        )
        ..scene(
          begin: Seconds.get(10, milli: 500),
          end: Seconds.get(11, milli: 500),
        ).tween(
          'checkMarkCapacity',
          Tween<double>(
            begin: 1,
            end: 0,
          ),
        )
        ..scene(
          begin: Seconds.get(11, milli: 500),
          end: Seconds.get(12, milli: 500),
        )
            .tween(
              'glowStroke',
              Tween<double>(
                begin: 5,
                end: 0,
              ),
            )
            .tween(
              'glowColor',
              ColorTween(
                begin: BorderGlowConstants.greenGlowColor,
                end: BorderGlowConstants.transparentGreen,
              ),
            )
            .tween(
              'p2Text',
              Tween<double>(
                begin: 1,
                end: 0,
              ),
            )
        ..scene(
          begin: Seconds.get(13, milli: 500),
          end: Seconds.get(14, milli: 500),
        ).tween(
          'p1Text',
          Tween<double>(
            begin: 0,
            end: 1,
          ),
        );