import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/modules/legacy_connectivity/legacy_connectivity.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/modules/session_content/session_content.dart';
import 'package:nokhte/app/core/modules/supabase/supabase.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'storage.dart';
export 'data/data.dart';
export 'domain/domain.dart';
export 'presentation/storage_home.dart';
export 'constants/constants.dart';
export 'storage_logic_module.dart';
export 'storage_widgets_module.dart';
export 'widgets/widgets.dart';

class StorageModule extends Module {
  @override
  List<Module> get imports => [
        LegacyConnectivityModule(),
        StorageWidgetsModule(),
        PosthogModule(),
        SessionContentModule(),
        SupabaseModule(),
        StorageLogicModule(),
      ];
  @override
  void binds(i) {
    i.add<StorageHomeCoordinator>(
      () => StorageHomeCoordinator(
        sessionContentLogic: Modular.get<SessionContentLogicCoordinator>(),
        tap: TapDetector(),
        storageLogic: Modular.get<StorageLogicCoordinator>(),
        captureScreen: Modular.get<CaptureScreen>(),
        widgets: Modular.get<StorageHomeWidgetsCoordinator>(),
        swipe: SwipeDetector(),
      ),
    );
  }

  @override
  void routes(r) {
    r.child(
      StorageConstants.relativeHome,
      transition: TransitionType.noTransition,
      child: (context) => StorageHomeScreen(
        coordinator: Modular.get<StorageHomeCoordinator>(),
      ),
    );
  }
}
