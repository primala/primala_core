// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/extensions/extensions.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
part 'session_group_hybrid_coordinator.g.dart';

class SessionGroupHybridCoordinator = _SessionGroupHybridCoordinatorBase
    with _$SessionGroupHybridCoordinator;

abstract class _SessionGroupHybridCoordinatorBase
    with Store, BaseCoordinator, Reactions, SessionPresence {
  final SessionGroupHybridWidgetsCoordinator widgets;
  final TapDetector tap;
  final HoldDetector hold;
  final SessionMetadataStore sessionMetadata;
  @override
  final SessionPresenceCoordinator presence;
  @override
  final CaptureScreen captureScreen;

  _SessionGroupHybridCoordinatorBase({
    required this.widgets,
    required this.hold,
    required this.tap,
    required this.captureScreen,
    required this.presence,
  }) : sessionMetadata = presence.sessionMetadataStore {
    initBaseCoordinatorActions();
  }

  @action
  constructor() async {
    widgets.constructor(
      sessionMetadata.someoneIsTakingANote,
      sessionMetadata.everyoneIsOnline,
    );
    widgets.sessionNavigation.setup(
      sessionMetadata.screenType,
      sessionMetadata.presetType,
      initSwipeReactor: false,
    );
    initReactors();
    await presence.updateCurrentPhase(2.0);
    await onResumed();
    await captureScreen(SessionConstants.groupHybrid);
  }

  @observable
  bool userIsSpeaking = false;

  @action
  setUserIsSpeaking(bool newValue) => userIsSpeaking = newValue;

  initReactors() {
    disposers.add(holdReactor());
    disposers.add(letGoReactor());

    disposers.addAll(widgets.wifiDisconnectOverlay.initReactors(
      onQuickConnected: () => setDisableAllTouchFeedback(false),
      onLongReConnected: () {
        setDisableAllTouchFeedback(false);
      },
      onDisconnected: () {
        setDisableAllTouchFeedback(true);
        if (hold.holdCount.isGreaterThan(hold.letGoCount)) {
          widgets.onLetGo();
        }
      },
    ));
    disposers.add(presence.initReactors(
      onCollaboratorJoined: () {
        setDisableAllTouchFeedback(false);
        widgets.onCollaboratorJoined();
      },
      onCollaboratorLeft: () async {
        setDisableAllTouchFeedback(true);
        if (hold.holdCount.isGreaterThan(hold.letGoCount)) {
          await presence.updateWhoIsTalking(UpdateWhoIsTalkingParams.clearOut);
        }
        widgets.onCollaboratorLeft();
      },
    ));
    disposers.add(tapReactor());
    disposers.add(userIsSpeakingReactor());
    disposers.add(userCanSpeakReactor());
    disposers.add(othersAreTakingNotesReactor());
    disposers.add(glowColorReactor());
    disposers.add(secondarySpeakerSpotlightReactor());
    disposers.add(letEmCookTapReactor());
    disposers.add(
      widgets.sessionNavigation.swipeReactor(
        onSwipeDown: () async {
          widgets.refresh(() async {
            if (presence.incidentsOverlayStore.showWidget) {
              presence.incidentsOverlayStore.setWidgetVisibility(false);
            }
            await presence.dispose();
          });
        },
      ),
    );
  }

  userIsSpeakingReactor() =>
      reaction((p0) => sessionMetadata.userIsSpeaking, (p0) async {
        if (p0) {
          setUserIsSpeaking(true);
          widgets.onHold(hold.placement);
          setDisableAllTouchFeedback(true);
          await presence.updateCurrentPhase(2);
        }
      });

  userCanSpeakReactor() => reaction((p0) => sessionMetadata.userCanSpeak, (p0) {
        if (p0 && userIsSpeaking) {
          widgets.onLetGo();
          setUserIsSpeaking(false);
          Timer(Seconds.get(2), () {
            setDisableAllTouchFeedback(false);
          });
        } else if (p0 && !userIsSpeaking) {
          widgets.onSomeElseIsDoneSpreaking();
        } else if (!p0 && !userIsSpeaking) {
          widgets.onSomeoneElseIsSpeaking(
            sessionMetadata.currentSpeakerFirstName,
          );
        }
      });

  glowColorReactor() => reaction(
        (p0) => sessionMetadata.glowColor,
        (p0) {
          if (!userIsSpeaking &&
              sessionMetadata.secondarySpeakerSpotlightIsEmpty &&
              p0 == GlowColor.yellow) {
            widgets.letEmCook.setButtonVisibility(true);
          } else if (p0 == GlowColor.transparent) {
            widgets.letEmCook.setButtonVisibility(false);
          }
        },
      );

  secondarySpeakerSpotlightReactor() => reaction(
        (p0) => sessionMetadata.secondarySpeakerSpotlightIsEmpty,
        (p0) {
          if (!p0) {
            if (sessionMetadata.userIsSpeaking) {
              widgets.borderGlow.resetCurrentBackToGreen();
            } else {
              if (sessionMetadata.userIsInSecondarySpeakingSpotlight) {
                widgets.letEmCook.initSentAnimation();
              } else {
                widgets.letEmCook.setButtonVisibility(false);
              }
            }
          }
        },
      );

  letEmCookTapReactor() => reaction(
        (p0) => widgets.letEmCook.tapCount,
        (p0) async {
          if (sessionMetadata.secondarySpeakerSpotlightIsEmpty) {
            await presence.usePowerUp(Left(LetEmCookParams()));
          }
        },
      );

  othersAreTakingNotesReactor() =>
      reaction((p0) => sessionMetadata.someoneIsTakingANote, (p0) {
        if (p0 && !widgets.isGoingToNotes) {
          widgets.othersAreTakingNotesTint.initMovie(const NoParams());
        } else {
          widgets.othersAreTakingNotesTint.reverseMovie(const NoParams());
        }
      });

  tapReactor() => reaction(
        (p0) => tap.tapCount,
        (p0) => ifTouchIsNotDisabled(
          () async {
            if (sessionMetadata.userCanSpeak) {
              widgets.onTap(tap.currentTapPosition, () async {
                await presence.updateCurrentPhase(3.5);
              });
            }
          },
        ),
      );

  holdReactor() => reaction((p0) => hold.holdCount, (p0) {
        ifTouchIsNotDisabled(() async {
          if (sessionMetadata.everyoneIsOnline &&
              sessionMetadata.canStartUsingSession &&
              !sessionMetadata.someoneIsTakingANote &&
              !widgets.sessionNavigation.hasInitiatedBlur &&
              hold.placement == GesturePlacement.bottomHalf) {
            await presence
                .updateWhoIsTalking(UpdateWhoIsTalkingParams.setUserAsTalker);
          }
        });
      });

  letGoReactor() => reaction((p0) => hold.letGoCount, (p0) async {
        if (sessionMetadata.everyoneIsOnline) {
          await presence.updateWhoIsTalking(UpdateWhoIsTalkingParams.clearOut);
        }
      });

  deconstructor() {
    dispose();
  }
}
