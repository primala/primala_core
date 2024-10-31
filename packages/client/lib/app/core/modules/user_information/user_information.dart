import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'user_information.dart';
export 'data/data.dart';
export 'domain/domain.dart';
export 'mobx/mobx.dart';

class UserInformationModule extends Module {
  @override
  void exportedBinds(Injector i) {
    i.add<UserInformationRemoteSourceImpl>(
      () => UserInformationRemoteSourceImpl(
        supabase: Modular.get<SupabaseClient>(),
      ),
    );
    i.add<UserInformationContractImpl>(
      () => UserInformationContractImpl(
        remoteSource: i<UserInformationRemoteSourceImpl>(),
        networkInfo: Modular.get<NetworkInfoImpl>(),
      ),
    );

    i.add<UserInformationCoordinator>(
      () => UserInformationCoordinator(
        contract: i<UserInformationContractImpl>(),
      ),
    );
  }
}
