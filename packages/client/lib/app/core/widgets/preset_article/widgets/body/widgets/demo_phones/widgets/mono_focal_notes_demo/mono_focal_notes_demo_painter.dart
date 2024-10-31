import 'package:flutter/material.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte_backend/tables/company_presets.dart';

class MonoFocalNotesDemoPainter extends CustomPainter with DemoPainterUtils {
  final List<SessionTags> allTheTags;
  final List<Color> leftPhoneColorsList;
  final List<Color> rightPhoneColorsList;
  final List<double> leftPhoneStopsList;
  final List<double> rightPhoneStopsList;
  final double containerSize,
      aboveCenterTextOpacity,
      aboveCenterTextProgress,
      belowCenterTextOpacity,
      slightlyAboveCenterTextOpacity,
      slightlyBelowCenterTextOpacity;

  MonoFocalNotesDemoPainter({
    required this.allTheTags,
    required this.containerSize,
    required this.leftPhoneColorsList,
    required this.leftPhoneStopsList,
    required this.rightPhoneColorsList,
    required this.rightPhoneStopsList,
    required this.aboveCenterTextOpacity,
    required this.aboveCenterTextProgress,
    required this.belowCenterTextOpacity,
    required this.slightlyAboveCenterTextOpacity,
    required this.slightlyBelowCenterTextOpacity,
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

    paintNotesPhoneTexts(
      canvas,
      leftPhoneOffset,
      phoneWidth,
      phoneHeight,
      containerSize,
      aboveCenterTextOpacity,
      aboveCenterTextProgress,
      belowCenterTextOpacity,
    );

    drawTint(
      canvas,
      rightPhoneOffset,
      phoneWidth,
      phoneHeight,
      phoneCornerRadius,
      aboveCenterTextOpacity,
      TintType.bottomHalf,
    );

    final rRect = rightPhoneOffset & Size(phoneWidth, phoneHeight);
    final rCenter = rRect.center;

    paintText(
      canvas,
      rCenter,
      'Waiting',
      containerSize,
      aboveCenterTextOpacity,
      DemoTextPosition.leftHeader,
      rRect,
    );
    paintPhoneTexts(
      canvas,
      rightPhoneOffset,
      phoneWidth,
      phoneHeight,
      1,
      containerSize,
      allTheTags,
    );

    paintPhoneTexts(
      canvas,
      leftPhoneOffset,
      phoneWidth,
      phoneHeight,
      slightlyAboveCenterTextOpacity,
      containerSize,
      allTheTags,
    );
  }

  @override
  bool shouldRepaint(oldDelegate) => true;
}
