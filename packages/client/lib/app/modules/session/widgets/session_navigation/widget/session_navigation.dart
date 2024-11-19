// ignore_for_file: unused_import
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';

class SessionNavigation extends HookWidget {
  final SessionNavigationStore store;
  const SessionNavigation({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      store.setup();
      return () => store.dispose();
    }, []);
    return Observer(builder: (context) {
      return AnimatedOpacity(
        duration: Seconds.get(1),
        opacity: useWidgetOpacity(store.showWidget),
        child: FullScreen(
            child: Swipe(
          store: store.swipe,
          child: MultiHitStack(
            children: [
              Tint(
                store: store.tint,
              ),
              GestureCross(
                store: store.gestureCross,
                showGlowAndOutline: true,
                config: GestureCrossConfiguration(
                  top: Right(EmptySpace()),
                  bottom: Right(EmptySpace()),
                ),
              ),
              CenterNokhte(
                store: store.centerNokhte,
              ),
              AuxiliaryNokhte(
                store: store.exitNokhte,
              ),
              AuxiliaryNokhte(
                store: store.infoNokhte,
              ),
              SwipeGuide(
                store: store.swipeGuide,
                orientations: const [
                  SwipeGuideOrientation.top,
                  SwipeGuideOrientation.bottom,
                ],
              ),
            ],
          ),
        )),
      );
    });
  }
}
