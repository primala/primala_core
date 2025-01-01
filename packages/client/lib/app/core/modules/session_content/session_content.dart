export 'domain/domain.dart';
export 'data/data.dart';
export 'widgets/widgets.dart';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'session_content.dart';

class SessionContentModule extends Module {
  @override
  void exportedBinds(Injector i) {
    i.add<SessionContentRemoteSourceImpl>(
      () => SessionContentRemoteSourceImpl(
        supabase: Modular.get<SupabaseClient>(),
      ),
    );
    i.add<SessionContentContractImpl>(
      () => SessionContentContractImpl(
        remoteSource: i<SessionContentRemoteSourceImpl>(),
        networkInfo: Modular.get<NetworkInfoImpl>(),
      ),
    );

    i.add<SessionContentLogicCoordinator>(
      () => SessionContentLogicCoordinator(
        contract: i<SessionContentContractImpl>(),
      ),
    );
  }
}
