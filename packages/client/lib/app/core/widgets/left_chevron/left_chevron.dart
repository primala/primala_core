import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'left_chevron_painter.dart';

class LeftChevron extends HookWidget {
  final Color color;
  final Function? onTap;
  final double leftPadding;
  const LeftChevron({
    super.key,
    this.color = Colors.black,
    this.leftPadding = 0.05,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = useFullScreenSize();
    return Padding(
      padding: EdgeInsets.only(
        // top: 10,
        left: screenSize.width * leftPadding,
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
            height: screenSize.height * .04,
            width: screenSize.height * .04,
          ),
        ),
      ),
    );
  }
}
