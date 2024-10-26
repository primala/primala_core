import 'package:nokhte/app/core/guards/auth_guard.dart';
import 'package:nokhte/app/core/modules/legacy_connectivity/legacy_connectivity.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/modules/user_information/user_information.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/login/domain/logic/add_metadata.dart';
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
    i.add<AddName>(
      () => AddName(
        contract: i.get<LoginContractImpl>(),
      ),
    );

    i.add<GetLoginState>(
      () => GetLoginState(
        contract: i.get<LoginContractImpl>(),
      ),
    );
    i.add<SignInWithApple>(
      () => SignInWithApple(
        contract: i.get<LoginContractImpl>(),
      ),
    );
    i.add<AddMetadata>(
      () => AddMetadata(
        contract: i.get<LoginContractImpl>(),
      ),
    );
    i.add<SignInWithGoogle>(
      () => SignInWithGoogle(
        contract: i.get<LoginContractImpl>(),
      ),
    );
    i.add<SignInWithAuthProviderStore>(
      () => SignInWithAuthProviderStore(
        signInWithApple: i.get<SignInWithApple>(),
        signInWithGoogle: i.get<SignInWithGoogle>(),
      ),
    );
    i.add<GetLoginStateStore>(
      () => GetLoginStateStore(
        logic: i<GetLoginState>(),
      ),
    );
    i.add<LoginCoordinator>(
      () => LoginCoordinator(
        identifyUser: Modular.get<IdentifyUser>(),
        addMetadata: Modular.get<AddMetadata>(),
        captureScreen: Modular.get<CaptureScreen>(),
        userInfo: Modular.get<UserInformationCoordinator>(),
        tap: TapDetector(),
        addName: Modular.get<AddName>(),
        widgets: Modular.get<LoginScreenWidgetsCoordinator>(),
        signInWithAuthProvider: i<SignInWithAuthProviderStore>(),
        authStateStore: i<GetLoginStateStore>(),
      ),
    );
  }

  @override
  routes(r) {
    r.child(
      LoginConstants.relativeRoot,
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
