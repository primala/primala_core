import 'package:flutter/material.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte_backend/tables/company_presets.dart';

class MultiFocalNotesDemoPainter extends CustomPainter with DemoPainterUtils {
  final List<SessionTags> allTheTags;
  final double containerSize;
  final List<Color> colorsList;
  final List<double> stopsList;
  final double aboveCenterTextOpacity,
      aboveCenterTextProgress,
      belowCenterTextOpacity,
      slightlyAboveCenterTextOpacity,
      slightlyBelowCenterTextOpacity;

  MultiFocalNotesDemoPainter({
    required this.allTheTags,
    required this.containerSize,
    required this.colorsList,
    required this.stopsList,
    required this.aboveCenterTextOpacity,
    required this.aboveCenterTextProgress,
    required this.belowCenterTextOpacity,
    required this.slightlyAboveCenterTextOpacity,
    required this.slightlyBelowCenterTextOpacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final grad = LinearGradient(
      colors: colorsList,
      stops: stopsList,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    final double phoneHeight = getPhoneHeight(containerSize);
    final double phoneWidth = getPhoneWidth(containerSize);

    final Offset phoneOffset = getCenterPhoneOffset(size, containerSize);

    drawPhone(
        canvas, phoneOffset, phoneWidth, phoneHeight, grad, phoneCornerRadius);
    paintPhoneTexts(
      canvas,
      phoneOffset,
      phoneWidth,
      phoneHeight,
      slightlyAboveCenterTextOpacity,
      containerSize,
      allTheTags,
    );
    paintNotesPhoneTexts(
      canvas,
      phoneOffset,
      phoneWidth,
      phoneHeight,
      containerSize,
      aboveCenterTextOpacity,
      aboveCenterTextProgress,
      belowCenterTextOpacity,
    );
  }

  @override
  bool shouldRepaint(oldDelegate) => true;
}
