import 'package:flutter/material.dart';

class BackButtonPainter extends CustomPainter {
  final Color color;

  BackButtonPainter({
    this.color = Colors.white,
    super.repaint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Calculate points for the two lines
    // Using 1/3 padding from left and right edges
    final leftPadding = size.width * 0.33;
    final rightPadding = size.width * 0.33;
    final verticalPadding = size.height * 0.25;

    // First line (top)
    canvas.drawLine(
      Offset(size.width - rightPadding, verticalPadding),
      Offset(leftPadding, size.height / 2),
      paint,
    );

    // Second line (bottom)
    canvas.drawLine(
      Offset(leftPadding, size.height / 2),
      Offset(size.width - rightPadding, size.height - verticalPadding),
      paint,
    );
  }

  @override
  bool shouldRepaint(BackButtonPainter oldDelegate) =>
      oldDelegate.color != color;

  @override
  bool shouldRebuildSemantics(BackButtonPainter oldDelegate) => false;
}
