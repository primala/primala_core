export 'session_main_coordinator.dart';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:nokhte/app/modules/session/session.dart';

class SessionMainScreen extends HookWidget {
  final SessionMainCoordinator coordinator;

  const SessionMainScreen({
    super.key,
    required this.coordinator,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor();
      return null;
      // return () => coordinator.deconstructor();
    }, []);
    return Container();
  }
}
