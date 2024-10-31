import 'package:flutter/material.dart';
import 'package:nokhte/app/core/extensions/extensions.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';

Size useSquareSize({
  required double relativeLength,
  ScreenSizeData? screenSizeDataParam,
}) {
  final screenSizeData = screenSizeDataParam ?? useScreenSizeData(),
      unrefinedHeight = screenSizeData.height,
      width = screenSizeData.width,
      topPadding = screenSizeData.padding.top,
      bottomPadding = screenSizeData.padding.bottom,
      refinedHeight = unrefinedHeight - topPadding - bottomPadding;
  double desiredSize = width.isLessThan(refinedHeight)
      ? width * relativeLength
      : refinedHeight * relativeLength;
  return Size(desiredSize, desiredSize);
}
