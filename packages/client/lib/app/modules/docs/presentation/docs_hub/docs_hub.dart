import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/constants/colors.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/docs/docs.dart';
export 'docs_hub_coordinator.dart';

class DocsHubScreen extends HookWidget {
  final DocsHubCoordinator coordinator;

  const DocsHubScreen({
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
    final containerSize = useScaledSize(
      baseValue: 0.08,
      screenSize: screenSize,
      bumpPerHundredth: 0.0004,
    );

    return Observer(builder: (context) {
      return CarouselScaffold(
        dispose: coordinator.dispose,
        isScrollable: true,
        initialPosition: 2,
        showWidgets: coordinator.showWidgets,
        mainAxisAlignment: MainAxisAlignment.start,
        floatingActionButton: GestureDetector(
          onTap: coordinator.onCreateDocTapped,
          child: Container(
              margin: EdgeInsets.only(
                right: useScaledSize(
                  baseValue: .01,
                  screenSize: screenSize,
                  bumpPerHundredth: -.001,
                ).clamp(0.0, double.infinity),
              ),
              height: containerSize,
              width: containerSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: NokhteColors.eggshell,
                border: Border.all(
                  color: Colors.black,
                  width: 1.5,
                ),
              ),
              child: Image.asset(
                'assets/groups/plus_icon.png',
              )),
        ),
        children: [
          const HeaderRow(title: 'Documents'),
          ToggleViewButtons(
            onButtonToggled: coordinator.setIsCurrentSelected,
          ),
          DocsDisplay(
            docs: coordinator.docs,
            onDocTapped: coordinator.onDocTapped,
          )
        ],
      );
    });
  }
}
