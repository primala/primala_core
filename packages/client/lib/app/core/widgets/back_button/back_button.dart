import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'canvas/back_button_painter.dart';
export 'mobx/back_button_store.dart';

class BackButton extends HookWidget {
  final BackButtonStore store;
  final Color overridedColor;
  final double topPaddingScalar;
  final bool showWidget;
  const BackButton({
    super.key,
    required this.store,
    this.showWidget = true,
    this.overridedColor = Colors.white,
    this.topPaddingScalar = 0.07,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = useFullScreenSize();
    useEffect(() {
      store.setWidgetVisibility(false);
      Timer(Seconds.get(0, milli: 1), () {
        store.setWidgetVisibility(true);
      });
      return null;
    });
    return Observer(
      builder: (context) => AnimatedOpacity(
        opacity: useWidgetOpacity(showWidget),
        duration: Seconds.get(0, milli: 500),
        child: Padding(
          padding: EdgeInsets.only(
            left: screenSize.width * .05,
            top: useScaledSize(
              baseValue: topPaddingScalar,
              screenSize: screenSize,
              bumpPerHundredth: -.0003,
            ),
          ),
          child: GestureDetector(
            onTap: () {
              store.onTap();
            },
            child: CustomPaint(
              painter: BackButtonPainter(
                color: overridedColor,
              ),
              child: SizedBox(
                height: screenSize.height * .06,
                width: screenSize.height * .06,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
