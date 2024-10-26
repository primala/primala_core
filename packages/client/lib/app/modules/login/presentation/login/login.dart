export 'login_coordinator.dart';
export 'login_widgets_coordinator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/login/login.dart';
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

    return Observer(builder: (context) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Tap(
          store: coordinator.tap,
          child: MultiHitStack(
            children: [
              FullScreen(
                child: BeachWaves(
                  store: coordinator.widgets.beachWaves,
                ),
              ),
              LoginButtons(
                showLoginButtons: coordinator.widgets.showLoginButtons,
                onSignInWithApple: () async =>
                    await coordinator.logIn(AuthProvider.apple),
                onSignInWithGoogle: () async =>
                    await coordinator.logIn(AuthProvider.google),
              ),
              SmartText(
                opacityDuration: Seconds.get(1),
                store: coordinator.widgets.smartTextStore,
                bottomPadding: .20,
                fontWeight: FontWeight.w300,
              ),
              FullScreen(
                child: WifiDisconnectOverlay(
                  store: coordinator.widgets.wifiDisconnectOverlay,
                ),
              ),
            ],
          ),
        ),
        //   ),
      );
    });
  }
}
