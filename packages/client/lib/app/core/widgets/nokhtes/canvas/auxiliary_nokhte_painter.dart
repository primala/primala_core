import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

class AuxiliaryNokhtePainter extends CustomPainter {
  final Offset offsets;
  final double radius;
  final List<Color> colors;
  final List<double> stops;
  final bool textOnTop;
  final String text;
  final double textOpacity;
  final AuxiliaryNokhteColorways colorway;
  Path path = SvgAnimtionConstants.crossPath;
  Rect pathBounds = SvgAnimtionConstants.crossPath.getBounds();
  late double height;
  late double width;

  AuxiliaryNokhtePainter({
    required this.offsets,
    required this.radius,
    required this.colorway,
    required this.text,
    required this.colors,
    required this.stops,
    required this.textOpacity,
    required this.textOnTop,
  });

  paintText(Canvas canvas, Offset center) {
    final textSpan = TextSpan(
      text: text,
      style: GoogleFonts.jost(
        fontSize: 20,
        color: Colors.white.withOpacity(textOpacity),
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: double.infinity,
    );
    textPainter.paint(
        canvas,
        Offset(
          center.dx - textPainter.width / 2,
          (center.dy - textPainter.height / 2) +
              (textOnTop
                  ? -textPainter.height * 1.5
                  : textPainter.height * 1.5),
        ));
  }

  @override
  void paint(Canvas canvas, Size size) {
    height = pathBounds.height;
    width = pathBounds.width;

    final center = Offset(
      offsets.dx,
      offsets.dy,
    );

    final rect = Rect.fromCircle(center: center, radius: radius);

    Paint paint = Paint();
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withOpacity(colors.first.opacity);
    if (colorway == AuxiliaryNokhteColorways.informationTint) {
      paint = Paint()..color = Colors.black.withOpacity(textOpacity / 2);

      //
    } else {
      paint = Paint()
        ..shader = LinearGradient(
          colors: colors,
          stops: stops,
          end: Alignment.bottomCenter,
        ).createShader(rect);
    }
    paintText(canvas, center);
    rotate(canvas, center.dx, center.dy, 0.785398);
    canvas.drawCircle(center, radius, paint);
    if (colorway == AuxiliaryNokhteColorways.informationTint) {
      rotate(canvas, center.dx, center.dy, -0.785398);
      canvas.drawCircle(center, radius, strokePaint);
      final textSpan = TextSpan(
        text: 'i',
        style: GoogleFonts.averiaSerifLibre(
          fontSize: 25,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w300,
          color: Colors.white.withOpacity(textOpacity),
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: double.infinity,
      );
      textPainter.paint(
          canvas,
          Offset(
            center.dx - textPainter.width / 2,
            (center.dy - textPainter.height / 2),
          ));
    }
  }

  void rotate(Canvas canvas, double cx, double cy, double angle) {
    canvas.translate(cx, cy);
    canvas.rotate(angle);
    canvas.translate(-cx, -cy);
  }

  @override
  bool shouldRepaint(oldDelegate) => true;
}
