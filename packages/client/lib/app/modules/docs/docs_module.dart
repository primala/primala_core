import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/modules/active_group/active_group.dart';
import 'package:nokhte/app/core/modules/supabase/supabase.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:nokhte/app/modules/docs/docs.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DocsModule extends Module {
  @override
  List<Module> get imports => [
        SupabaseModule(),
        ActiveGroupModule(),
        DocsLogicModule(),
      ];
  @override
  binds(i) {
    i.add<DocsRemoteSourceImpl>(
      () => DocsRemoteSourceImpl(
        supabase: Modular.get<SupabaseClient>(),
      ),
    );
    i.add<DocsContractImpl>(
      () => DocsContractImpl(
        remoteSource: i<DocsRemoteSourceImpl>(),
        networkInfo: Modular.get<NetworkInfoImpl>(),
      ),
    );
    i.add<ViewDocCoordinator>(
      () => ViewDocCoordinator(
        contract: i<DocsContractImpl>(),
        activeGroup: Modular.get<ActiveGroup>(),
        blockTextDisplay: BlockTextDisplayStore(
          blockTextFields: BlockTextFieldsStore(),
        ),
      ),
    );

    i.add<DocsHubCoordinator>(
      () => DocsHubCoordinator(
        contract: i<DocsContractImpl>(),
        viewDocCoordinator: Modular.get<ViewDocCoordinator>(),
        activeGroup: Modular.get<ActiveGroup>(),
      ),
    );

    i.add<CreateDocCoordinator>(
      () => CreateDocCoordinator(
        contract: i<DocsContractImpl>(),
        activeGroup: Modular.get<ActiveGroup>(),
      ),
    );
  }

  @override
  routes(r) {
    r.child(
      DocsConstants.relativeDocsHub,
      transition: TransitionType.noTransition,
      child: (context) => DocsHubScreen(
        coordinator: Modular.get<DocsHubCoordinator>(),
      ),
    );
  }
}
