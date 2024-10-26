import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/modules/legacy_connectivity/legacy_connectivity.dart';
import 'package:nokhte/app/core/modules/supabase/supabase.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'presets.dart';
export 'data/data.dart';
export 'constants/constants.dart';
export 'domain/domain.dart';
export 'types/types.dart';

class PresetsModule extends Module {
  @override
  List<Module> get imports => [
        LegacyConnectivityModule(),
        SupabaseModule(),
      ];

  @override
  void exportedBinds(i) {
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

    i.add<PresetsLogicCoordinator>(
      () => PresetsLogicCoordinator(
        contract: Modular.get<PresetsContractImpl>(),
      ),
    );
  }
}
