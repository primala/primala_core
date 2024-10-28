import 'package:flutter/material.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:simple_animations/simple_animations.dart';

class AuxiliaryNokhteMovies {
  static MovieTween scale(
    ScreenSizeData screenSize, {
    required AuxiliaryNokhtePositions position,
    required AuxiliaryNokhteColorways colorway,
    required NokhteScaleState direction,
  }) {
    final offsets = AuxiliaryNokhteUtils.getOffsets(
      screenSize,
      position: position,
      direction: direction,
    );

    List<ColorAndStop> grad = AuxiliaryNokhteUtils.getGradient(colorway);
    return _gradTransition(grad, grad, MovieTween())
      ..scene(
        begin: Seconds.get(0),
        end: Seconds.get(1, milli: 500),
      )
          .tween(
            'dx',
            Tween<double>(
              begin: offsets.start.dx,
              end: offsets.end.dx,
            ),
            curve: Curves.easeInOutCubicEmphasized,
          )
          .tween(
            'dy',
            Tween<double>(
              begin: offsets.start.dy,
              end: offsets.end.dy,
            ),
            curve: Curves.easeInOutCubicEmphasized,
          )
          .tween(
            'radius',
            Tween<double>(
              begin: direction == NokhteScaleState.enlarge ? 4.5 : 25,
              end: direction == NokhteScaleState.enlarge ? 25 : 4.5,
            ),
          )
      ..scene(
        begin: direction == NokhteScaleState.enlarge
            ? Seconds.get(1, milli: 500)
            : Seconds.get(0),
        end: direction == NokhteScaleState.enlarge
            ? Seconds.get(2)
            : Seconds.get(0, milli: 500),
      ).tween(
          'textOpacity',
          Tween<double>(
            begin: direction == NokhteScaleState.enlarge ? 0 : 1,
            end: direction == NokhteScaleState.enlarge ? 1 : 0,
          ));
  }

  static MovieTween explode(
    ScreenSizeData screenSize, {
    required AuxiliaryNokhtePositions position,
    required AuxiliaryNokhteColorways colorway,
  }) {
    final offsets = AuxiliaryNokhteUtils.getOffsets(
      screenSize,
      position: position,
      direction: NokhteScaleState.enlarge,
    );

    final grad = AuxiliaryNokhteUtils.getGradient(colorway);
    final scaledGrad = _getScaledGradient(grad, colorway);

    return _staticPosition(
      offsets.end,
      _gradTransition(
        grad,
        scaledGrad,
        MovieTween(),
      ),
    )
      ..scene(
        begin: Seconds.get(0),
        end: Seconds.get(1, milli: 500),
      ).tween(
        'radius',
        Tween<double>(
          begin: 25,
          end: 800,
        ),
        curve: Curves.easeInOutCubicEmphasized,
      )
      ..scene(
        begin: Seconds.get(0),
        end: Seconds.get(0, milli: 500),
      ).tween(
        'textOpacity',
        Tween<double>(
          begin: 1,
          end: 0,
        ),
      );
  }

  static MovieTween disappear(
    ScreenSizeData screenSize, {
    required AuxiliaryNokhtePositions position,
    required AuxiliaryNokhteColorways colorway,
  }) {
    final offsets = AuxiliaryNokhteUtils.getOffsets(
      screenSize,
      position: position,
      direction: NokhteScaleState.enlarge,
    );

    List<ColorAndStop> grad = AuxiliaryNokhteUtils.getGradient(colorway);
    return _gradTransition(
        grad,
        List.generate(4, (i) {
          return ColorAndStop(
            Colors.transparent,
            grad[i].stop,
          );
        }),
        (_staticPosition(offsets.end, MovieTween())))
      ..scene(
        begin: Seconds.get(0),
        end: Seconds.get(1),
      )
          .tween(
            'radius',
            Tween<double>(
              begin: 25,
              end: 25,
            ),
            curve: Curves.easeInOutCubicEmphasized,
          )
          .tween(
            'textOpacity',
            Tween<double>(
              begin: 1,
              end: 0,
            ),
          );
  }

  static MovieTween fadeIn(
    ScreenSizeData screenSize, {
    required AuxiliaryNokhtePositions position,
    required AuxiliaryNokhteColorways colorway,
  }) {
    final offsets = AuxiliaryNokhteUtils.getOffsets(
      screenSize,
      position: position,
      direction: NokhteScaleState.enlarge,
    );

    List<ColorAndStop> grad = AuxiliaryNokhteUtils.getGradient(colorway);
    return _gradTransition(
      List.generate(4, (i) {
        return ColorAndStop(
          grad[i].color.withOpacity(0),
          grad[i].stop,
        );
      }),
      grad,
      (_staticPosition(offsets.start, MovieTween())),
      start: Seconds.get(0),
      end: Seconds.get(1),
    )..scene(
        begin: Seconds.get(0),
        end: Seconds.get(0, milli: 1),
      )
          .tween(
            'radius',
            Tween<double>(
              begin: 0,
              end: 4.5,
            ),
          )
          .tween(
            'textOpacity',
            Tween<double>(
              begin: 0,
              end: 0,
            ),
          );
  }

  static List<ColorAndStop> _getScaledGradient(
    List<ColorAndStop> grad,
    AuxiliaryNokhteColorways colorway,
  ) {
    if (colorway == AuxiliaryNokhteColorways.orangeSand) {
      return [
        ColorAndStop(grad[0].color, 0),
        ColorAndStop(grad[0].color, 0),
        ColorAndStop(grad[2].color, 0.12),
        ColorAndStop(grad[2].color, 0.12),
      ];
    } else if (colorway == AuxiliaryNokhteColorways.vibrantBlue ||
        colorway == AuxiliaryNokhteColorways.informationTint) {
      return const [
        ColorAndStop(Color(0xFF44D3FE), 0),
        ColorAndStop(Color(0xFF44D3FE), .3),
        ColorAndStop(Color(0xFF6BE9BB), 1.0),
        ColorAndStop(Color(0xFF6BE9BB), 1.0),
      ];
    } else if (colorway == AuxiliaryNokhteColorways.invertedBeachWave) {
      return [
        ColorAndStop(grad[2].color, grad[2].stop),
        ColorAndStop(grad[2].color, grad[2].stop),
        ColorAndStop(grad[3].color, grad[3].stop),
        ColorAndStop(grad[3].color, grad[3].stop),
      ];
    } else if (colorway == AuxiliaryNokhteColorways.beachWave) {
      return [
        ColorAndStop(grad[0].color, 1),
        ColorAndStop(grad[0].color, 1),
        ColorAndStop(grad[0].color, 1),
        ColorAndStop(grad[0].color, 1),
      ];
    } else if (colorway == AuxiliaryNokhteColorways.exitOrangeSand) {
      return [
        ColorAndStop(grad.first.color, 0),
        ColorAndStop(grad.first.color, 0),
        ColorAndStop(grad.last.color, 0.22),
        ColorAndStop(grad.last.color, 0.22),
      ];
    } else if (colorway == AuxiliaryNokhteColorways.exitVibrantBlue) {
      return const [
        ColorAndStop(Color(0xFF44D3FE), 0),
        ColorAndStop(Color(0xFF44D3FE), .3),
        ColorAndStop(Color(0xFF6BE9BB), .7),
        ColorAndStop(Color(0xFF6BE9BB), 1.0),
      ];
    } else if (colorway == AuxiliaryNokhteColorways.deeperBlue) {
      return const [
        ColorAndStop(Color(0xFF4072F3), 0),
        ColorAndStop(Color(0xFF4072F3), .15),
        ColorAndStop(Color(0xFF40F3F3), .85),
        ColorAndStop(Color(0xFF40F3F3), 1),
      ];
    } else {
      return [];
    }
    //
  }

  static MovieTween _staticPosition(Offset offset, MovieTween movie) => movie
    ..scene(
      begin: Seconds.get(0),
      end: Seconds.get(
        0,
        milli: 1,
      ),
    )
        .tween(
          'dx',
          Tween<double>(
            begin: offset.dx,
            end: offset.dx,
          ),
        )
        .tween(
          'dy',
          Tween<double>(
            begin: offset.dy,
            end: offset.dy,
          ),
        );
  static MovieTween _gradTransition(
    List<ColorAndStop> startingGrad,
    List<ColorAndStop> endingGrad,
    MovieTween movie, {
    Duration start = const Duration(milliseconds: 0),
    Duration end = const Duration(milliseconds: 500),
  }) =>
      movie
        ..scene(
          begin: start,
          end: end,
        )
            .tween(
              'color1',
              ColorTween(
                begin: startingGrad[0].color,
                end: endingGrad[0].color,
              ),
            )
            .tween(
              'color2',
              ColorTween(
                begin: startingGrad[1].color,
                end: endingGrad[1].color,
              ),
            )
            .tween(
              'color3',
              ColorTween(
                begin: startingGrad[2].color,
                end: endingGrad[2].color,
              ),
            )
            .tween(
              'color4',
              ColorTween(
                begin: startingGrad[3].color,
                end: endingGrad[3].color,
              ),
            )
            .tween(
              'stop1',
              Tween<double>(
                begin: startingGrad[0].stop,
                end: endingGrad[0].stop,
              ),
            )
            .tween(
              'stop2',
              Tween<double>(
                begin: startingGrad[1].stop,
                end: endingGrad[1].stop,
              ),
            )
            .tween(
              'stop3',
              Tween<double>(
                begin: startingGrad[2].stop,
                end: endingGrad[2].stop,
              ),
            )
            .tween(
              'stop4',
              Tween<double>(
                begin: startingGrad[3].stop,
                end: endingGrad[3].stop,
              ),
            );
}
