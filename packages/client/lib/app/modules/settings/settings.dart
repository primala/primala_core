import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/modules/legacy_connectivity/legacy_connectivity.dart';
import 'package:nokhte/app/core/modules/supabase/supabase.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/settings/settings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

export './presentation/presentation.dart';
export './data/data.dart';
export 'constants/constants.dart';

class SettingsModule extends Module {
  @override
  List<Module> get imports => [
        ConnectivityModule(),
        SupabaseModule(),
        LegacyConnectivityModule(),
      ];
  @override
  binds(i) {
    i.add<SettingsRemoteSourceImpl>(
      () => SettingsRemoteSourceImpl(
        supabase: Modular.get<SupabaseClient>(),
      ),
    );
    i.add<SettingsContractImpl>(
      () => SettingsContractImpl(
        remoteSource: Modular.get<SettingsRemoteSourceImpl>(),
        networkInfo: Modular.get<NetworkInfoImpl>(),
      ),
    );
    i.add<SettingsWidgetsCoordinator>(
      () => SettingsWidgetsCoordinator(
        navigationCarousels: NavigationCarouselsStore(
          beachWaves: BeachWavesStore(),
        ),
        primarySmartText: SmartTextStore(),
        secondarySmartText: SmartTextStore(),
        wifiDisconnectOverlay: Modular.get<WifiDisconnectOverlayStore>(),
      ),
    );

    i.add<SettingsCoordinator>(
      () => SettingsCoordinator(
        widgets: Modular.get<SettingsWidgetsCoordinator>(),
        logic: Modular.get<SettingsContractImpl>(),
      ),
    );
  }

  @override
  void routes(r) {
    r.child(
      SettingsConstants.relativeSettings,
      transition: TransitionType.noTransition,
      child: (context) => SettingsScreen(
        coordinator: Modular.get<SettingsCoordinator>(),
      ),
    );
  }
}
