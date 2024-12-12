// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
part 'session_playlists_coordinator.g.dart';

class SessionPlaylistsCoordinator = _SessionPlaylistsCoordinatorBase
    with _$SessionPlaylistsCoordinator;

abstract class _SessionPlaylistsCoordinatorBase
    with Store, BaseCoordinator, Reactions {
  final SessionPlaylistsWidgetsCoordinator widgets;
  final TapDetector tap;
  @override
  final CaptureScreen captureScreen;
  final SessionPresenceCoordinator presence;
  final StorageLogicCoordinator storageLogic;

  _SessionPlaylistsCoordinatorBase({
    required this.widgets,
    required this.tap,
    required this.captureScreen,
    required this.presence,
    required this.storageLogic,
  }) {
    initBaseCoordinatorActions();
  }

  @action
  constructor() async {
    widgets.constructor();
    disposers.add(groupReactor());
    await storageLogic.getGroups();
    disposers.add(groupSelectionReactor());
    disposers.add(queueSelectionReactor());
  }

  groupReactor() => reaction(
        (p0) => storageLogic.groups,
        (p0) {
          widgets.queueSelector.setGroups(p0);
        },
      );

  groupSelectionReactor() => reaction(
        (p0) => widgets.queueSelector.selectedGroup,
        (p0) {
          if (p0 != GroupInformationEntity.empty()) {
            presence.updateGroupUID(p0.groupUID);
          }
        },
      );

  queueSelectionReactor() => reaction(
        (p0) => widgets.queueSelector.selectedQueue,
        (p0) {
          if (p0 != QueueEntity.empty()) {
            presence.updateQueueUID(
              UpdateQueueUIDParams(
                queueUID: p0.uid,
                content: p0.content,
              ),
            );
          }
        },
      );
}
