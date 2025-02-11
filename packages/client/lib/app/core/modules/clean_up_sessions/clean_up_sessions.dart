import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'clean_up_sessions.dart';
export 'data/data.dart';
export 'domain/domain.dart';
export 'mobx/mobx.dart';

class CleanUpSessionsModule extends Module {
  @override
  void exportedBinds(i) {
    i.add<CleanUpSessionsRemoteSourceImpl>(
      () => CleanUpSessionsRemoteSourceImpl(
        supabase: Modular.get<SupabaseClient>(),
      ),
    );
    i.add<CleanUpSessionsContractImpl>(
      () => CleanUpSessionsContractImpl(
        remoteSource: Modular.get<CleanUpSessionsRemoteSourceImpl>(),
        networkInfo: Modular.get<NetworkInfoImpl>(),
      ),
    );
    i.add<CleanUpSessionsCoordinator>(
      () => CleanUpSessionsCoordinator(
        contract: Modular.get<CleanUpSessionsContractImpl>(),
      ),
    );
  }
}
