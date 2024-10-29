import 'package:flutter/material.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:simple_animations/simple_animations.dart';

class CenterNokhteMovies {
  static MovieTween scale(ScreenSizeData screenSize, {bool reverse = false}) {
    final offsets = AuxiliaryNokhteUtils.getOffsets(
      screenSize,
      position: AuxiliaryNokhtePositions.center,
      direction: reverse ? NokhteScaleState.shrink : NokhteScaleState.enlarge,
    );
    return MovieTween()
      ..scene(
        begin: Seconds.get(0),
        end: Seconds.get(2),
      )
          .tween(
              'dx',
              Tween<double>(
                begin: offsets.start.dx,
                end: offsets.end.dx,
              ))
          .tween(
            'dy',
            Tween<double>(
              begin: offsets.start.dy,
              end: offsets.end.dy,
            ),
            curve: Curves.easeInOutCubicEmphasized,
          )
          .tween(
            'radii',
            Tween<double>(
              begin: reverse ? 25 : 4.5,
              end: reverse ? 4.5 : 25,
            ),
            curve: Curves.easeInOutCubicEmphasized,
          );
  }

  static MovieTween moveAround(
    ScreenSizeData screenSize, {
    required AuxiliaryNokhtePositions position,
  }) {
    final offsets = AuxiliaryNokhteUtils.getOffsets(
      screenSize,
      position: AuxiliaryNokhtePositions.center,
      direction: NokhteScaleState.enlarge,
    );

    Offset start = offsets.end;

    Offset end = AuxiliaryNokhteUtils.getOffsets(
      screenSize,
      position: position,
      direction: NokhteScaleState.enlarge,
    ).end;
    return MovieTween()
      ..scene(
        begin: Seconds.get(0),
        end: Seconds.get(2),
      )
          .tween(
            'dx',
            Tween<double>(
              begin: start.dx,
              end: end.dx,
            ),
            curve: Curves.easeInOutCubicEmphasized,
          )
          .tween(
            'dy',
            Tween<double>(
              begin: start.dy,
              end: end.dy,
            ),
            curve: Curves.easeInOutCubicEmphasized,
          )
          .tween(
            'radii',
            Tween<double>(
              begin: 25,
              end: 25,
            ),
            curve: Curves.easeInOutCubicEmphasized,
          );
  }
}
