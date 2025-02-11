// ignore_for_file: unused_import

import 'package:flutter/material.dart' hide BackButton;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';

import 'canvas/rally_widget_painter.dart';
export 'constants/constants.dart';
export 'mobx/rally_store.dart';
export 'types/types.dart';

class Rally extends HookWidget with RallyConstants {
  final RallyStore store;
  Rally(
    this.store, {
    super.key,
  });

  Widget getWidgetsByPhase(
    RallyPhase phase,
    double containerSize,
  ) {
    switch (phase) {
      case RallyPhase.initial:
        return GestureDetector(
            onTap: store.showWidget
                ? () {
                    store.setRallyPhase(RallyPhase.selection);
                  }
                : null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/power_up/rally_button_blue.png',
                  width: containerSize,
                  height: containerSize,
                ),
                Jost(
                  'Tap to rally',
                  fontColor: navyBlue,
                  fontSize: containerSize * 0.3,
                  fontWeight: FontWeight.w300,
                )
              ],
            ));
      case RallyPhase.selection:
        return MultiHitStack(
          children: [
            Tint(
              store.tint,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 70),
                      child: LeftChevron(
                        color: Colors.white,
                        onTap: () {
                          if (phase == RallyPhase.selection) {
                            store.setRallyPhase(RallyPhase.initial);
                          }
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 70.0),
                      child: Chivo(
                        "Rally with:",
                        fontSize: 45,
                        shouldCenter: true,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 70),
                      child: LeftChevron(
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: store.collaborators.length,
                    itemBuilder: (context, index) {
                      return Observer(builder: (context) {
                        final collaborator = store.collaborators[index];
                        return GestureDetector(
                          onTap: () => store.setCurrentlySelectedIndex(index),
                          child: AnimatedOpacity(
                            opacity: 1.0,
                            duration: Seconds.get(1),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 20.0),
                              padding: const EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(13),
                              ),
                              child: Chivo(
                                collaborator.fullName,
                                fontSize: containerSize * 0.3,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      case RallyPhase.activeInitiator:
        return Observer(builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 100.0),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/power_up/rally_button_blue.png',
                      width: containerSize,
                      height: containerSize,
                    ),
                    Jost(
                      'Rallying with ${store.currentPartnerFirstName}',
                      fontColor: navyBlue,
                      fontSize: containerSize * 0.3,
                      fontWeight: FontWeight.w300,
                    ),
                  ],
                ),
              ),
              AnimatedOpacity(
                duration: Seconds.get(1),
                opacity: useWidgetOpacity(store.cancelButtonVisibility),
                child: Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: GestureDetector(
                    onTap: store.cancelButtonVisibility
                        ? () {
                            store.reset();
                          }
                        : null,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/power_up/rally_button_red.png',
                          width: containerSize,
                          height: containerSize,
                        ),
                        Jost(
                          'Stop Rally',
                          fontColor: redGrad.first,
                          fontSize: containerSize * 0.3,
                          fontWeight: FontWeight.w300,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        });

      case RallyPhase.activeRecipient:
        return Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/power_up/rally_button_blue.png',
                width: containerSize,
                height: containerSize,
              ),
              Jost(
                'Rallying with ${store.currentInitiatorFirstName}',
                fontColor: navyBlue,
                fontSize: containerSize * 0.3,
                fontWeight: FontWeight.w300,
              ),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final containerSize = useScaledSize(
        baseValue: 0.08,
        screenSize: useFullScreenSize(),
        bumpPerHundredth: 0.0004);
    useEffect(() {
      store.constructor();
      return () => store.dispose();
    });

    return Observer(
      builder: (context) {
        return AnimatedOpacity(
          duration: Seconds.get(0, milli: 500),
          opacity: useWidgetOpacity(store.showWidget),
          child: FullScreen(
            child: getWidgetsByPhase(store.phase, containerSize),
          ),
        );
      },
    );
  }
}
