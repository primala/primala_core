import 'package:flutter/material.dart';
import 'package:nokhte/app/core/extensions/extensions.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

class StepwiseBeachWavesPainter extends CustomPainter {
  final double transitionValue;
  final List<GradientConfig> gradientConfigs;
  final double waterValue;
  final double scrollPercentage;
  final int waveCount;
  final double waveAmplitude;
  final bool shouldPaintAdditional;
  final void Function(Canvas canvas, Size size)? additionalPainter;

  StepwiseBeachWavesPainter({
    required this.waterValue,
    required this.transitionValue,
    required this.gradientConfigs,
    required this.scrollPercentage,
    this.waveCount = 3,
    this.waveAmplitude = 20.0,
    this.shouldPaintAdditional = false,
    this.additionalPainter,
  }) : assert(gradientConfigs.length >= 2,
            'At least two gradient configurations are required');

  GradientConfig _interpolateGradientConfigs() {
    final double normalizedTransition =
        transitionValue.clamp(0.0, gradientConfigs.length - 1.0);

    final int currentIndex = normalizedTransition.floor();
    final int nextIndex =
        (currentIndex + 1).clamp(0, gradientConfigs.length - 1);

    final double localTransition = normalizedTransition - currentIndex;

    final List<Color> interpolatedColors = List.generate(
        gradientConfigs[currentIndex].colors.length,
        (i) => Color.lerp(gradientConfigs[currentIndex].colors[i],
            gradientConfigs[nextIndex].colors[i], localTransition)!);

    final List<double> interpolatedStops = List.generate(
        gradientConfigs[currentIndex].stops.length,
        (i) => lerpDouble(gradientConfigs[currentIndex].stops[i],
            gradientConfigs[nextIndex].stops[i], localTransition));

    return GradientConfig(colors: interpolatedColors, stops: interpolatedStops);
  }

  double lerpDouble(double start, double end, double t) {
    return start + (end - start) * t;
  }

  paintSand(Canvas canvas, Size size, SandTypes sandType) {
    final sandGrandient = Paint();
    List<Color> colors = [];
    List<double> stops = [];
    switch (sandType) {
      case SandTypes.home:
        colors = const [
          Color(0xFFD2B48C),
          Color(0xFF8B5E3C),
        ];
        stops = [0, .3];
      case SandTypes.collaboration:
        colors = const [
          Color(0xFFFFE6C4),
          Color(0xFFFFBC78),
        ];
        stops = [0, .2];
    }
    sandGrandient.shader = LinearGradient(
      colors: colors,
      stops: stops,
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    // break;
    canvas.drawRect(Offset.zero & size, sandGrandient);
  }

  paintWater(Canvas canvas, Size size) {
    const waveCount = 3;
    const waveAmplitude = 20.0;

    final interpolatedConfig = _interpolateGradientConfigs();
    final waveGradient = LinearGradient(
      colors: interpolatedConfig.colors,
      stops: interpolatedConfig.stops,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    final waterPaint = Paint()
      ..shader = waveGradient
          .createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final phase = waterValue + (scrollPercentage * 100);

    for (int i = 0; i < waveCount; i++) {
      final waveOffset = size.height / (waveCount + 1) * (i + 1);
      final yOffset = phase * 3;
      final path = Path()
        ..moveTo(0, waveOffset + yOffset)
        ..cubicTo(
          size.width / 3,
          waveOffset + yOffset - waveAmplitude.half(),
          2 * size.width / 3,
          waveOffset + yOffset + waveAmplitude.half(),
          size.width,
          waveOffset + yOffset,
        )
        ..lineTo(size.width, 0)
        ..lineTo(0, 0)
        ..close();
      canvas.drawPath(path, waterPaint);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (shouldPaintAdditional && additionalPainter != null) {
      additionalPainter!(canvas, size);
    }
    paintSand(canvas, size, SandTypes.home);

    paintWater(canvas, size);
  }

  @override
  bool shouldRepaint(StepwiseBeachWavesPainter oldDelegate) {
    return oldDelegate.transitionValue != transitionValue ||
        oldDelegate.gradientConfigs != gradientConfigs ||
        oldDelegate.scrollPercentage != scrollPercentage ||
        oldDelegate.waterValue != waterValue;
  }
}
