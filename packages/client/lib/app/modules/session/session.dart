import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/modules/clean_up_collaboration_artifacts/clean_up_collaboration_artifacts.dart';
import 'package:nokhte/app/core/modules/deep_links/deep_links.dart';
import 'package:nokhte/app/core/modules/gyroscopic/gyroscopic.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/modules/session_presence/session_presence.dart';
import 'package:nokhte/app/core/modules/user_information/user_information.dart';
import 'package:nokhte/app/modules/session/monetize/monetize.dart';
import 'package:nokhte/app/modules/session/session_widgets_module.dart';
import 'session.dart';
export 'core/core.dart';
export 'instructions/instructions.dart';
export 'constants/constants.dart';
export 'types/types.dart';
export 'speaking/speaking.dart';
export 'notes/notes.dart';
export 'hybrid/hybrid.dart';

class SessionModule extends Module {
  @override
  List<Module> get imports => [
        SessionWidgetsModule(),
        SessionNotesModule(),
        SessionCoreModule(),
        SessionSpeakingModule(),
        SessionInstructionsModule(),
        SessionHybridModule(),
        CleanUpCollaborationArtifactsModule(),
        PosthogModule(),
        SessionPresenceModule(),
        GyroscopicModule(),
        UserInformationModule(),
        DeepLinksModule(),
      ];

  @override
  void routes(r) {
    r.module(
      SessionConstants.instructionsModule,
      module: SessionInstructionsModule(),
    );
    r.module('/notes', module: SessionNotesModule());
    r.module('/speaking', module: SessionSpeakingModule());
    r.module('/hybrid', module: SessionHybridModule());
    r.module('/core', module: SessionCoreModule());
    r.module('/monetize', module: SessionMonetizeModule());
  }
}
