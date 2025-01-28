import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/modules/legacy_connectivity/legacy_connectivity.dart';
import 'package:nokhte/app/core/modules/supabase/supabase.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:nokhte/app/modules/groups/groups.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GroupsLogicModule extends Module {
  @override
  List<Module> get imports => [
        LegacyConnectivityModule(),
        SupabaseModule(),
      ];
  @override
  binds(i) {
    i.add<GroupsRemoteSourceImpl>(
      () => GroupsRemoteSourceImpl(
        supabase: Modular.get<SupabaseClient>(),
      ),
    );

    i.add<UserRemoteSourceImpl>(
      () => UserRemoteSourceImpl(
        supabase: Modular.get<SupabaseClient>(),
      ),
    );

    i.add<GroupRolesRemoteSourceImpl>(
      () => GroupRolesRemoteSourceImpl(
        supabase: Modular.get<SupabaseClient>(),
      ),
    );

    i.add<GroupsContractImpl>(
      () => GroupsContractImpl(
        networkInfo: Modular.get<NetworkInfoImpl>(),
        remoteSource: Modular.get<GroupsRemoteSourceImpl>(),
      ),
    );

    i.add<GroupRolesContractImpl>(
      () => GroupRolesContractImpl(
        networkInfo: Modular.get<NetworkInfoImpl>(),
        remoteSource: Modular.get<GroupRolesRemoteSourceImpl>(),
      ),
    );

    i.add<UserContractImpl>(
      () => UserContractImpl(
        networkInfo: Modular.get<NetworkInfoImpl>(),
        remoteSource: Modular.get<UserRemoteSourceImpl>(),
      ),
    );
  }
}
