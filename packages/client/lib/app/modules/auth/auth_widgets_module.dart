import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/auth/auth.dart';

class AuthWidgetsModule extends Module {
  @override
  List<Module> get imports => [
        ConnectivityModule(),
      ];

  @override
  exportedBinds(i) {
    i.add<LoginWidgetsCoordinator>(
      () => LoginWidgetsCoordinator(
        authTextFields: AuthTextFieldsStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        animatedScaffold: AnimatedScaffoldStore(),
      ),
    );

    i.add<LoginGreeterWidgetsCoordinator>(
      () => LoginGreeterWidgetsCoordinator(
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        animatedScaffold: AnimatedScaffoldStore(),
      ),
    );

    i.add<SignupWidgetsCoordinator>(
      () => SignupWidgetsCoordinator(
        authTextFields: AuthTextFieldsStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
        animatedScaffold: AnimatedScaffoldStore(),
      ),
    );
  }
}
