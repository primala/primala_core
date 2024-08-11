import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/modules/legacy_connectivity/legacy_connectivity.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/modules/supabase/supabase.dart';
import 'package:nokhte/app/core/modules/user_information/user_information.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'presets.dart';
export 'presets_widgets.dart';
export 'data/data.dart';
export 'constants/constants.dart';
export 'domain/domain.dart';
export 'presentation/presentation.dart';

class PresetsModule extends Module {
  @override
  List<Module> get imports => [
        UserInformationModule(),
        LegacyConnectivityModule(),
        PosthogModule(),
        PresetsWidgetsModule(),
        SupabaseModule(),
      ];

  @override
  void binds(i) {
    i.add<PresetsRemoteSourceImpl>(
      () => PresetsRemoteSourceImpl(
        supabase: Modular.get<SupabaseClient>(),
      ),
    );

    i.add<PresetsContractImpl>(
      () => PresetsContractImpl(
        remoteSource: i<PresetsRemoteSourceImpl>(),
        networkInfo: Modular.get<NetworkInfoImpl>(),
      ),
    );
    i.add<GetCompanyPresets>(
      () => GetCompanyPresets(
        contract: Modular.get<PresetsContractImpl>(),
      ),
    );
    i.add<PresetsLogicCoordinator>(
      () => PresetsLogicCoordinator(
        getCompanyPresetsLogic: Modular.get<GetCompanyPresets>(),
      ),
    );
    i.add<PresetsCoordinator>(
      () => PresetsCoordinator(
        tap: TapDetector(),
        captureScreen: Modular.get<CaptureScreen>(),
        widgets: Modular.get<PresetsWidgetsCoordinator>(),
        logic: Modular.get<PresetsLogicCoordinator>(),
        userInformation: Modular.get<UserInformationCoordinator>(),
        swipe: SwipeDetector(),
      ),
    );
    i.add<PresetsInstructionsCoordinator>(
      () => PresetsInstructionsCoordinator(
        userInformation: Modular.get<UserInformationCoordinator>(),
        tap: TapDetector(),
        logic: Modular.get<PresetsLogicCoordinator>(),
        captureScreen: Modular.get<CaptureScreen>(),
        widgets: Modular.get<PresetsInstructionsWidgetsCoordinator>(),
      ),
    );
  }

  @override
  void routes(r) {
    r.child(
      PresetsConstants.relativePresets,
      transition: TransitionType.noTransition,
      child: (context) => PresetsScreen(
        coordinator: Modular.get<PresetsCoordinator>(),
      ),
    );
    r.child(
      PresetsConstants.relativePresetsInstructions,
      transition: TransitionType.noTransition,
      child: (context) => PresetsInstructionsScreen(
        coordinator: Modular.get<PresetsInstructionsCoordinator>(),
      ),
    );
  }
}
