import 'package:flutter/material.dart';
import 'dart:ui';
import 'painter_utils.dart';

class VanillaTogglePainter extends CustomPainter with TogglePainterUtils {
  final double toggleVal;

  VanillaTogglePainter({
    super.repaint,
    required this.toggleVal,
  });

  @override
  void paint(Canvas canvas, Size size) {
    paintToggle(
      canvas,
      size,
      toggleVal,
      circleOpacity: lerpDouble(0.5, 1.0, toggleVal)!,
    );
  }

  @override
  bool shouldRepaint(VanillaTogglePainter oldDelegate) {
    return oldDelegate.toggleVal != toggleVal;
  }

  @override
  bool shouldRebuildSemantics(VanillaTogglePainter oldDelegate) => false;
}
