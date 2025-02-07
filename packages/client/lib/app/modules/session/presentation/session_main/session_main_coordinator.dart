// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte_backend/tables/sessions.dart';
part 'session_main_coordinator.g.dart';

class SessionMainCoordinator = _SessionMainCoordinatorBase
    with _$SessionMainCoordinator;

abstract class _SessionMainCoordinatorBase
    with Store, BaseCoordinator, BaseWidgetsCoordinator, Reactions {
  final SessionPresenceCoordinator presence;
  final SessionMetadataStore sessionMetadata;
  final PurposeBannerStore purposeBanner;
  final TintStore tint;
  final SessionBarStore sessionBar;
  final BorderGlowStore borderGlow;
  final SmartTextStore smartText;
  final LetEmCookStore letEmCook;
  final RallyStore rally;
  final SpeakLessSmileMoreStore speakLessSmileMore;
  final CollaboratorPresenceIncidentsOverlayStore presenceOverlay;
  final SwipeDetector swipe;
  final TapDetector tap;

  @override
  final CaptureScreen captureScreen;

  _SessionMainCoordinatorBase({
    required this.captureScreen,
    required this.sessionBar,
    required this.presence,
    required this.smartText,
    required this.tint,
    required this.borderGlow,
    required this.swipe,
    required this.letEmCook,
    required this.rally,
    required this.tap,
    required this.speakLessSmileMore,
  })  : sessionMetadata = presence.sessionMetadataStore,
        presenceOverlay = presence.incidentsOverlayStore,
        purposeBanner = PurposeBannerStore(
          blockTextDisplay:
              presence.sessionMetadataStore.viewDoc.blockTextDisplay,
        ) {
    initBaseCoordinatorActions();
    initBaseWidgetsCoordinatorActions();
  }

  @action
  constructor() {
    fadeInWidgets();
    initReactors();
    if (!sessionMetadata.userIsSpeaking && !sessionMetadata.userCanSpeak) {
      tint.initMovie(const NoParams());
    }
    rally.setCollaborators(sessionMetadata.collaboratorsMinusUser);
    if (!sessionMetadata.everyoneIsOnline) {
      onCollaboratorLeft();
    }
  }

  initReactors() {
    disposers.add(currentSpeakerReactor());
    disposers.add(swipeReactor());
    disposers.add(letEmCookReactor());
    disposers.add(glowColorReactor());
    disposers.add(userIsSpeakingReactor());
    disposers.add(rallyReactor());
    disposers.add(secondarySpotlightReactor());
    disposers.add(borderGlowReactor());
    disposers.add(secondarySpeakerEmptySpotlightReactor());
    disposers.add(userCanSpeakReactor());
    disposers.add(tapReactor());
    disposers.add(currentFocusReactor());
    disposers.add(purposeBannerTapReactor());
  }

  @action
  onCollaboratorLeft() {
    if (!presenceOverlay.showWidget) {
      presenceOverlay.setWidgetVisibility(true);
    }
    purposeBanner.setWidgetVisibility(false);
    smartText.setWidgetVisibility(false);
  }

  @action
  onLetGo() {
    sessionBar.setWidgetVisibility(true);
    smartText.setWidgetVisibility(true);
    borderGlow.initGlowDown();
    rally.reset();
  }

  @action
  onPauseTapped() async {
    await presence.dispose();
    setShowWidgets(false);
    if (presence.incidentsOverlayStore.showWidget) {
      presence.incidentsOverlayStore.setWidgetVisibility(false);
    }
    Timer(Seconds.get(1), () {
      Modular.to.navigate(SessionConstants.pause);
    });
  }

  @action
  onDocTapped() {
    Modular.to.push(
      MaterialPageRoute(builder: (BuildContext context) {
        return Observer(builder: (context) {
          return DocPicker(
            docs: sessionMetadata.documents,
            onDocPicked: presence.updateActiveDocument,
          );
        });
      }),
    );
  }

  @action
  onTalkingTap() async {
    if (sessionMetadata.everyoneIsOnline &&
        sessionMetadata.canStartUsingSession &&
        rally.phase != RallyPhase.selection) {
      if (sessionMetadata.userIsSpeaking) {
        await presence.updateWhoIsTalking(UpdateWhoIsTalkingParams.clearOut);
      } else {
        await presence
            .updateWhoIsTalking(UpdateWhoIsTalkingParams.setUserAsTalker);
      }
    }
  }

  currentSpeakerReactor() =>
      reaction((p0) => sessionMetadata.currentSpeakerFirstName, (p0) {
        if (p0.isEmpty) return;
        letEmCook.setCurrentCook(p0);
        rally.setCurrentInitiator(p0);
      });

  purposeBannerTapReactor() => reaction((p0) => purposeBanner.tapCount, (p0) {
        if (!purposeBanner.showWidget) return;
        purposeBanner.showModal(
          onOpen: () {
            sessionBar.setWidgetVisibility(false);
          },
          onClose: () {
            sessionBar.setWidgetVisibility(true);
          },
        );
      });

  swipeReactor() => reaction((p0) => swipe.directionsType, (p0) async {
        switch (p0) {
          case GestureDirections.up:
            if (!purposeBanner.showWidget) return;
            purposeBanner.showModal(
              onOpen: () {
                sessionBar.setWidgetVisibility(false);
              },
              onClose: () {
                sessionBar.setWidgetVisibility(true);
              },
            );
          default:
            break;
        }
      });

  glowColorReactor() => reaction(
        (p0) => sessionMetadata.glowColor,
        (p0) {
          if (sessionMetadata.userIsSpeaking) {
            rally.setGlowColor(p0);
            if (sessionMetadata.userIsSpeaking &&
                sessionMetadata.secondarySpeakerSpotlightIsEmpty &&
                p0 == GlowColor.red) {
              rally.reset();
            }
          } else {
            if (!sessionMetadata.userIsSpeaking &&
                sessionMetadata.secondarySpeakerSpotlightIsEmpty &&
                p0 == GlowColor.yellow) {
              letEmCook.setButtonVisibility(true);
              smartText.setWidgetVisibility(false);
            } else if (p0 == GlowColor.transparent) {
              letEmCook.setButtonVisibility(false);
              smartText.setWidgetVisibility(true);
            }
          }
        },
      );

  userIsSpeakingReactor() =>
      reaction((p0) => sessionMetadata.userIsSpeaking, (p0) async {
        if (p0) {
          borderGlow.initMovie(const NoParams());
          smartText.setWidgetVisibility(false);
          sessionBar.setWidgetVisibility(false);
          rally.setRallyPhase(RallyPhase.initial);
          setDisableAllTouchFeedback(true);
          await presence.updateUserStatus(SessionUserStatus.online);
        } else {
          borderGlow.initGlowDown();
          // Timer(Seconds.get(1), () {
          smartText.setWidgetVisibility(true);
          sessionBar.setWidgetVisibility(true);
          // });
        }
      });

  rallyReactor() => reaction(
        (p0) => rally.currentlySelectedIndex,
        (p0) async {
          await presence.usePowerUp(
            Right(
              RallyParams(
                shouldAdd: p0 != -1,
                userUID: p0 != -1 ? rally.currentPartnerUID : '',
              ),
            ),
          );
        },
      );

  secondarySpotlightReactor() => reaction(
        (p0) => sessionMetadata.userIsInSecondarySpeakingSpotlight,
        (p0) {
          if (sessionMetadata.currentPowerup == PowerupType.rally) {
            if (p0) {
              sessionBar.setWidgetVisibility(false);
              rally.setCurrentInitiator(
                sessionMetadata.currentSpeakerFirstName,
              );
              rally.setRallyPhase(RallyPhase.activeRecipient);
              tint.reverseMovie(const NoParams());
              borderGlow.synchronizeGlow(sessionMetadata.speakingTimerStart);
              smartText.setWidgetVisibility(false);
            } else {
              onLetGo();
              if (!sessionMetadata.userCanSpeak) {
                tint.initMovie(const NoParams());
              }
            }
          }
        },
      );

  borderGlowReactor() => reaction((p0) => borderGlow.currentWidth, (p0) {
        if (sessionMetadata.userIsInSecondarySpeakingSpotlight) return;

        if (p0 == 200) {
          speakLessSmileMore.setSpeakLess(true);
          Timer(Seconds.get(2), () {
            if (borderGlow.currentWidth == 200) {
              speakLessSmileMore.setSmileMore(true);
            }
          });
        } else {
          if (speakLessSmileMore.showSmileMore ||
              speakLessSmileMore.showSpeakLess) {
            speakLessSmileMore.hideBoth();
          }
        }
      });

  secondarySpeakerEmptySpotlightReactor() => reaction(
        (p0) => sessionMetadata.secondarySpeakerSpotlightIsEmpty,
        (p0) {
          if (sessionMetadata.currentPowerup == PowerupType.cook) {
            if (!p0) {
              if (sessionMetadata.userIsSpeaking) {
                rally.reset();
                borderGlow.resetCurrentBackToGreen();
              } else {
                if (sessionMetadata.userIsInSecondarySpeakingSpotlight) {
                  letEmCook.initSentAnimation();
                  Timer(Seconds.get(4), () {
                    smartText.setWidgetVisibility(true);
                  });
                } else {
                  letEmCook.setButtonVisibility(false);
                  smartText.setWidgetVisibility(true);
                }
              }
            }
          }
        },
      );

  letEmCookReactor() => reaction((p0) => letEmCook.tapCount, (p0) async {
        if (sessionMetadata.secondarySpeakerSpotlightIsEmpty) {
          await presence.usePowerUp(Left(LetEmCookParams()));
        }
      });

  userCanSpeakReactor() => reaction((p0) => sessionMetadata.userCanSpeak, (p0) {
        if (p0 &&
            sessionMetadata.userIsSpeaking &&
            rally.phase != RallyPhase.selection) {
          onLetGo();
        } else if (p0 && !sessionMetadata.userIsSpeaking) {
          tint.reverseMovie(const NoParams());
        } else if (!p0 && !sessionMetadata.userIsSpeaking) {
          tint.initMovie(const NoParams());
        }
      });

  tapReactor() => reaction(
        (p0) => tap.tapCount,
        (p0) async {
          if (sessionMetadata.everyoneIsOnline &&
              sessionMetadata.canStartUsingSession &&
              rally.phase != RallyPhase.selection) {
            if (sessionMetadata.userIsSpeaking) {
              await presence
                  .updateWhoIsTalking(UpdateWhoIsTalkingParams.clearOut);
            } else {
              await presence
                  .updateWhoIsTalking(UpdateWhoIsTalkingParams.setUserAsTalker);
            }
          }
        },
      );

  currentFocusReactor() => reaction(
        (p0) => sessionMetadata.viewDoc.currentFocus,
        (p0) {
          purposeBanner.setFocus(p0);
        },
      );
}
