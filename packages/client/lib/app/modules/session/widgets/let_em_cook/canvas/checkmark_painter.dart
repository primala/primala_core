import 'package:flutter/material.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte/app/modules/session/widgets/let_em_cook/let_em_cook.dart';

class CheckmarkPainter extends CustomPainter {
  final double l1Progress, l2Progress, opacity;

  CheckmarkPainter({
    super.repaint,
    required this.l1Progress,
    required this.l2Progress,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // First path gradient (first segment of the checkmark)
    var gradient1 = LinearGradient(
      colors: LetEmCookConstants.greenGrad(opacity),
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: const [0.5, 0.65],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    var paint1 = Paint()
      ..shader = gradient1
      ..style = PaintingStyle.stroke
      ..strokeWidth = (size.height * 0.08)
      ..strokeCap = StrokeCap.round;

    // Second path gradient (second segment of the checkmark)
    var gradient2 = LinearGradient(
      colors: LetEmCookConstants.greenGrad(opacity),
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      stops: const [0.4, 0.55],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    var paint2 = Paint()
      ..shader = gradient2
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.height * 0.08
      ..strokeCap = StrokeCap.round;

    // First path of the checkmark
    var path = Path()
      ..moveTo(size.height * 0.25, size.height * 0.5) // Starting point
      ..lineTo(size.width * 0.4, size.height * 0.7);

    // Second path of the checkmark
    var path1 = Path()
      ..moveTo(size.width * 0.4, size.height * 0.7)
      ..lineTo(size.width * 0.7, size.height * 0.3);

    // Animate the first path
    var pathMetric = path.computeMetrics().first;
    var animatedPath =
        pathMetric.extractPath(0, pathMetric.length * l1Progress);

    // Animate the second path
    var path1Metric = path1.computeMetrics().first;
    var animatedPath1 =
        path1Metric.extractPath(0, path1Metric.length * l2Progress);

    // Draw the animated portion of both paths

    // Define the gradient for the surrounding circle
    var circleGradient = LinearGradient(
      colors: LetEmCookConstants.greenGrad(opacity),
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      stops: const [0.5, 1.0],
    ).createShader(Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.height * 0.5,
    ));

    // Circle gradient paint
    var circlePaint = Paint()
      ..shader = circleGradient
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.height * 0.06;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.height * 0.5,
      Paint()..color = Colors.black.withOpacity(opacity / 2),
    );
    // Draw the surrounding circle with gradient
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.height * 0.5,
      circlePaint,
    );
    if (l1Progress > 0) {
      canvas.drawPath(animatedPath, paint1); // First path with gradient1
    }
    if (l1Progress == 1) {
      canvas.drawPath(animatedPath1, paint2); // Second path with gradient2
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
