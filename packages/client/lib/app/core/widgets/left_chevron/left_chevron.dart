import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'left_chevron_painter.dart';

class LeftChevron extends HookWidget {
  final Color color;
  final Function? onTap;
  final double leftPadding;
  final double topPadding;
  const LeftChevron({
    super.key,
    this.color = Colors.black,
    this.leftPadding = 0.01,
    this.topPadding = 0.015,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = useFullScreenSize();
    final chevronSize = useScaledSize(
      baseValue: 0.04,
      screenSize: screenSize,
      bumpPerHundredth: 0.0001,
    );
    return Padding(
      padding: EdgeInsets.only(
        top: useScaledSize(
          baseValue: topPadding,
          screenSize: screenSize,
          bumpPerHundredth: 0.0001,
        ),
        left: useScaledSize(
          baseValue: leftPadding,
          screenSize: screenSize,
          bumpPerHundredth: 0.0001,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          onTap?.call();
        },
        child: CustomPaint(
          painter: LeftChevronPainter(
            color: color,
          ),
          child: SizedBox(
            height: chevronSize,
            width: chevronSize,
          ),
        ),
      ),
    );
  }
}
