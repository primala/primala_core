import 'package:nokhte/app/core/guards/auth_guard.dart';
import 'package:nokhte/app/core/modules/legacy_connectivity/legacy_connectivity.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'auth.dart';

class AuthModule extends Module {
  @override
  List<Module> get imports => [
        AuthWidgetsModule(),
        PosthogModule(),
        LegacyConnectivityModule(),
      ];

  @override
  binds(i) {
    i.add<AuthRemoteSourceImpl>(
      () => AuthRemoteSourceImpl(
        supabase: Modular.get<SupabaseClient>(),
      ),
    );
    i.add<AuthContractImpl>(
      () => AuthContractImpl(
        remoteSource: i<AuthRemoteSourceImpl>(),
        networkInfo: Modular.get<NetworkInfoImpl>(),
      ),
    );

    i.add<LoginCoordinator>(
      () => LoginCoordinator(
        contract: i.get<AuthContractImpl>(),
        identifyUser: Modular.get<IdentifyUser>(),
        captureScreen: Modular.get<CaptureScreen>(),
        widgets: Modular.get<LoginWidgetsCoordinator>(),
      ),
    );

    i.add<LoginGreeterCoordinator>(
      () => LoginGreeterCoordinator(
        contract: i.get<AuthContractImpl>(),
        identifyUser: Modular.get<IdentifyUser>(),
        captureScreen: Modular.get<CaptureScreen>(),
        widgets: Modular.get<LoginGreeterWidgetsCoordinator>(),
      ),
    );

    i.add<SignupCoordinator>(
      () => SignupCoordinator(
        contract: i.get<AuthContractImpl>(),
        identifyUser: Modular.get<IdentifyUser>(),
        captureScreen: Modular.get<CaptureScreen>(),
        widgets: Modular.get<SignupWidgetsCoordinator>(),
      ),
    );
  }

  @override
  routes(r) {
    r.child(
      AuthConstants.relativeGreeter,
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
      AuthConstants.relativeSignup,
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
      AuthConstants.relativeLogin,
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
