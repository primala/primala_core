import 'package:flutter/material.dart';
import 'package:primala/app/core/breathing_pentagons_stack/presentation/widgets/breathing_pentagons_button/canvas/pentagon_colors.dart';

class PentagonData {
  static double get radiusConstant => .01;
  static Paint getPentagon1Paint(
    double centerX,
    double centerY,
    double radius,
  ) {
    final Paint paint1 = Paint()
      ..style = PaintingStyle.fill
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: radius,
        colors: PentagonColors.firstPentagonRadGradient,
      ).createShader(
        Rect.fromCircle(
          center: Offset(
            centerX * radiusConstant,
            centerY * radiusConstant,
          ),
          radius: radius,
        ),
      );
    return paint1;
  }

  static Paint getPentagon2Paint(
    double centerX,
    double centerY,
    double radius,
  ) {
    final Paint paint2 = Paint()
      ..style = PaintingStyle.fill
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: radius,
        colors: PentagonColors.secondPentagonRadGradient,
      ).createShader(
        Rect.fromCircle(
          center: Offset(
            centerX * radiusConstant,
            centerY * radiusConstant,
          ),
          radius: radius,
        ),
      );
    return paint2;
  }

  static Paint getPentagon3Paint(
    double centerX,
    double centerY,
    double radius,
  ) {
    final Paint paint3 = Paint()
      ..style = PaintingStyle.fill
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: radius,
        colors: PentagonColors.thirdPentagonRadGradient,
      ).createShader(
        Rect.fromCircle(
          center: Offset(
            centerX * radiusConstant,
            centerY * radiusConstant,
          ),
          radius: radius,
        ),
      );
    return paint3;
  }

  static double get pentagon1Angle => -0.3;
  static double get pentagon2Angle => 1.35;
  static double get pentagon3Angle => 1.75;
}
