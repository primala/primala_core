import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
export 'pause_icon_store.dart';

class PauseIcon extends HookWidget {
  final PauseIconStore store;
  const PauseIcon({
    super.key,
    required this.store,
  });

  pauseBar(Size size) {
    return Container(
      width: useScaledSize(
        baseValue: .03,
        screenSize: size,
        bumpPerHundredth: 0, // TODO
      ),
      height: useScaledSize(
        baseValue: .1,
        screenSize: size,
        bumpPerHundredth: 0, // TODO
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = useFullScreenSize();
    return Observer(builder: (context) {
      return AnimatedOpacity(
        opacity: useWidgetOpacity(store.showWidget),
        duration: Seconds.get(1),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  pauseBar(screenSize),
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                  ),
                  pauseBar(screenSize),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Jost(
                  'Tap to resume',
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
