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
  const BackButton({
    super.key,
    required this.store,
    this.overridedColor = Colors.transparent,
    this.topPaddingScalar = 0.06,
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
        opacity: useWidgetOpacity(store.showWidget),
        duration: Seconds.get(1),
        child: Padding(
          padding: EdgeInsets.only(
            left: screenSize.width * .05,
            top: screenSize.height * topPaddingScalar,
          ),
          child: GestureDetector(
            onTap: () {
              store.onTap();
            },
            child: CustomPaint(
              painter: BackButtonPainter(
                overridedColor: overridedColor,
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
