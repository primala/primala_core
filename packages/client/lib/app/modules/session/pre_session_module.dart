import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/modules/active_group/active_group.dart';
import 'package:nokhte/app/core/modules/legacy_connectivity/legacy_connectivity.dart';
import 'package:nokhte/app/core/modules/supabase/supabase.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PreSessionModule extends Module {
  @override
  List<Module> get imports => [
        LegacyConnectivityModule(),
        SupabaseModule(),
        ActiveGroupModule(),
      ];

  @override
  exportedBinds(i) {
    i.add<PreSessionRemoteSourceImpl>(
      () => PreSessionRemoteSourceImpl(
        supabase: Modular.get<SupabaseClient>(),
      ),
    );

    i.add<PreSessionContractImpl>(
      () => PreSessionContractImpl(
        networkInfo: Modular.get<NetworkInfoImpl>(),
        remoteSource: Modular.get<PreSessionRemoteSourceImpl>(),
      ),
    );

    i.add<SessionStarterCoordinator>(
      () => SessionStarterCoordinator(
        contract: Modular.get<PreSessionContractImpl>(),
        activeGroup: Modular.get<ActiveGroup>(),
      ),
    );
  }
}
