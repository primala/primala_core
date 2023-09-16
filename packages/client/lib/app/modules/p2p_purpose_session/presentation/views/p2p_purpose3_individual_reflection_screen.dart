import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:primala/app/core/widgets/text_editor/text_editor.dart';
import 'package:primala/app/core/widgets/widgets.dart';
import 'package:primala/app/modules/p2p_purpose_session/presentation/mobx/mobx.dart';
import 'package:swipe/swipe.dart';

class P2PPurpose3IndividualRefletionScreen extends StatelessWidget {
  final P2PPurposePhase3CoordinatorStore coordinator;
  P2PPurpose3IndividualRefletionScreen({
    super.key,
    required this.coordinator,
  }) {
    coordinator.screenConstructor();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) => PlatformScaffold(
              body: Swipe(
            child: Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: SmartBeachWaves(
                    stateTrackerStore: coordinator.beachWaves,
                  ),
                ),
                Center(
                  child: SmartFadingAnimatedText(
                    initialFadeInDelay: const Duration(seconds: 0),
                    stateTrackerStore: coordinator.fadingText,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: SoloTextEditor(
                    fadeInDuration: const Duration(seconds: 2),
                    trackerStore: coordinator.textEditor,
                  ),
                ),
              ],
            ),
          ))),
    );
    // });
  }
}
