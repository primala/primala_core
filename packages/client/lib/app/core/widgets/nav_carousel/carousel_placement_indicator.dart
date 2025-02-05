import 'package:flutter/material.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';

class CarouselPlacementIndicator extends StatelessWidget with OpacityUtils {
  final double containerSize;
  final double currentPosition;
  final int length;
  final Color color;

  const CarouselPlacementIndicator({
    super.key,
    required this.containerSize,
    required this.currentPosition,
    required this.length,
    this.color = Colors.black,
  });

  Widget buildCircle({
    required double currentPosition,
    required double targetValue,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, top: 8.0),
      child: Opacity(
        opacity: interpolate(
          currentValue: currentPosition,
          targetValue: targetValue,
          minOutput: 0.5,
          maxOutput: 1.0,
        ),
        child: Container(
          width: containerSize * .06,
          height: containerSize * .06,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length,
        (index) => buildCircle(
          currentPosition: currentPosition,
          targetValue: index.toDouble(),
        ),
      ),
    );
  }
}
