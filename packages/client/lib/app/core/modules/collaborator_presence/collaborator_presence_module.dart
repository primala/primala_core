import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/modules/supabase/supabase_module.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'domain/domain.dart';
import 'mobx/mobx.dart';
import 'data/data.dart';

class CollaboratorPresenceModule extends Module {
  @override
  List<Module> get imports => [
        SupabaseModule(),
      ];
  @override
  void exportedBinds(Injector i) {
    i.add<CollaboratorPresenceRemoteSourceImpl>(
      () => CollaboratorPresenceRemoteSourceImpl(
        supabase: Modular.get<SupabaseClient>(),
      ),
    );
    i.add<CollaboratorPresenceContractImpl>(
      () => CollaboratorPresenceContractImpl(
        remoteSource: i<CollaboratorPresenceRemoteSourceImpl>(),
        networkInfo: Modular.get<NetworkInfoImpl>(),
      ),
    );
    i.add<GetSessionMetadata>(
      () => GetSessionMetadata(
        contract: i<CollaboratorPresenceContractImpl>(),
      ),
    );
    i.add<UpdateCurrentPhase>(
      () => UpdateCurrentPhase(
        contract: i<CollaboratorPresenceContractImpl>(),
      ),
    );
    i.add<UpdateOnCallStatus>(
      () => UpdateOnCallStatus(
        contract: i<CollaboratorPresenceContractImpl>(),
      ),
    );
    i.add<CancelSessionMetadataStream>(
      () => CancelSessionMetadataStream(
        contract: i<CollaboratorPresenceContractImpl>(),
      ),
    );
    i.add<UpdateOnlineStatus>(
      () => UpdateOnlineStatus(
        contract: i<CollaboratorPresenceContractImpl>(),
      ),
    );
    i.add<UpdateTimerStatus>(
      () => UpdateTimerStatus(
        contract: i<CollaboratorPresenceContractImpl>(),
      ),
    );
    i.add<UpdateWhoIsTalking>(
      () => UpdateWhoIsTalking(
        contract: i<CollaboratorPresenceContractImpl>(),
      ),
    );
    i.add<GetSessionMetadataStore>(
      () => GetSessionMetadataStore(
        logic: i<GetSessionMetadata>(),
      ),
    );
    i.add<NokhteBlurStore>(
      () => NokhteBlurStore(),
    );
    i.add<CollaboratorPresenceCoordinator>(
      () => CollaboratorPresenceCoordinator(
        blur: i<NokhteBlurStore>(),
        cancelSessionMetadataStreamLogic: i<CancelSessionMetadataStream>(),
        updateCurrentPhaseLogic: i<UpdateCurrentPhase>(),
        getSessionMetadataStore: i<GetSessionMetadataStore>(),
        updateCallStatusLogic: i<UpdateOnCallStatus>(),
        updateOnlineStatusLogic: i<UpdateOnlineStatus>(),
        updateTimerStatusLogic: i<UpdateTimerStatus>(),
        updateWhoIsTalkingLogic: i<UpdateWhoIsTalking>(),
      ),
    );
  }
}
