export 'signup_coordinator.dart';
export 'signup_widgets_coordinator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/auth/auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SignupScreen extends HookWidget {
  final SignupCoordinator coordinator;

  const SignupScreen({
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
      return AnimatedScaffold(
        showWidgets: coordinator.widgets.showWidgets,
        store: coordinator.widgets.animatedScaffold,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          HeaderRow(
            children: [
              LeftChevron(
                onTap: coordinator.onGoBack,
                color: Colors.white,
              ),
              const SmartHeader(
                content: "Sign up",
                color: Colors.white,
              ),
              const LeftChevron()
            ],
          ),
          AuthTextFields(
            store: coordinator.widgets.authTextFields,
            showWidget: coordinator.widgets.showWidgets,
          ),
          GenericButton(
            color: Colors.white,
            useFixedSize: true,
            isEnabled: coordinator.widgets.authTextFields.allInputsAreValid,
            onPressed: () => coordinator.signUp(),
            label: "Sign up",
          ),
        ],
      );
    });
  }
}
