export 'login_greeter_coordinator.dart';
export 'login_greeter_widgets_coordinator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/auth/auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoginGreeterScreen extends HookWidget {
  final LoginGreeterCoordinator coordinator;

  const LoginGreeterScreen({
    super.key,
    required this.coordinator,
  });

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      coordinator.constructor();
      return () => coordinator.deconstructor();
    }, []);
    final screenSize = useFullScreenSize();
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    return AnimatedScaffold(
      store: coordinator.widgets.animatedScaffold,
      child: Observer(builder: (context) {
        return MultiHitStack(
          children: [
            AnimatedOpacity(
              duration: Seconds.get(0, milli: 500),
              opacity: useWidgetOpacity(coordinator.widgets.showWidgets),
              child: Padding(
                padding: EdgeInsets.only(bottom: screenHeight * .7),
                child: Center(
                  child: Image.asset(
                    "assets/login/header.png",
                    width: screenWidth * .5,
                  ),
                ),
              ),
            ),
            // SmartHeader(
            //   content: "NOKHTE",
            //   showWidget: coordinator.widgets.showWidgets,
            // ),
            LoginButtons(
              showWidget: coordinator.widgets.showWidgets,
              onSignInWithApple: () async =>
                  await coordinator.signInWithApple(),
              onSignInWithGoogle: () async =>
                  await coordinator.signInWithGoogle(),
              onLogIn: () => coordinator.onLogIn(),
              onSignUp: () => coordinator.onSignUp(),
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
