import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class FadeInText {
  static MovieTween get movie => MovieTween()
    ..scene(
      begin: const Duration(seconds: 0),
      end: const Duration(seconds: 1),
    )
        .tween(
          'text opacity',
          Tween<double>(begin: 0, end: 0),
        )
        .tween(
          'text color',
          ColorTween(
            begin: Colors.white,
            end: Colors.white,
          ),
        )
    ..scene(
      begin: const Duration(seconds: 1),
      end: const Duration(seconds: 2),
    )
        .tween(
          'text opacity',
          Tween<double>(begin: 0, end: 1),
        )
        .tween(
          'text color',
          ColorTween(
            begin: Colors.white,
            end: Colors.white,
          ),
        );
}
