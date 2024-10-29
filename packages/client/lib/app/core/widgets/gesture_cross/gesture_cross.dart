import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
export 'types/types.dart';
export 'sub_widgets/sub_widgets.dart';
export 'mobx/gesture_cross_store.dart';

class GestureCross extends HookWidget {
  final GestureCrossStore store;
  final GestureCrossConfiguration config;
  final bool showGlowAndOutline;
  const GestureCross({
    super.key,
    required this.store,
    required this.config,
    this.showGlowAndOutline = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = useSquareSize(relativeLength: .20);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: GestureDetector(
              onTap: () => store.incrementTapCount(),
              onDoubleTap: () => store.incrementTapCount(),
              child: MultiHitStack(
                children: [
                  Cross(
                    showGlowAndOutline: showGlowAndOutline,
                    store: store.cross,
                  ),
                ],
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 20),
        ),
      ],
    );
  }
}
