import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
export 'pause_coordinator.dart';

class PauseScreen extends HookWidget {
  final PauseCoordinator coordinator;
  const PauseScreen({
    super.key,
    required this.coordinator,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor();
      return null;
    }, []);
    final screenSize = useFullScreenSize();
    final scaledPadding = useScaledSize(
      baseValue: .2,
      screenSize: screenSize,
      bumpPerHundredth: -0.001,
    );
    useOnAppLifecycleStateChange(
      (previous, current) => coordinator.onAppLifeCycleStateChange(
        current,
        onResumed: () async => await coordinator.onResumed(),
        onInactive: () => null,
      ),
    );

    return Observer(builder: (context) {
      return AnimatedScaffold(
        showWidgets: coordinator.showWidgets,
        body: GestureDetector(
          onTap: () => coordinator.onTap(),
          child: MultiHitStack(
            children: [
              Tint(
                coordinator.tint,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/session/pause_icon.png',
                      height: 150,
                      width: 150,
                      color: Colors.white,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 0.0),
                    child: Jost(
                      'Tap to resume',
                      fontSize: 20,
                      fontColor: Colors.white,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: scaledPadding),
                child: GeneralizedActionSlider(
                  showWidget: true,
                  assetPath: 'assets/session/end_session_icon.png',
                  sliderText: 'End Session',
                  onSlideComplete: () => coordinator.onSlideComplete(),
                ),
              ),
            ],
          ),
        ),
        // ),
      );
    });
  }
}
