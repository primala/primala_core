import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/modules/clean_up_collaboration_artifacts/clean_up_collaboration_artifacts.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/modules/user_information/user_information.dart';
import 'package:nokhte/app/modules/session/monetize/monetize.dart';
import 'package:nokhte/app/modules/session/session_widgets_module.dart';
import 'session.dart';
export 'core/core.dart';
export 'logic/session_logic.dart';
export 'constants/constants.dart';
export 'widgets/widgets.dart';
export 'polymorphic/polymorphic.dart';
export 'notes/notes.dart';
export 'hybrid/hybrid.dart';

class SessionModule extends Module {
  @override
  List<Module> get imports => [
        SessionWidgetsModule(),
        SessionNotesModule(),
        SessionCoreModule(),
        SessionPolymorphicModule(),
        SessionHybridModule(),
        CleanUpCollaborationArtifactsModule(),
        PosthogModule(),
        SessionLogicModule(),
        UserInformationModule(),
      ];

  @override
  void routes(r) {
    r.module(SessionConstants.notesModule, module: SessionNotesModule());
    r.module(SessionConstants.polymorphicModule,
        module: SessionPolymorphicModule());
    r.module(SessionConstants.hybridModule, module: SessionHybridModule());
    r.module(SessionConstants.coreModule, module: SessionCoreModule());
    r.module(SessionConstants.monetizeModule, module: SessionMonetizeModule());
  }
}
