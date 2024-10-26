export 'home_coordinator.dart';
export 'home_widgets_coordinator.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/home.dart';

class HomeScreen extends HookWidget {
  final HomeCoordinator coordinator;
  const HomeScreen({
    super.key,
    required this.coordinator,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor();
      return () => coordinator.deconstructor();
    }, []);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Tap(
        store: coordinator.tap,
        child: Swipe(
          store: coordinator.swipe,
          child: MultiHitStack(
            children: [
              FullScreen(
                child: BeachWaves(
                  store: coordinator.widgets.beachWaves,
                ),
              ),
              FullScreen(
                child: NokhteBlur(
                  store: coordinator.widgets.nokhteBlur,
                ),
              ),
              Observer(builder: (context) {
                return Center(
                  child: SmartText(
                    store: coordinator.widgets.smartText,
                    // topPadding: coordinator.widgets.smartTextTopPaddingScalar,
                    // addSubMessageAdjuster: true,
                    topBump: 0.008,
                    bottomPadding:
                        coordinator.widgets.smartTextBottomPaddingScalar,
                    bottomBump: .008,
                    opacityDuration: Seconds.get(1),
                  ),
                );
              }),
              Center(
                child: SmartText(
                  store: coordinator.widgets.gestureCrossSmartText,
                  topPadding: .6,
                  // addSubMessageAdjuster: true,
                  topBump: 0.008,
                  // bottomPadding:
                  //     coordinator.widgets.smartTextBottomPaddingScalar,
                  // bottomBump: .008,
                  opacityDuration: Seconds.get(1),
                ),
              ),
              GestureCross(
                showGlowAndOutline: true,
                config: GestureCrossConfiguration(
                  top: Right(EmptySpace()),
                  right: Right(EmptySpace()),
                  bottom: Right(EmptySpace()),
                ),
                store: coordinator.widgets.gestureCross,
              ),
              SwipeGuide(
                store: coordinator.widgets.swipeGuides,
                orientations: const [
                  SwipeGuideOrientation.top,
                  SwipeGuideOrientation.bottom,
                  SwipeGuideOrientation.right,
                  SwipeGuideOrientation.left,
                ],
              ),
              CenterNokhte(
                store: coordinator.widgets.centerNokhte,
              ),
              AuxiliaryNokhte(
                store: coordinator.widgets.sessionStarterNokhte,
              ),
              AuxiliaryNokhte(
                store: coordinator.widgets.deactivateNokhte,
              ),
              AuxiliaryNokhte(
                store: coordinator.widgets.sessionJoinerNokhte,
              ),
              AuxiliaryNokhte(
                store: coordinator.widgets.storageNokhte,
              ),
              WifiDisconnectOverlay(
                store: coordinator.widgets.wifiDisconnectOverlay,
              ),
            ],
          ),
        ),
      ),
      // ),
    );
  }
}
