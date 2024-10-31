import 'package:flutter/material.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte_backend/tables/company_presets.dart';

class LetEmCookDemoPainter extends CustomPainter with DemoPainterUtils {
  final List<Color> leftPhoneColorsList;
  final List<Color> rightPhoneColorsList;
  final List<double> leftPhoneStopsList;
  final List<double> rightPhoneStopsList;
  final List<SessionTags> allTheTags;
  final Color glowColor;

  final double activeTextOpacity,
      restingTextOpacity,
      glowStrokeWidth,
      containerSize;

  LetEmCookDemoPainter({
    required this.containerSize,
    required this.allTheTags,
    required this.leftPhoneColorsList,
    required this.leftPhoneStopsList,
    required this.rightPhoneColorsList,
    required this.rightPhoneStopsList,
    required this.activeTextOpacity,
    required this.restingTextOpacity,
    required this.glowColor,
    required this.glowStrokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final leftPhoneGrad = LinearGradient(
      colors: leftPhoneColorsList,
      stops: leftPhoneStopsList,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    final rightPhoneGrad = LinearGradient(
      colors: rightPhoneColorsList,
      stops: rightPhoneStopsList,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    final Offset leftPhoneOffset = getLeftPhoneOffset(size, containerSize);
    final Offset rightPhoneOffset = getRightPhoneOffset(size, containerSize);
    final phoneHeight = getPhoneHeight(containerSize);
    final phoneWidth = getPhoneWidth(containerSize);

    drawPhone(
      canvas,
      leftPhoneOffset,
      phoneWidth,
      phoneHeight,
      leftPhoneGrad,
      phoneCornerRadius,
    );

    drawPhone(
      canvas,
      rightPhoneOffset,
      phoneWidth,
      phoneHeight,
      rightPhoneGrad,
      phoneCornerRadius,
    );

    drawTint(
      canvas,
      rightPhoneOffset,
      phoneWidth,
      phoneHeight,
      phoneCornerRadius,
      activeTextOpacity,
      TintType.full,
    );

    final lRect = leftPhoneOffset & Size(phoneWidth, phoneHeight);
    final rRect = rightPhoneOffset & Size(phoneWidth, phoneHeight);
    final lCenter = lRect.center;
    final rCenter = rRect.center;

    paintText(
      canvas,
      lCenter,
      'Speaking',
      containerSize,
      activeTextOpacity,
      DemoTextPosition.leftHeader,
      lRect,
    );
    paintText(
      canvas,
      rCenter,
      'Listening',
      containerSize,
      activeTextOpacity,
      DemoTextPosition.leftHeader,
      rRect,
    );
    paintPhoneTexts(
      canvas,
      leftPhoneOffset,
      phoneWidth,
      phoneHeight,
      restingTextOpacity,
      containerSize,
      allTheTags,
    );
    paintPhoneTexts(
      canvas,
      rightPhoneOffset,
      phoneWidth,
      phoneHeight,
      restingTextOpacity,
      containerSize,
      allTheTags,
    );

    drawBlurredBorder(
      canvas,
      leftPhoneOffset,
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
