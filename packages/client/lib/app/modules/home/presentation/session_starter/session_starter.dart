import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/home.dart';
export 'session_starter_coordinator.dart';

class SessionStarterScreen extends HookWidget {
  final SessionStarterCoordinator coordinator;

  const SessionStarterScreen({
    super.key,
    required this.coordinator,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor();
      return null;
      // return () => coordinator.dispose();
    }, []);
    return Observer(builder: (context) {
      return AnimatedScaffold(
        children: [
          HeaderRow(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              LeftChevron(
                onTap: () => Modular.to.pop(),
              ),
              const SmartHeader(
                content: "Session Stater",
              ),
              const LeftChevron(
                color: Colors.transparent,
              ),
            ],
          )
        ],
      );
    });
  }
}
