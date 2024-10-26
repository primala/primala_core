import 'package:flutter/material.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte_backend/tables/company_presets.dart';

class SoloSpeakingDemoPainter extends CustomPainter with DemoPainterUtils {
  final List<SessionTags> allTheTags;
  final List<Color> centerPhoneColorsList;
  final List<double> centerPhoneStopsList;
  final Color glowColor;
  final double activeTextOpacity,
      restingTextOpacity,
      glowStrokeWidth,
      containerSize;

  SoloSpeakingDemoPainter({
    required this.allTheTags,
    required this.containerSize,
    required this.centerPhoneColorsList,
    required this.centerPhoneStopsList,
    required this.activeTextOpacity,
    required this.restingTextOpacity,
    required this.glowColor,
    required this.glowStrokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // print("allTheTags: $allTheTags");
    final centerPhoneGrad = LinearGradient(
      colors: centerPhoneColorsList,
      stops: centerPhoneStopsList,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    final Offset centerPhoneOffset = getCenterPhoneOffset(size, containerSize);
    final phoneHeight = getPhoneHeight(containerSize);
    final phoneWidth = getPhoneWidth(containerSize);

    drawPhone(
      canvas,
      centerPhoneOffset,
      phoneWidth,
      phoneHeight,
      centerPhoneGrad,
      phoneCornerRadius,
    );

    final cRect = centerPhoneOffset & Size(phoneWidth, phoneHeight);
    final cCenter = cRect.center;

    paintText(
      canvas,
      cCenter,
      'Speaking',
      containerSize,
      activeTextOpacity,
      DemoTextPosition.leftHeader,
      cRect,
    );

    paintPhoneTexts(
      canvas,
      centerPhoneOffset,
      phoneWidth,
      phoneHeight,
      restingTextOpacity,
      containerSize,
      allTheTags,
    );

    drawBlurredBorder(
      canvas,
      centerPhoneOffset,
      phoneWidth,
      phoneHeight,
      phoneCornerRadius,
      glowColor,
      glowStrokeWidth,
    );
  }

  @override
  bool shouldRepaint(oldDelegate) => true;
}
