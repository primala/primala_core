import 'package:flutter/material.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

class BackButtonPainter extends CustomPainter {
  final Color overridedColor;
  Path path = SvgAnimtionConstants.backButtonPath;
  Rect pathBounds = SvgAnimtionConstants.backButtonPath.getBounds();

  BackButtonPainter({
    super.repaint,
    required this.overridedColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final arrowPath = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    if (overridedColor == Colors.transparent) {
      arrowPath.shader = const LinearGradient(
        colors: [
          Color(0xFF009EE1),
          Color(0xFF0078E6),
        ],
        stops: [
          0.0,
          1.0,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(
        pathBounds,
      );
    } else {
      arrowPath.color = overridedColor;
    }

    canvas.drawPath(path, arrowPath);
  }

  @override
  bool shouldRepaint(BackButtonPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BackButtonPainter oldDelegate) => false;
}
