import 'package:flutter/material.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte_backend/tables/company_presets.dart';

class RallyDemoPainter extends CustomPainter with DemoPainterUtils {
  final List<SessionTags> allTheTags;
  final List<Color> leftPhoneColorsList;
  final List<Color> rightPhoneColorsList;
  final List<double> leftPhoneStopsList;
  final List<double> rightPhoneStopsList;
  final Color glowColor;
  final double rightPhoneTextOpacity;

  final double leftActiveTextOpacity,
      rightHeaderListeningTextOpacity,
      rightHeaderSpeakingTextOpacity,
      restingTextOpacity,
      leftTintOpacity,
      rightTintOpacity,
      glowStrokeWidth,
      containerSize;

  RallyDemoPainter({
    required this.containerSize,
    required this.allTheTags,
    required this.leftPhoneColorsList,
    required this.leftPhoneStopsList,
    required this.rightPhoneColorsList,
    required this.rightPhoneStopsList,
    required this.rightHeaderListeningTextOpacity,
    required this.rightHeaderSpeakingTextOpacity,
    required this.restingTextOpacity,
    required this.leftActiveTextOpacity,
    required this.leftTintOpacity,
    required this.rightTintOpacity,
    required this.glowColor,
    required this.glowStrokeWidth,
    required this.rightPhoneTextOpacity,
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
      rightTintOpacity,
      TintType.bottomHalf,
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
      leftActiveTextOpacity,
      DemoTextPosition.leftHeader,
      lRect,
    );
    paintText(
      canvas,
      rCenter,
      'Listening',
      containerSize,
      rightHeaderListeningTextOpacity,
      DemoTextPosition.leftHeader,
      rRect,
    );
    paintText(
      canvas,
      rCenter,
      'Speaking',
      containerSize,
      rightHeaderSpeakingTextOpacity,
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
      rightPhoneTextOpacity,
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

    drawTint(
      canvas,
      leftPhoneOffset,
      phoneWidth,
      phoneHeight,
      phoneCornerRadius,
      leftTintOpacity,
      // 1,
      TintType.full,
    );
  }

  @override
  bool shouldRepaint(oldDelegate) => true;
}

class OtherGlowPainter extends CustomPainter with DemoPainterUtils {
  final Color glowColor;
  final double containerSize, glowStrokeWidth;

  OtherGlowPainter({
    required this.containerSize,
    required this.glowColor,
    required this.glowStrokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Offset rightPhoneOffset = getRightPhoneOffset(size, containerSize);
    final phoneHeight = getPhoneHeight(containerSize);
    final phoneWidth = getPhoneWidth(containerSize);

    drawBlurredBorder(
      canvas,
      rightPhoneOffset,
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
