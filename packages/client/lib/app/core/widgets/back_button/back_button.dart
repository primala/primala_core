import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'back_button_painter.dart';

class BackButton extends HookWidget {
  final Color color;
  final Function? onTap;
  const BackButton({
    super.key,
    this.color = Colors.white,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = useFullScreenSize();
    return Observer(
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: screenSize.width * .05,
        ),
        child: GestureDetector(
          onTap: () {
            onTap?.call();
          },
          child: CustomPaint(
            painter: BackButtonPainter(
              color: color,
            ),
            child: SizedBox(
              height: screenSize.height * .06,
              width: screenSize.height * .06,
            ),
          ),
        ),
      ),
    );
  }
}
