import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/modules/legacy_connectivity/legacy_connectivity.dart';
import 'package:nokhte/app/core/modules/supabase/supabase.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:nokhte/app/modules/presets/presets.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'session_logic.dart';
export 'data/data.dart';
export 'types/types.dart';
export 'widgets/widgets.dart';
export 'domain/domain.dart';
export 'mobx/mobx.dart';

class SessionLogicModule extends Module {
  @override
  List<Module> get imports => [
        SupabaseModule(),
        LegacyConnectivityModule(),
        StorageLogicModule(),
        PresetsModule(),
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
        storageLogic: Modular.get<StorageLogicCoordinator>(),
        presetsLogic: Modular.get<PresetsLogicCoordinator>(),
        contract: Modular.get<SessionPresenceContractImpl>(),
      ),
    );

    i.addSingleton<SessionPresenceCoordinator>(
      () => SessionPresenceCoordinator(
        // incidentsOverlayStore: CollaboratorPresenceIncidentsOverlayStore(
        //   sessionMetadataStore: Modular.get<SessionMetadataStore>(),
        // ),
        contract: i<SessionPresenceContractImpl>(),
        sessionMetadataStore: Modular.get<SessionMetadataStore>(),
      ),
    );
  }
}
