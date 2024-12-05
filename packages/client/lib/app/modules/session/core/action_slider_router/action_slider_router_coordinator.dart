// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/modules/session/session.dart';
part 'action_slider_router_coordinator.g.dart';

class ActionSliderRouterCoordinator = _ActionSliderRouterCoordinatorBase
    with _$ActionSliderRouterCoordinator;

abstract class _ActionSliderRouterCoordinatorBase
    with Store, EnRoute, EnRouteRouter, BaseCoordinator, Reactions {
  final ActionSliderRouterWidgetsCoordinator widgets;
  final SessionPresenceCoordinator presence;

  final SessionMetadataStore sessionMetadata;

  @override
  final CaptureScreen captureScreen;

  _ActionSliderRouterCoordinatorBase({
    required this.widgets,
    required this.captureScreen,
    required this.presence,
  }) : sessionMetadata = presence.sessionMetadataStore {
    initEnRouteActions();
    initBaseCoordinatorActions();
  }

  @action
  constructor() async {
    widgets.preconstructor();
    disposers.add(sessionPresetReactor());
    Modular.dispose<SessionLogicModule>();
    await presence.listen();
  }

  sessionPresetReactor() =>
      reaction((p0) => sessionMetadata.presetsLogic.state, (p0) async {
        if (p0 == StoreState.loaded) {
          widgets.constructor();
        }
      });
}
