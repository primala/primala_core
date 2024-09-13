export 'login_coordinator.dart';
export 'login_widgets_coordinator.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/hooks/hooks.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/login/login.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginScreen extends HookWidget {
  final LoginCoordinator coordinator;

  const LoginScreen({
    super.key,
    required this.coordinator,
  });

  @override
  Widget build(BuildContext context) {
    final center = useCenterOffset();
    final width = useFullScreenSize().width;
    final screenSize = useFullScreenSize();
    useEffect(() {
      coordinator.constructor(center);
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
                  store: coordinator.widgets.layer1BeachWaves,
                ),
              ),
              FullScreen(
                child: BeachWaves(
                  store: coordinator.widgets.layer2BeachWaves,
                ),
              ),
              AnimatedOpacity(
                opacity: useWidgetOpacity(coordinator.widgets.showLoginButtons),
                duration: Seconds.get(1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Opacity(
                      opacity: Platform.isIOS ? 1 : .5,
                      child: Center(
                        child: SignInButton(
                          Buttons.apple,
                          padding: EdgeInsets.symmetric(
                            horizontal: useScaledSize(
                              baseValue: .04,
                              screenSize: screenSize,
                              bumpPerHundredth: 0.0005,
                            ),
                            vertical: useScaledSize(
                              baseValue: .012,
                              screenSize: screenSize,
                              bumpPerHundredth: 0.0001,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          text: "Sign in with Apple",
                          onPressed: () async => Platform.isIOS
                              ? await coordinator.logIn(AuthProvider.apple)
                              : null,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: width * .2,
                        top: width * .06,
                      ),
                      child: Center(
                        child: SignInButton(
                          Buttons.google,
                          padding: EdgeInsets.symmetric(
                            horizontal: useScaledSize(
                              baseValue: .04,
                              screenSize: screenSize,
                              bumpPerHundredth: 0.0005,
                            ),
                            vertical: useScaledSize(
                              baseValue: .006,
                              screenSize: screenSize,
                              bumpPerHundredth: 0.0001,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          text: "Sign in with Google",
                          onPressed: () async =>
                              await coordinator.logIn(AuthProvider.google),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SmartText(
                opacityDuration: Seconds.get(1),
                store: coordinator.widgets.smartTextStore,
                bottomPadding: .20,
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
