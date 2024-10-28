import 'package:flutter/material.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

class CrossPainter extends CustomPainter {
  Path path = SvgAnimtionConstants.crossPath;
  Rect pathBounds = SvgAnimtionConstants.crossPath.getBounds();
  final bool showGlowAndOutline;
  late double height;
  late double width;
  final double outlineOpacity;
  final double outlineBlur;
  final Color glowColor;
  ColorsAndStops crossGradient;

  CrossPainter({
    required this.outlineBlur,
    required this.glowColor,
    required this.crossGradient,
    required this.showGlowAndOutline,
    required this.outlineOpacity,
  });

  paintCross(Canvas canvas, Size size) {
    height = pathBounds.height;
    width = pathBounds.width;
    final dx = (size.width - width) / 2 - pathBounds.left;
    final dy = (size.height - height) / 2 - pathBounds.top;

    canvas.translate(dx, dy);

    final crossPaint = Paint()
      ..shader = RadialGradient(
        radius: 1.4,
        colors: crossGradient.colors,
        stops: crossGradient.stops,
      ).createShader(
        pathBounds,
      );

    final crossOutline = Paint()
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke
      ..color = glowColor.withOpacity(outlineOpacity);

    final crossGlow = Paint()
      ..strokeWidth = 2.0
      ..color = glowColor.withOpacity(outlineOpacity)
      ..style = PaintingStyle.stroke
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, outlineBlur);
    if (showGlowAndOutline) {
      canvas.drawPath(path, crossGlow);
    }
    canvas.drawPath(path, crossPaint);
    if (showGlowAndOutline) {
      canvas.drawPath(path, crossOutline);
    }
    canvas.translate(-dx, -dy);
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintCross(canvas, size);
  }

  @override
  bool shouldRepaint(oldDelegate) => true;
}
