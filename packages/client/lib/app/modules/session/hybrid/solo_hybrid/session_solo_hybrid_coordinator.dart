// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
part 'session_solo_hybrid_coordinator.g.dart';

class SessionSoloHybridCoordinator = _SessionSoloHybridCoordinatorBase
    with _$SessionSoloHybridCoordinator;

abstract class _SessionSoloHybridCoordinatorBase
    with Store, BaseCoordinator, Reactions, SessionPresence {
  final SessionSoloHybridWidgetsCoordinator widgets;
  final TapDetector tap;
  final SwipeDetector swipe;
  final SessionMetadataStore sessionMetadata;
  @override
  final SessionPresenceCoordinator presence;
  @override
  final CaptureScreen captureScreen;

  _SessionSoloHybridCoordinatorBase({
    required this.widgets,
    required this.swipe,
    required this.tap,
    required this.captureScreen,
    required this.presence,
  }) : sessionMetadata = presence.sessionMetadataStore {
    initBaseCoordinatorActions();
  }

  @action
  constructor() async {
    widgets.constructor(
      userCanSpeak: sessionMetadata.userCanSpeak,
      everyoneIsOnline: sessionMetadata.everyoneIsOnline,
      purpose: sessionMetadata.currentPurpose,
    );
    widgets.rally.setValues(
      fullNames: sessionMetadata.fullNames,
      canRally: sessionMetadata.canRallyArray,
    );
    if (!sessionMetadata.everyoneIsOnline) {
      widgets.onCollaboratorLeft();
    }
    initReactors();
    await presence.updateCurrentPhase(2.0);
    await onResumed();
    await captureScreen(SessionConstants.soloHybrid);
  }

  @observable
  bool userIsSpeaking = false;

  @action
  setUserIsSpeaking(bool newValue) => userIsSpeaking = newValue;

  initReactors() {
    disposers.addAll(widgets.wifiDisconnectOverlay.initReactors(
      onQuickConnected: () => setDisableAllTouchFeedback(false),
      onLongReConnected: () async {
        setDisableAllTouchFeedback(false);
        if (sessionMetadata.userIsSpeaking) {
          presence.incidentsOverlayStore.setWidgetVisibility(true);

          await presence.updateWhoIsTalking(UpdateWhoIsTalkingParams.clearOut);
        }
      },
      onDisconnected: () {
        setDisableAllTouchFeedback(true);
        if (widgets.isHolding) {
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
        if (sessionMetadata.userIsSpeaking) {
          await presence.updateWhoIsTalking(UpdateWhoIsTalkingParams.clearOut);
        }
        widgets.onCollaboratorLeft();
      },
    ));
    disposers.add(tapReactor());
    disposers.add(currentPurposeReactor());
    disposers.add(
      widgets.baseBeachWavesMovieStatusReactor(
        onBorderGlowInitialized: () async {
          widgets.initBorderGlow();
          await presence.updateSpeakingTimerStart();
        },
        onReturnToEquilibrium: () {
          widgets.onLetGoCompleted();
        },
        onSkyTransition: () {
          widgets.onReadyToNavigate(SessionConstants.notes);
        },
      ),
    );
    disposers.add(userIsSpeakingReactor());
    disposers.add(userCanSpeakReactor());
    disposers.add(othersAreTakingNotesReactor());
    disposers.add(rallyReactor());
    disposers.add(glowColorReactor());
    disposers.add(secondarySpotlightReactor());
    disposers.add(swipeReactor());
  }

  swipeReactor() => reaction((p0) => swipe.directionsType, (p0) async {
        switch (p0) {
          case GestureDirections.down:
            widgets.refresh(() async {
              if (presence.incidentsOverlayStore.showWidget) {
                presence.incidentsOverlayStore.setWidgetVisibility(false);
              }
              await presence.dispose();
            });

          default:
            break;
        }
      });

  glowColorReactor() => reaction(
        (p0) => sessionMetadata.glowColor,
        (p0) {
          widgets.rally.setGlowColor(p0);
          if (userIsSpeaking &&
              sessionMetadata.secondarySpeakerSpotlightIsEmpty &&
              p0 == GlowColor.red) {
            widgets.rally.reset();
          }
        },
      );

  userIsSpeakingReactor() =>
      reaction((p0) => sessionMetadata.userIsSpeaking, (p0) async {
        if (p0) {
          setUserIsSpeaking(true);
          widgets.onHold(tap.currentTapPlacement);
          setDisableAllTouchFeedback(true);
          await presence.updateCurrentPhase(2);
        }
      });

  rallyReactor() => reaction(
        (p0) => widgets.rally.currentlySelectedIndex,
        (p0) async {
          await presence.usePowerUp(
            Right(
              RallyParams(
                shouldAdd: p0 != -1,
                userUID: p0 != -1
                    ? sessionMetadata
                        .getUIDFromName(widgets.rally.currentPartnerFullName)
                    : '',
              ),
            ),
          );
        },
      );

  secondarySpotlightReactor() => reaction(
        (p0) => sessionMetadata.userIsInSecondarySpeakingSpotlight,
        (p0) {
          if (p0) {
            widgets.synchronizeBorderGlow(
              startTime: sessionMetadata.speakingTimerStart,
              initiatorFullName: sessionMetadata.currentSpeakerFirstName,
            );
          } else {
            widgets.onLetGo();
            if (!sessionMetadata.userCanSpeak) {
              widgets.othersAreTalkingTint.initMovie(const NoParams());
            }
            // add functionality for wind down
          }
        },
      );

  othersAreTakingNotesReactor() =>
      reaction((p0) => sessionMetadata.canRallyArray, (p0) {
        widgets.rally.setCanRally(
          sessionMetadata.canRallyArray,
        );
      });

  userCanSpeakReactor() => reaction((p0) => sessionMetadata.userCanSpeak, (p0) {
        if (p0 &&
            userIsSpeaking &&
            widgets.rally.phase != RallyPhase.selection) {
          widgets.onLetGo();
          setUserIsSpeaking(false);
          Timer(Seconds.get(2), () {
            setDisableAllTouchFeedback(false);
          });
        } else if (p0 && !userIsSpeaking) {
          widgets.othersAreTalkingTint.reverseMovie(const NoParams());
        } else if (!p0 && !userIsSpeaking) {
          widgets.othersAreTalkingTint.initMovie(const NoParams());
        }
      });

  tapReactor() => reaction(
        (p0) => tap.tapCount,
        (p0) {
          widgets.onTap(
            tapPosition: tap.currentTapPosition,
            tapPlacement: tap.currentTapPlacement,
            asyncTalkingTapCall: onTalkingTap,
            asyncNotesTapCall: () async {
              await presence.updateCurrentPhase(2.5);
            },
          );
        },
      );

  currentPurposeReactor() => reaction(
        (p0) => sessionMetadata.currentPurpose,
        (p0) {
          widgets.purposeBanner.setPurpose(p0);
        },
      );

  @action
  onTalkingTap() async {
    if (sessionMetadata.everyoneIsOnline &&
        sessionMetadata.canStartUsingSession &&
        widgets.rally.phase != RallyPhase.selection) {
      if (sessionMetadata.userIsSpeaking) {
        await presence.updateWhoIsTalking(UpdateWhoIsTalkingParams.clearOut);
      } else {
        await presence
            .updateWhoIsTalking(UpdateWhoIsTalkingParams.setUserAsTalker);
      }
    }
  }

  deconstructor() {
    dispose();
    widgets.dispose();
  }
}
