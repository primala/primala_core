import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/modules/legacy_connectivity/legacy_connectivity.dart';
import 'package:nokhte/app/core/modules/supabase/supabase.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:nokhte/app/modules/docs/docs.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'session_logic.dart';
export 'contracts/contracts.dart';
export 'sources/sources.dart';
export 'types/types.dart';
export 'params/params.dart';
export 'mobx/mobx.dart';

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
        docsContract: Modular.get<DocsContractImpl>(),
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
