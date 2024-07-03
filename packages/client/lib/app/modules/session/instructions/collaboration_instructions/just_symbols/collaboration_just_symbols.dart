import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'collaboration_just_symbols_coordinator.dart';
export 'collaboration_just_symbols_coordinator.dart';
export 'collaboration_just_symbols_widgets_coordinator.dart';

class CollaborationJustSymbolsScreen extends HookWidget {
  final CollaborationJustSymbolsCoordinator coordinator;
  const CollaborationJustSymbolsScreen({
    super.key,
    required this.coordinator,
  });

  @override
  Widget build(BuildContext context) {
    final height = useFullScreenSize().height;
    useEffect(() {
      coordinator.constructor();
      return () => coordinator.deconstructor();
    }, []);
    return Scaffold(
        body: Tap(
            store: coordinator.tap,
            child: MultiHitStack(
              children: [
                FullScreen(
                  child: BeachWaves(
                    store: coordinator.widgets.beachWaves,
                  ),
                ),
                BorderGlow(store: BorderGlowStore()),
                FullScreen(
                  child: TouchRipple(
                    store: coordinator.widgets.touchRipple,
                  ),
                ),
                Center(
                  child: SmartText(
                    store: coordinator.widgets.smartText,
                    topPadding: height * .1,
                    subTextPadding: height * .7,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: height * .1),
                  child: PresetDiagam(
                    store: coordinator.widgets.presetDiagram,
                  ),
                ),
              ],
            )));
  }
}
