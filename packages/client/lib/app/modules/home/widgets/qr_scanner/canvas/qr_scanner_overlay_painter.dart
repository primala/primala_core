import 'package:flutter/material.dart';

class ScannerOverlay extends CustomPainter {
  const ScannerOverlay({
    required this.cutoutSize,
    required this.opacity,
  });

  final double cutoutSize;
  final double borderRadius = 30;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      (size.height / 2) - (size.height * 0.03),
    );
    final backgroundPath = Path()..addRect(Rect.largest);

    Rect cutOutRect = Rect.fromCircle(center: center, radius: cutoutSize);

    final cutOutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          cutOutRect,
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      );

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(opacity / 2)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutOutPath,
    );

    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final borderRect = RRect.fromRectAndCorners(
      cutOutRect,
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
    );

    canvas.drawPath(backgroundWithCutout, backgroundPaint);
    canvas.drawRRect(borderRect, borderPaint);
  }

  @override
  bool shouldRepaint(ScannerOverlay oldDelegate) => true;
}
