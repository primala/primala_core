import 'package:flutter/material.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:simple_animations/simple_animations.dart';

class BlurMovie {
  static MovieTween getMovie({
    double blurValue = 10.0,
    Duration end = const Duration(seconds: 1),
  }) =>
      MovieTween()
        ..scene(
          begin: Seconds.get(0),
          end: end,
        ).tween(
          'blur',
          Tween<double>(
            begin: 0.0,
            end: blurValue,
          ),
        );
}
