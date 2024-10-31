import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'painter_utils.dart';

class GlyphTogglePainter extends CustomPainter with TogglePainterUtils {
  final double toggleVal;
  final String leftGlyph;
  final String rightGlyph;

  GlyphTogglePainter({
    required this.toggleVal,
    required this.leftGlyph,
    required this.rightGlyph,
    super.repaint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    paintToggle(canvas, size, toggleVal);

    final textOpacity = vShapedLerp(toggleVal);

    final circleRadius = getCircleRadius(size);

    final circlePosition = getCirclePosition(size, toggleVal);

    final textStyle = GoogleFonts.jost(
      color: const Color(0xFF76CEF7).withOpacity(textOpacity),
      fontSize: circleRadius + 5,
      fontWeight: FontWeight.w400,
    );

    final glyph = toggleVal < 0.5 ? leftGlyph : rightGlyph;

    final textPainter = TextPainter(
      text: TextSpan(text: glyph, style: textStyle),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();

    final textOffset = Offset(
      circlePosition.dx - textPainter.width / 2,
      circlePosition.dy - textPainter.height / 2,
    );

    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(GlyphTogglePainter oldDelegate) {
    return oldDelegate.toggleVal != toggleVal ||
        oldDelegate.leftGlyph != leftGlyph ||
        oldDelegate.rightGlyph != rightGlyph;
  }
}
