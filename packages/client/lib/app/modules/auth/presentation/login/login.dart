export 'login_coordinator.dart';
export 'login_widgets_coordinator.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/auth/auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoginScreen extends HookWidget {
  final LoginCoordinator coordinator;

  const LoginScreen({
    super.key,
    required this.coordinator,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor();
      return () => coordinator.deconstructor();
    }, []);

    return AnimatedScaffold(
      store: coordinator.widgets.animatedScaffold,
      child: Observer(builder: (context) {
        return MultiHitStack(
          children: [
            BackButton(
              store: coordinator.widgets.backButton,
              showWidget: coordinator.widgets.showWidgets,
            ),
            SmartHeader(
              content: "Log in",
              color: Colors.white,
              showWidget: coordinator.widgets.showWidgets,
            ),
            AuthTextFields(
              store: coordinator.widgets.authTextFields,
              showWidget: coordinator.widgets.showWidgets,
            ),
            AuthButton(
              isEnabled: coordinator.widgets.authTextFields.allInputsAreValid,
              showWidget: coordinator.widgets.showWidgets,
              onPressed: () => coordinator.logIn(),
              label: "Log in",
            ),
            FullScreen(
              child: WifiDisconnectOverlay(
                store: coordinator.widgets.wifiDisconnectOverlay,
              ),
            ),
          ],
        );
      }),
      //   ),
    );
  }
}
