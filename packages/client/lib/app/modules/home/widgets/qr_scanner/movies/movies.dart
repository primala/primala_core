import 'package:flutter/material.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:simple_animations/simple_animations.dart';

class OpacityMovies {
  static MovieTween get fadeIn => MovieTween()
    ..scene(
      begin: Seconds.get(0),
      end: Seconds.get(1),
    ).tween(
        'o',
        Tween<double>(
          begin: 0.0,
          end: 1.0,
        ));
  static MovieTween get fadeOut => MovieTween()
    ..scene(
      begin: Seconds.get(0),
      end: Seconds.get(1),
    ).tween(
        'o',
        Tween<double>(
          begin: 1.0,
          end: 0.0,
        ));
}
