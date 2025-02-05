import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/modules/supabase/supabase.dart';
import 'package:nokhte/app/core/network/network_info.dart';
import 'package:nokhte/app/modules/docs/docs.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DocsLogicModule extends Module {
  @override
  List<Module> get imports => [
        SupabaseModule(),
      ];
  @override
  exportedBinds(i) {
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
  }
}
