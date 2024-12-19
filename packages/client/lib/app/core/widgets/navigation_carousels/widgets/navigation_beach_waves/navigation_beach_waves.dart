import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:simple_animations/simple_animations.dart';

class NavigationBeachWaves extends HookWidget with ArticleBodyUtils {
  final double currentPosition;
  final Movie movie;
  final List<GradientConfig> gradients;

  const NavigationBeachWaves({
    super.key,
    required this.currentPosition,
    required this.movie,
    required this.gradients,
  });

  _processGradients(List<GradientConfig> gradients) {
    final currentAnimationValues = GetCurrentWaterAnimation.values(movie);

    return gradients.map((gradient) {
      if (gradient == GradientConfig.empty()) {
        // Use animation values to create a dynamic gradient config
        return ColorAndStop.toGradientConfig(
          [
            ColorAndStop(
              currentAnimationValues[1],
              currentAnimationValues[9],
            ),
            ColorAndStop(
              currentAnimationValues[2],
              currentAnimationValues[10],
            ),
            ColorAndStop(
              currentAnimationValues[3],
              currentAnimationValues[11],
            ),
            ColorAndStop(
              currentAnimationValues[4],
              currentAnimationValues[12],
            ),
            ColorAndStop(
              currentAnimationValues[5],
              currentAnimationValues[13],
            ),
            ColorAndStop(
              currentAnimationValues[6],
              currentAnimationValues[14],
            ),
            ColorAndStop(
              currentAnimationValues[7],
              currentAnimationValues[15],
            ),
            ColorAndStop(
              currentAnimationValues[8],
              currentAnimationValues[16],
            ),
          ],
        );
      }
      return gradient;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final currentAnimationValues = GetCurrentWaterAnimation.values(movie);

    return FullScreen(
      child: CustomPaint(
        painter: StepwiseBeachWavesPainter(
          scrollPercentage: interpolate(
            currentValue: currentPosition,
            targetValue: 1,
            maxOutput: 0,
            minOutput: 1,
          ),
          transitionValue: currentPosition,
          gradientConfigs: _processGradients(gradients),
          waterValue: currentAnimationValues.first,
        ),
      ),
    );
  }
}
