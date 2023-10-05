import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class TopCircleColorChange {
  static MovieTween getMovie({
    required List<Color> firstGradientColors,
    required List<Color> secondGradientColors,
  }) {
    return MovieTween()
      ..scene(
              begin: const Duration(seconds: 0),
              end: const Duration(seconds: 2))
          .tween(
            'first gradient color',
            ColorTween(
              begin: const Color(0xFF0A98FF),
              end: const Color(0xFF0A98FF),
              // end: const Color(0xFFFFFFFF),
            ),
          )
          .tween(
            'second gradient color',
            ColorTween(
              begin: const Color(0x00FFFFFF),
              end: const Color(0x00FFFFFF),
              // end: const Color(0xFFFFFFFF),
            ),
          )
          .tween(
            'center circle constant',
            Tween<double>(
              begin: 27.0,
              end: 27.0,
            ),
          )
          .tween(
            'top circle color 1',
            ColorTween(
              begin: firstGradientColors[0],
              end: secondGradientColors[0],
            ),
          )
          .tween(
            'top circle color 2',
            ColorTween(
              begin: firstGradientColors[1],
              end: secondGradientColors[1],
            ),
          );
  }
}
