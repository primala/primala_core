import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/home.dart';
export 'information_coordinator.dart';

class InformationScreen extends HookWidget {
  final InformationCoordinator coordinator;

  const InformationScreen({
    super.key,
    required this.coordinator,
  });
  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor();
      return null;
    }, []);
    return Observer(builder: (context) {
      return CarouselScaffold(
        initialPosition: 0,
        showWidgets: coordinator.showWidgets,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderRow(title: 'Session Information'),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Image.asset(
              'assets/power_up/cook_button.png',
              color: Colors.black,
              height: 50,
              width: 50,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 32),
            child: Jost(
              'Cook',
              fontColor: Colors.black,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 52, right: 20),
            child: Jost(
              'When someone is saying something useful, you can give them more time to speak',
              softWrap: true,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/power_up/rally_button_blue.png',
                color: Colors.black,
                height: 50,
                width: 50,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 32),
            child: Jost(
              'Rally',
              fontColor: Colors.black,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 52, right: 20),
            child: Jost(
              'When you want to ask a quick question, or get a quick response, you can start a rally',
              softWrap: true,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(5),
              child: Image.asset(
                'assets/session/pencil_icon.png',
                color: Colors.black,
                height: 35,
                width: 35,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 32),
            child: Jost(
              'Docs',
              fontColor: Colors.black,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 52, right: 20),
            child: Jost(
              'With a limit of 2,000 characters per document, you can create and condense your thoughts as a group',
              softWrap: true,
              fontSize: 16,
            ),
          ),
        ],
      );
    });
  }
}
