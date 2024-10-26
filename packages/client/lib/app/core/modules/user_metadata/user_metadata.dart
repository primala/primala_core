import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/modules/legacy_connectivity/legacy_connectivity.dart';
import 'package:nokhte/app/core/modules/supabase/supabase.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'user_metadata.dart';

export 'data/data.dart';
export 'domain/domain.dart';
export 'mobx/mobx.dart';

class UserMetadataModule extends Module {
  @override
  List<Module> get imports => [
        SupabaseModule(),
        LegacyConnectivityModule(),
      ];
  @override
  void exportedBinds(i) {
    i.add<UserMetadataRemoteSourceImpl>(
      () => UserMetadataRemoteSourceImpl(
        supabase: Modular.get<SupabaseClient>(),
      ),
    );
    i.add<UserMetadataContractImpl>(
      () => UserMetadataContractImpl(
        remoteSource: Modular.get<UserMetadataRemoteSourceImpl>(),
        networkInfo: Modular.get<NetworkInfoImpl>(),
      ),
    );
    i.add<UserMetadataCoordinator>(
      () => UserMetadataCoordinator(
        contract: Modular.get<UserMetadataContractImpl>(),
      ),
    );
  }
}
