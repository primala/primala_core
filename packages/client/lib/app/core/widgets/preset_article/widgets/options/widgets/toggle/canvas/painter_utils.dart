import 'package:flutter/material.dart';

mixin TogglePainterUtils {
  Offset interpolateTogglePosition(double t, Offset left, Offset right) {
    return Offset(
      left.dx + (right.dx - left.dx) * t,
      left.dy + (right.dy - left.dy) * t,
    );
  }

  double vShapedLerp(double x) {
    if (x < 0) return 1;
    if (x > 1) return 1;

    if (x <= 0.5) {
      return 1.0 - (x * 2);
    } else {
      return (x - 0.5) * 2;
    }
  }

  getCircleRadius(Size size) => size.height * 0.4;

  getCirclePosition(Size size, double toggleVal) {
    final circleRadius = getCircleRadius(size);
    final centerLeft =
        Offset(circleRadius + size.width * 0.05, size.height / 2);
    final centerRight =
        Offset(size.width - circleRadius - size.width * 0.05, size.height / 2);

    return interpolateTogglePosition(toggleVal, centerLeft, centerRight);
  }

  void paintToggle(
    Canvas canvas,
    Size size,
    double toggleVal, {
    double circleOpacity = 1.0,
  }) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    const rectRadius = Radius.circular(30);
    final roundedRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      rectRadius,
    );

    canvas.drawRRect(roundedRect, paint);

    final circlePaint = Paint()
      ..color = Colors.white.withOpacity(circleOpacity);
    final circleRadius = getCircleRadius(size);

    final circlePosition = getCirclePosition(size, toggleVal);

    canvas.drawCircle(circlePosition, circleRadius, circlePaint);
  }
}
