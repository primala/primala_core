import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/modules/legacy_connectivity/legacy_connectivity.dart';
import 'package:nokhte/app/core/modules/supabase/supabase.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:nokhte/app/modules/home/home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeLogicModule extends Module {
  @override
  List<Module> get imports => [
        LegacyConnectivityModule(),
        SupabaseModule(),
      ];

  @override
  void exportedBinds(i) {
    i.add<HomeRemoteSourceImpl>(
      () => HomeRemoteSourceImpl(
        supabase: Modular.get<SupabaseClient>(),
      ),
    );

    i.add<HomeContractImpl>(
      () => HomeContractImpl(
        networkInfo: Modular.get<NetworkInfoImpl>(),
        remoteSource: Modular.get<HomeRemoteSourceImpl>(),
      ),
    );
  }
}
