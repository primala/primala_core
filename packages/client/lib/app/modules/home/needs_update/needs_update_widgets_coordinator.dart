// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
part 'needs_update_widgets_coordinator.g.dart';

class NeedsUpdateWidgetsCoordinator = _NeedsUpdateWidgetsCoordinatorBase
    with _$NeedsUpdateWidgetsCoordinator;

abstract class _NeedsUpdateWidgetsCoordinatorBase
    with
        Store,
        EnRoute,
        Reactions,
        EnRouteConsumer,
        BaseWidgetsCoordinator,
        EnRouteWidgetsRouter {
  final GestureCrossStore gestureCross;
  final TintStore tint;
  final NokhteGradientTextStore gradientText;
  @override
  final BeachWavesStore beachWaves;
  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;

  _NeedsUpdateWidgetsCoordinatorBase({
    required this.gestureCross,
    required this.beachWaves,
    required this.tint,
    required this.gradientText,
    required this.wifiDisconnectOverlay,
  }) {
    initEnRouteActions();
    initBaseWidgetsCoordinatorActions();
    setupEnRouteWidgets();
  }

  @action
  constructor() {
    consumeRoutingArgs();
    gestureCross.fadeInTheCross();
    disposers.add(beachWavesMovieStatusReactor());
    tint.initMovie(const NoParams());
    gradientText.setWidgetVisibility(false);
    Timer(Seconds.get(1), () {
      gradientText.setWidgetVisibility(true);
    });
  }
}
