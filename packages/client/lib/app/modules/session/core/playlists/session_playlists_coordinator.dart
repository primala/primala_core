// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
part 'session_playlists_coordinator.g.dart';

class SessionPlaylistsCoordinator = _SessionPlaylistsCoordinatorBase
    with _$SessionPlaylistsCoordinator;

abstract class _SessionPlaylistsCoordinatorBase with Store, BaseCoordinator {
  final SessionPlaylistsWidgetsCoordinator widgets;
  final TapDetector tap;
  @override
  final CaptureScreen captureScreen;
  final SessionPresenceCoordinator presence;

  _SessionPlaylistsCoordinatorBase({
    required this.widgets,
    required this.tap,
    required this.captureScreen,
    required this.presence,
  }) {
    initBaseCoordinatorActions();
  }

  @action
  constructor() {
    widgets.constructor();
  }
}
