import 'package:flutter/material.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

class AuxiliaryNokhteUtils {
  static StartAndEndOffsets getOffsets(
    ScreenSizeData screenSize, {
    required AuxiliaryNokhtePositions position,
    required NokhteScaleState direction,
  }) {
    Offset start = Offset.zero;
    Offset end = Offset.zero;
    Rect pathBounds = SvgAnimtionConstants.crossPath.getBounds();
    double width = pathBounds.width;
    double height = pathBounds.height;
    final size =
        useSquareSize(relativeLength: .2, screenSizeDataParam: screenSize);
    final adjustmentdx = (size.width - width) / 2 - pathBounds.left;
    final adjustmentdy = (size.height - height) / 2 - pathBounds.top;
    final screenCenter = Offset(
      screenSize.width / 2,
      screenSize.height / 2,
    );

    switch (position) {
      case AuxiliaryNokhtePositions.left:
        final expandedOffset = Offset(
          -useScaledSize(
            baseValue: .115,
            screenSize: screenSize.size,
            bumpPerHundredth: .0002,
          ),
          (-screenCenter.dy) * .8,
        );

        final restingOffset = Offset(
          CircleOffsets.left.dx + adjustmentdx,
          CircleOffsets.left.dy + adjustmentdy,
        );

        switch (direction) {
          case NokhteScaleState.enlarge:
            start = restingOffset;
            end = expandedOffset;
          case NokhteScaleState.shrink:
            start = expandedOffset;
            end = restingOffset;
        }
        break;

      case AuxiliaryNokhtePositions.right:
        final expandedOffset = Offset(
          useScaledSize(
            baseValue: .207,
            screenSize: screenSize.size,
            bumpPerHundredth: .0008,
          ),
          (-screenCenter.dy) * .8,
        );

        final restingOffset = Offset(
          CircleOffsets.right.dx + adjustmentdx,
          CircleOffsets.right.dy + adjustmentdy,
        );

        switch (direction) {
          case NokhteScaleState.enlarge:
            start = restingOffset;
            end = expandedOffset;
          case NokhteScaleState.shrink:
            start = expandedOffset;
            end = restingOffset;
        }
        break;

      case AuxiliaryNokhtePositions.top:
        final expandedOffset = Offset(
          CircleOffsets.center.dx + adjustmentdx,
          -useScaledSize(
            baseValue: .563,
            screenSize: screenSize.size,
            bumpPerHundredth: .0005,
          ),
        );

        final restingOffset = Offset(
          CircleOffsets.top.dx + adjustmentdx,
          CircleOffsets.top.dy + adjustmentdy,
        );

        switch (direction) {
          case NokhteScaleState.enlarge:
            start = restingOffset;
            end = expandedOffset;
          case NokhteScaleState.shrink:
            start = expandedOffset;
            end = restingOffset;
        }
        break;

      case AuxiliaryNokhtePositions.bottom:
        final expandedOffset = Offset(
          CircleOffsets.center.dx + adjustmentdx,
          -useScaledSize(
            baseValue: .238,
            screenSize: screenSize.size,
            bumpPerHundredth: -.0006,
          ),
        );

        final restingOffset = Offset(
          CircleOffsets.bottom.dx + adjustmentdx,
          CircleOffsets.bottom.dy + adjustmentdy,
        );

        switch (direction) {
          case NokhteScaleState.enlarge:
            start = restingOffset;
            end = expandedOffset;
          case NokhteScaleState.shrink:
            start = expandedOffset;
            end = restingOffset;
        }
        break;
      case AuxiliaryNokhtePositions.center:
        final expandedOffset = Offset(
          CircleOffsets.center.dx + adjustmentdx,
          -screenCenter.dy *
              .8, // Adjust for an expanded position below the center
        );

        final restingOffset = Offset(
          CircleOffsets.center.dx + adjustmentdx,
          CircleOffsets.center.dy + adjustmentdy,
        );

        switch (direction) {
          case NokhteScaleState.enlarge:
            start = restingOffset;
            end = expandedOffset;
          case NokhteScaleState.shrink:
            start = expandedOffset;
            end = restingOffset;
        }

      default:
        break;
    }
    return StartAndEndOffsets(
      start: start,
      end: end,
    );
  }

  static List<ColorAndStop> getGradient(AuxiliaryNokhteColorways colorway) {
    List<ColorAndStop> temp = [];
    if (colorway == AuxiliaryNokhteColorways.invertedBeachWave) {
      temp = const [
        ColorAndStop(Color(0xFFFFE6C4), 0.0),
        ColorAndStop(Color(0xFFFFBC78), .33),
        ColorAndStop(Color(0xFF42FFD9), .4),
        ColorAndStop(Color(0xFF4497C5), 1.0),
      ];
    } else if (colorway == AuxiliaryNokhteColorways.beachWave) {
      temp = const [
        ColorAndStop(Color(0xFF407F74), 0),
        ColorAndStop(Color(0xFF53A28F), .4),
        ColorAndStop(Color(0xFF866243), .4),
        ColorAndStop(Color(0xFFCBB28E), 1),
      ];
    } else if (colorway == AuxiliaryNokhteColorways.vibrantBlue ||
        colorway == AuxiliaryNokhteColorways.exitVibrantBlue ||
        colorway == AuxiliaryNokhteColorways.informationTint) {
      temp = const [
        ColorAndStop(Color(0xFF44D3FE), 0),
        ColorAndStop(Color(0xFF44D3FE), 0),
        ColorAndStop(Color(0xFF6BE9BB), 1),
        ColorAndStop(Color(0xFF6BE9BB), 1),
      ];
    } else if (colorway == AuxiliaryNokhteColorways.deeperBlue) {
      temp = const [
        ColorAndStop(Color(0xFF40F3F3), 0),
        ColorAndStop(Color(0xFF40F3F3), 0),
        ColorAndStop(Color(0xFF4072F3), 1),
        ColorAndStop(Color(0xFF4072F3), 1),
      ];
    } else if (colorway == AuxiliaryNokhteColorways.orangeSand ||
        colorway == AuxiliaryNokhteColorways.exitOrangeSand) {
      temp = const [
        ColorAndStop(Color(0xFFFFE6C4), 0),
        ColorAndStop(Color(0xFFFFE6C4), 0),
        ColorAndStop(Color(0xFFFFBC78), .49),
        ColorAndStop(Color(0xFFFFBC78), .49),
      ];
    } else if (colorway == AuxiliaryNokhteColorways.deeperBlue) {
      temp = const [
        ColorAndStop(Color(0xFF4072F3), 0),
        ColorAndStop(Color(0xFF4072F3), 0),
        ColorAndStop(Color(0xFF40F3F3), 1.00),
        ColorAndStop(Color(0xFF40F3F3), 1.00),
        //
      ];
    }
    return temp;
  }
}
