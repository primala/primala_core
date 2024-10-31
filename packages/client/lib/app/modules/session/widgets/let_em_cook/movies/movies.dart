import 'package:flutter/material.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:simple_animations/simple_animations.dart';

class CheckmarkMovies {
  static MovieTween get movie => MovieTween()
    ..scene(
      begin: Seconds.get(0),
      end: Seconds.get(1),
    ).tween(
      'opacity',
      Tween<double>(
        begin: 0,
        end: 1,
      ),
    )
    ..scene(
      begin: Seconds.get(1),
      end: Seconds.get(1, milli: 250),
    ).tween(
      'l1',
      Tween<double>(
        begin: 0,
        end: 1,
      ),
    )
    ..scene(
      begin: Seconds.get(1, milli: 250),
      end: Seconds.get(1, milli: 500),
    ).tween(
      'l2',
      Tween<double>(
        begin: 0,
        end: 1,
      ),
    )
    ..scene(
      begin: Seconds.get(1, milli: 500),
      end: Seconds.get(2, milli: 500),
    ).tween(
      'opacity',
      Tween<double>(
        begin: 1,
        end: 0,
      ),
    );
}
