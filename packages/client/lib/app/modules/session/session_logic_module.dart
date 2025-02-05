import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/modules/legacy_connectivity/legacy_connectivity.dart';
import 'package:nokhte/app/core/modules/supabase/supabase.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SessionLogicModule extends Module {
  @override
  List<Module> get imports => [
        SupabaseModule(),
        LegacyConnectivityModule(),
      ];
  @override
  void exportedBinds(i) {
    i.add<SessionPresenceRemoteSourceImpl>(
      () => SessionPresenceRemoteSourceImpl(
        supabase: Modular.get<SupabaseClient>(),
      ),
    );
    i.add<SessionPresenceContractImpl>(
      () => SessionPresenceContractImpl(
        remoteSource: i<SessionPresenceRemoteSourceImpl>(),
        networkInfo: Modular.get<NetworkInfoImpl>(),
      ),
    );
    i.add<SessionMetadataStore>(
      () => SessionMetadataStore(
        contract: Modular.get<SessionPresenceContractImpl>(),
      ),
    );

    i.addSingleton<SessionPresenceCoordinator>(
      () => SessionPresenceCoordinator(
        contract: i<SessionPresenceContractImpl>(),
        sessionMetadataStore: Modular.get<SessionMetadataStore>(),
      ),
    );
  }
}
