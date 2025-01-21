import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/modules/settings/settings.dart';
import 'core/modules/supabase/supabase.dart';
import 'modules/groups/groups.dart';
import 'modules/home/home.dart';
import 'modules/auth/auth.dart';
import 'modules/session/session.dart';
import 'modules/storage/storage.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [SupabaseModule()];

  @override
  void routes(r) {
    r.module(AuthConstants.module, module: AuthModule());
    r.module(GroupsConstants.module, module: GroupsModule());
    r.module(SettingsConstants.module, module: SettingsModule());
    r.module(HomeConstants.module, module: HomeModule());
    r.module(SessionConstants.module, module: SessionModule());
    r.module(StorageConstants.module, module: StorageModule());
  }
}
