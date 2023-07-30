/// infinite_spinner.dart
///
/// Proofreading Information:
/// - Proofreader: Sonny Vesali
/// - Date: July 30th, 2023
///
/// Author: Sonny Vesali
///
/// The InfiniteSpinner class provides a static [MovieTween] called movie
/// that represents the animation of an infinite spinner for the
/// BreathingPentagonsButton widget.
///
/// This animation involves rotating the pentagons indefinitely, resting on the
/// final color for the first six seconds, and then repeating the rotation for
/// the subsequent duration.

import 'package:flutter/material.dart';
import 'package:primala/app/core/breathing_pentagons_stack/constants/pentagon_colors.dart';
import 'package:simple_animations/simple_animations.dart';

class InfiniteSpinner {
  static MovieTween get movie => MovieTween()
    ..scene(
      begin: const Duration(seconds: 0),
      end: const Duration(seconds: 6),
    ).tween(
      'angle',
      Tween<double>(
        begin: 7.5,
        end: 8.75,
      ),
    )
    ..scene(
      begin: const Duration(seconds: 6),
      end: const Duration(seconds: 6),
    ).tween(
      'angle',
      Tween<double>(
        begin: 7.5,
        end: 7.5,
      ),
    )
    ..scene(
      begin: const Duration(seconds: 0),
      end: const Duration(seconds: 6),
    ).tween(
      'scale',
      Tween<double>(
        begin: .95,
        end: .95,
      ),
    )
    ..scene(
      begin: const Duration(seconds: 0),
      end: const Duration(seconds: 6),
    )
        .tween(
          '1st Pentagon > 1st Gradient Color',
          // turn to colors later
          ColorTween(
            begin: PentagonColors
                    .firstPentagonGradients[PentagonColors.fifthInterval]
                [PentagonColors.firstGradientColor],
            end: PentagonColors
                    .firstPentagonGradients[PentagonColors.fifthInterval]
                [PentagonColors.firstGradientColor],
          ),
        )
        .tween(
          '1st Pentagon > 2nd Gradient Color',
          ColorTween(
            begin: PentagonColors
                    .firstPentagonGradients[PentagonColors.fifthInterval]
                [PentagonColors.secondGradientColor],
            end: PentagonColors
                    .firstPentagonGradients[PentagonColors.fifthInterval]
                [PentagonColors.secondGradientColor],
          ),
        )
        .tween(
          '2nd Pentagon > 1st Gradient Color',
          // turn to colors later
          ColorTween(
            begin: PentagonColors
                    .secondPentagonGradients[PentagonColors.fifthInterval]
                [PentagonColors.firstGradientColor],
            end: PentagonColors
                    .secondPentagonGradients[PentagonColors.fifthInterval]
                [PentagonColors.firstGradientColor],
          ),
        )
        .tween(
          '2nd Pentagon > 2nd Gradient Color',
          ColorTween(
            begin: PentagonColors
                    .secondPentagonGradients[PentagonColors.fifthInterval]
                [PentagonColors.secondGradientColor],
            end: PentagonColors
                    .secondPentagonGradients[PentagonColors.fifthInterval]
                [PentagonColors.secondGradientColor],
          ),
        )
        .tween(
          '3rd Pentagon > 1st Gradient Color',
          // turn to colors later
          ColorTween(
            begin: PentagonColors
                    .thirdPentagonGradients[PentagonColors.fifthInterval]
                [PentagonColors.firstGradientColor],
            end: PentagonColors
                    .thirdPentagonGradients[PentagonColors.fifthInterval]
                [PentagonColors.firstGradientColor],
          ),
        )
        .tween(
          '3rd Pentagon > 2nd Gradient Color',
          ColorTween(
            begin: PentagonColors
                    .thirdPentagonGradients[PentagonColors.fifthInterval]
                [PentagonColors.secondGradientColor],
            end: PentagonColors
                    .thirdPentagonGradients[PentagonColors.fifthInterval]
                [PentagonColors.secondGradientColor],
          ),
        );
}
