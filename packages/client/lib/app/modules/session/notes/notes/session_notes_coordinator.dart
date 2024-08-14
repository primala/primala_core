// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte_backend/tables/company_presets.dart';
part 'session_notes_coordinator.g.dart';

class SessionNotesCoordinator = _SessionNotesCoordinatorBase
    with _$SessionNotesCoordinator;

abstract class _SessionNotesCoordinatorBase
    with Store, BaseCoordinator, Reactions, SessionPresence {
  final SessionNotesWidgetsCoordinator widgets;
  final SessionMetadataStore sessionMetadata;
  final SwipeDetector swipe;
  @override
  final SessionPresenceCoordinator presence;
  @override
  final CaptureScreen captureScreen;

  final TapDetector tap;

  _SessionNotesCoordinatorBase({
    required this.widgets,
    required this.captureScreen,
    required this.tap,
    required this.presence,
    required this.swipe,
  }) : sessionMetadata = presence.sessionMetadataStore {
    initBaseCoordinatorActions();
  }

  @action
  constructor() async {
    widgets.setScreenType(sessionMetadata.sessionScreenType);
    widgets.setPresetType(sessionMetadata.presetType);
    widgets.constructor();
    swipe.setMinDistance(100.0);
    initReactors();
    if (isNotASocraticSession) {
      await presence.updateCurrentPhase(2.0);
    }
    await captureScreen(SessionConstants.notes);
  }

  initReactors() {
    disposers.add(swipeReactor());
    disposers.add(presence.initReactors(
      onCollaboratorJoined: () {
        setDisableAllTouchFeedback(false);
        widgets.onCollaboratorJoined();
      },
      onCollaboratorLeft: () {
        setDisableAllTouchFeedback(true);
        widgets.onCollaboratorLeft();
      },
    ));
    disposers.addAll(widgets.wifiDisconnectOverlay.initReactors(
      onQuickConnected: () => setDisableAllTouchFeedback(false),
      onLongReConnected: () => setDisableAllTouchFeedback(false),
      onDisconnected: () => setDisableAllTouchFeedback(true),
    ));
    disposers.add(touchFeedbackStatusReactor());
  }

  touchFeedbackStatusReactor() =>
      reaction((p0) => disableAllTouchFeedback, (p0) {
        if (p0) {
          widgets.textEditor.setIsReadOnly(true);
        } else {
          widgets.textEditor.setIsReadOnly(false);
        }
      });

  swipeReactor() => reaction((p0) => swipe.directionsType, (p0) {
        switch (p0) {
          case GestureDirections.up:
            ifTouchIsNotDisabled(() {
              widgets.onSwipeUp(onSwipeUp);
            });
          case GestureDirections.down:
            if (sessionMetadata.presetType == PresetTypes.consultative) {
              ifTouchIsNotDisabled(() async {
                if (widgets.textEditor.controller.text.isNotEmpty) {
                  await onSwipeUp(widgets.textEditor.controller.text);
                }
                widgets.onSwipeDown();
              });
            }
          default:
            break;
        }
      });

  swipeUpCallback() {}

  @action
  onSwipeUp(String param) async => await presence.addContent(param);

  deconstructor() {
    dispose();
    widgets.deconstructor();
  }

  @computed
  bool get isNotASocraticSession =>
      sessionMetadata.presetType != PresetTypes.socratic;
}
