import 'package:nokhte/app/core/guards/auth_guard.dart';
import 'package:nokhte/app/core/modules/legacy_connectivity/legacy_connectivity.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/modules/user_information/user_information.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'login.dart';
export 'constants/constants.dart';
export 'data/data.dart';
export 'domain/domain.dart';
export 'presentation/presentation.dart';
export 'types/types.dart';
export 'login_widgets_module.dart';

class LoginModule extends Module {
  @override
  List<Module> get imports => [
        LoginWidgetsModule(),
        PosthogModule(),
        UserInformationModule(),
        LegacyConnectivityModule(),
      ];

  @override
  binds(i) {
    i.add<LoginRemoteSourceImpl>(
      () => LoginRemoteSourceImpl(
        supabase: Modular.get<SupabaseClient>(),
      ),
    );
    i.add<LoginContractImpl>(
      () => LoginContractImpl(
        remoteSource: i<LoginRemoteSourceImpl>(),
        networkInfo: Modular.get<NetworkInfoImpl>(),
      ),
    );

    i.add<LoginCoordinator>(
      () => LoginCoordinator(
        contract: i.get<LoginContractImpl>(),
        identifyUser: Modular.get<IdentifyUser>(),
        captureScreen: Modular.get<CaptureScreen>(),
        userInfo: Modular.get<UserInformationCoordinator>(),
        tap: TapDetector(),
        widgets: Modular.get<LoginWidgetsCoordinator>(),
      ),
    );

    i.add<LoginGreeterCoordinator>(
      () => LoginGreeterCoordinator(
        contract: i.get<LoginContractImpl>(),
        identifyUser: Modular.get<IdentifyUser>(),
        captureScreen: Modular.get<CaptureScreen>(),
        userInfo: Modular.get<UserInformationCoordinator>(),
        tap: TapDetector(),
        widgets: Modular.get<LoginGreeterWidgetsCoordinator>(),
      ),
    );

    i.add<SignupCoordinator>(
      () => SignupCoordinator(
        contract: i.get<LoginContractImpl>(),
        identifyUser: Modular.get<IdentifyUser>(),
        captureScreen: Modular.get<CaptureScreen>(),
        userInfo: Modular.get<UserInformationCoordinator>(),
        tap: TapDetector(),
        widgets: Modular.get<SignupWidgetsCoordinator>(),
      ),
    );
  }

  @override
  routes(r) {
    r.child(
      LoginConstants.relativeGreeter,
      child: (context) => LoginGreeterScreen(
        coordinator: Modular.get<LoginGreeterCoordinator>(),
      ),
      transition: TransitionType.noTransition,
      guards: [
        AuthGuard(
          supabase: Modular.get<SupabaseClient>(),
        ),
      ],
    );

    r.child(
      LoginConstants.relativeSignup,
      transition: TransitionType.noTransition,
      child: (context) => SignupScreen(
        coordinator: Modular.get<SignupCoordinator>(),
      ),
      guards: [
        AuthGuard(
          supabase: Modular.get<SupabaseClient>(),
        ),
      ],
    );

    r.child(
      LoginConstants.relativeLogin,
      transition: TransitionType.noTransition,
      child: (context) => LoginScreen(
        coordinator: Modular.get<LoginCoordinator>(),
      ),
      guards: [
        AuthGuard(
          supabase: Modular.get<SupabaseClient>(),
        ),
      ],
    );
  }
}
