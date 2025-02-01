import 'package:flutter_modular/flutter_modular.dart';
import 'core/modules/supabase/supabase.dart';
import 'modules/docs/docs.dart';
import 'modules/groups/groups.dart';
import 'modules/auth/auth.dart';
import 'modules/home/home.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [
        SupabaseModule(),
      ];

  @override
  void routes(r) {
    r.module(AuthConstants.module, module: AuthModule());
    r.module(HomeConstants.module, module: HomeModule());
    r.module(GroupsConstants.module, module: GroupsModule());
    r.module(DocsConstants.module, module: DocsModule());
  }
}
