import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
export 'speak_less_smile_more_store.dart';

class SpeakLessSmileMore extends StatelessWidget {
  final SpeakLessSmileMoreStore store;
  const SpeakLessSmileMore(
    this.store, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return RotatedBox(
        quarterTurns: store.shouldBeUpsideDown ? 2 : 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: useWidgetOpacity(store.showSpeakLess),
              duration: Seconds.get(1),
              child: const Center(
                child: Jost("Speak less,"),
              ),
            ),
            AnimatedOpacity(
              opacity: useWidgetOpacity(store.showSmileMore),
              duration: Seconds.get(1),
              child: const Center(
                child: Jost(" smile more"),
              ),
            )
          ],
        ),
      );
    });
  }
}
