import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/modules/settings/settings.dart';
import 'core/modules/supabase/supabase.dart';
import 'modules/home/home.dart';
import 'modules/login/login.dart';
import 'modules/session/session.dart';
import 'modules/session_starters/session_starters.dart';
import 'modules/storage/storage.dart';
import 'modules/presets/presets.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [SupabaseModule()];

  @override
  void routes(r) {
    r.module(LoginConstants.module, module: LoginModule());
    r.module(SettingsConstants.module, module: SettingsModule());
    r.module(HomeConstants.module, module: HomeModule());
    r.module(SessionStarterConstants.module, module: SessionStartersModule());
    r.module(SessionConstants.module, module: SessionModule());
    r.module(StorageConstants.module, module: StorageModule());
    r.module(PresetsConstants.module, module: PresetsModule());
  }
}
