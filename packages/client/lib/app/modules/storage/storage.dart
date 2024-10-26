import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/modules/legacy_connectivity/legacy_connectivity.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/modules/supabase/supabase.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'storage.dart';
export 'data/data.dart';
export 'domain/domain.dart';
export 'presentation/presentation.dart';
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
        SupabaseModule(),
        StorageLogicModule(),
      ];
  @override
  void binds(i) {
    i.add<StorageHomeCoordinator>(
      () => StorageHomeCoordinator(
        tap: TapDetector(),
        getNokhteSessionArtifactsLogic:
            Modular.get<GetNokhteSessionArtifacts>(),
        updateSessionAliasLogic: Modular.get<UpdateSessionAlias>(),
        captureScreen: Modular.get<CaptureScreen>(),
        widgets: Modular.get<StorageHomeWidgetsCoordinator>(),
        swipe: SwipeDetector(),
      ),
    );
    i.add<StorageContentCoordinator>(
      () => StorageContentCoordinator(
        captureScreen: Modular.get<CaptureScreen>(),
        widgets: Modular.get<StorageContentWidgetsCoordinator>(),
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
    r.child(
      StorageConstants.relativeContent,
      transition: TransitionType.noTransition,
      child: (context) => StorageContentScreen(
        coordinator: Modular.get<StorageContentCoordinator>(),
      ),
    );
  }
}
