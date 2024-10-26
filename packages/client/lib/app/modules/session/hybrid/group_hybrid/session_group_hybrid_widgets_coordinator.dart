// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'dart:ui';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
part 'session_group_hybrid_widgets_coordinator.g.dart';

class SessionGroupHybridWidgetsCoordinator = _SessionGroupHybridWidgetsCoordinatorBase
    with _$SessionGroupHybridWidgetsCoordinator;

abstract class _SessionGroupHybridWidgetsCoordinatorBase
    with Store, BaseWidgetsCoordinator, Reactions, SessionSpeakingUtilities {
  final MirroredTextStore mirroredText;
  final LetEmCookStore letEmCook;
  final HalfScreenTintStore othersAreTakingNotesTint;
  final TintStore othersAreTalkingTint;
  @override
  final SpeakLessSmileMoreStore speakLessSmileMore;
  @override
  final SessionNavigationStore sessionNavigation;
  @override
  final BeachWavesStore beachWaves;
  @override
  final BorderGlowStore borderGlow;
  @override
  final TouchRippleStore touchRipple;
  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;

  _SessionGroupHybridWidgetsCoordinatorBase({
    required this.sessionNavigation,
    required this.letEmCook,
    required this.othersAreTakingNotesTint,
    required this.othersAreTalkingTint,
    required this.wifiDisconnectOverlay,
    required this.mirroredText,
    required this.beachWaves,
    required this.borderGlow,
    required this.touchRipple,
    required this.speakLessSmileMore,
  }) {
    initBaseWidgetsCoordinatorActions();
    initSessionSpeakingUtilities();
  }

  @action
  constructor(bool someoneIsTakingANote) {
    beachWaves.setMovieMode(BeachWaveMovieModes.halfAndHalfToDrySand);
    mirroredText.setMessagesData(MirroredTextContent.hybrid);
    mirroredText.startBothRotatingText();
    if (someoneIsTakingANote) {
      othersAreTakingNotesTint.initMovie(const NoParams());
    }
    setIsGoingToNotes(someoneIsTakingANote);
    initReactors();
  }

  @observable
  int tapCount = 0;

  @action
  onCollaboratorLeft() {
    mirroredText.setWidgetVisibility(false);
    sessionNavigation.setWidgetVisibility(false);
    setCollaboratorHasLeft(true);
  }

  @action
  onCollaboratorJoined() {
    mirroredText.setWidgetVisibility(true);
    sessionNavigation.setWidgetVisibility(true);
    setCollaboratorHasLeft(false);
  }

  @action
  onHold(GesturePlacement holdPosition) {
    initSpeaking(holdPosition, onHold: () {
      mirroredText.setWidgetVisibility(false);
    });
  }

  @action
  onSomeoneElseIsSpeaking(String speakerName) {
    letEmCook.setCurrentCook(speakerName);
    mirroredText.setWidgetVisibility(false);
    othersAreTalkingTint.initMovie(const NoParams());
  }

  @action
  onSomeElseIsDoneSpreaking() {
    othersAreTalkingTint.reverseMovie(const NoParams());
    mirroredText.setWidgetVisibility(true);
  }

  @action
  onTap(Offset tapPosition, Function onTap) async {
    touchRipple.onTap(tapPosition, overridedColor: const Color(0xFFFFFFFF));
    if (!isHolding && canHold) {
      tapCount++;
      if (hasTappedOnTheTopHalf) {
        initFullScreenNotes();
        await onTap();
      }
    }
  }

  @action
  onLetGo() {
    endSpeaking();
  }

  @action
  onLetGoCompleted() {
    resetSpeakingVariables();
    if (!collaboratorHasLeft) {
      sessionNavigation.setWidgetVisibility(true);
      mirroredText.setWidgetVisibility(true);
    }
  }

  @action
  initFullScreenNotes() {
    baseInitFullScreenNotes(() {
      mirroredText.setWidgetVisibility(false);
      othersAreTakingNotesTint.reverseMovie(const NoParams());
    });
  }

  @action
  initReactors() {
    disposers.add(borderGlowReactor());
    disposers.add(baseBeachWavesMovieStatusReactor(
      onBorderGlowInitialized: () {
        borderGlow.initMovie(const NoParams());
      },
      onReturnToEquilibrium: () {
        onLetGoCompleted();
      },
      onSkyTransition: () {
        Modular.to.navigate(SessionConstants.notes);
      },
    ));
    disposers.add(
      gestureCrossTapReactor(
        onInit: () {
          mirroredText.setWidgetVisibility(false);
        },
        onReverse: () {
          mirroredText.setWidgetVisibility(true);
        },
      ),
    );
  }

  gestureCrossTapReactor({
    required Function onInit,
    required Function onReverse,
  }) =>
      reaction(
        (p0) => sessionNavigation.gestureCross.tapCount,
        (p0) {
          if (!isHolding && !isGoingToNotes) {
            sessionNavigation.onGestureCrossTap(onInit, onReverse);
          }
        },
      );

  @computed
  bool get hasTappedOnTheTopHalf =>
      touchRipple.tapPlacement == GesturePlacement.topHalf;
}
