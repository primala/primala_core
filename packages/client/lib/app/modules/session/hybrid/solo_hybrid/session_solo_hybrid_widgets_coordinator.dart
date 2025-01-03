// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'dart:ui';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:simple_animations/simple_animations.dart';
part 'session_solo_hybrid_widgets_coordinator.g.dart';

class SessionSoloHybridWidgetsCoordinator = _SessionSoloHybridWidgetsCoordinatorBase
    with _$SessionSoloHybridWidgetsCoordinator;

abstract class _SessionSoloHybridWidgetsCoordinatorBase
    with
        Store,
        BaseWidgetsCoordinator,
        Reactions,
        TouchRippleUtils,
        SessionSpeakingUtilities {
  final SmartTextStore primarySmartText;
  final HalfScreenTintStore othersAreTalkingTint;
  final CollaboratorPresenceIncidentsOverlayStore presenceOverlay;

  final RallyStore rally;
  @override
  final RefreshBannerStore refreshBanner;
  @override
  final SessionNavigationStore sessionNavigation;
  @override
  final BorderGlowStore borderGlow;
  @override
  final SpeakLessSmileMoreStore speakLessSmileMore;
  @override
  final BeachWavesStore beachWaves;
  @override
  final TouchRippleStore touchRipple;
  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;
  final PurposeBannerStore purposeBanner;
  final NavigationMenuStore navigationMenu;

  _SessionSoloHybridWidgetsCoordinatorBase({
    required this.primarySmartText,
    required this.rally,
    required this.refreshBanner,
    required this.sessionNavigation,
    required this.othersAreTalkingTint,
    required this.presenceOverlay,
    required this.wifiDisconnectOverlay,
    required this.beachWaves,
    required this.borderGlow,
    required this.purposeBanner,
    required this.touchRipple,
    required this.speakLessSmileMore,
    required this.navigationMenu,
  }) {
    initBaseWidgetsCoordinatorActions();
    initSessionSpeakingUtilities();
  }

  @action
  constructor({
    required bool userCanSpeak,
    required bool everyoneIsOnline,
  }) {
    navigationMenu.setNavigationMenuType(NavigationMenuType.inSession,
        shouldInitReactors: false);
    tapStopwatch.start();
    beachWaves.setMovieMode(BeachWaveMovieModes.halfAndHalfToDrySand);
    primarySmartText.setMessagesData(SessionLists.tapToTalk);
    primarySmartText.setStaticAltMovie(SessionConstants.blue);
    primarySmartText.startRotatingText();
    if (!userCanSpeak) {
      othersAreTalkingTint.initMovie(const NoParams());
    }
    if (!everyoneIsOnline) {
      Timer(Seconds.get(0, milli: 500), () {
        onCollaboratorLeft();
      });
    }
    setIsExiting(false);
    setIsGoingToNotes(false);
    initReactors();
  }

  @observable
  bool isExiting = false;

  @action
  setIsExiting(bool newBool) => isExiting = newBool;

  @observable
  bool isASecondarySpeaker = false;

  @observable
  DateTime speakingTimerStart = DateTime.fromMillisecondsSinceEpoch(0);

  Stopwatch tapStopwatch = Stopwatch();

  @action
  onCollaboratorLeft() {
    if (!presenceOverlay.showWidget) {
      presenceOverlay.setWidgetVisibility(true);
    }
    setSmartTextVisibilities(false);
    purposeBanner.setWidgetVisibility(false);
    sessionNavigation.setWidgetVisibility(false);
    setCollaboratorHasLeft(true);
  }

  refresh(Function onRefresh) async {
    if (!refreshBanner.showWidget) return;
    sessionNavigation.setWidgetVisibility(false);
    primarySmartText.setWidgetVisibility(false);
    purposeBanner.setWidgetVisibility(false);
    setCollaboratorHasLeft(false);
    othersAreTalkingTint.reverseMovie(const NoParams());

    refreshBanner.setWidgetVisibility(false);
    Timer(Seconds.get(1), () {
      Modular.to.navigate(SessionConstants.pause);
    });
    await onRefresh();
  }

  @action
  openPurposeModal() {
    if (navigationMenu.hasSwipedDown) return;
    purposeBanner.showModal(onOpen: () {
      if (isHolding) {
        Timer.periodic(Seconds.get(0, milli: 250), (t) {
          if (borderGlow.currentWidth > 0) {
            beachWaves.currentStore.setControl(Control.stop);
            borderGlow.setControl(Control.play);
            t.cancel();
          }
        });
      } else if (isLettingGo) {
        Timer.periodic(Seconds.get(0, milli: 250), (t) {
          if (canHold) {
            beachWaves.currentStore.setControl(Control.stop);
            t.cancel();
          }
        });
      } else {
        beachWaves.currentStore.setControl(Control.stop);
      }
      navigationMenu.setWidgetVisibility(false);
    }, onClose: () {
      navigationMenu.setWidgetVisibility(true);
    });
  }

  @action
  onCollaboratorJoined() {
    setCollaboratorHasLeft(false);
    purposeBanner.setWidgetVisibility(true);
    primarySmartText.setWidgetVisibility(true);
    sessionNavigation.setWidgetVisibility(true);
  }

  @action
  setSmartTextVisibilities(bool newVisibility) {
    primarySmartText.setWidgetVisibility(newVisibility);
  }

  @action
  onHold(GesturePlacement holdPosition) {
    initSpeaking(holdPosition, onHold: () {
      setSmartTextVisibilities(false);
      navigationMenu.setWidgetVisibility(false);
    });
  }

  // @action
  // setCollaboratorNames(List<String> collaboratorNames) {
  //   rally.setCollaborators(collaboratorNames);
  // }

  @action
  onTap({
    required Offset tapPosition,
    required GesturePlacement tapPlacement,
    required Function asyncTalkingTapCall,
    required Function asyncNotesTapCall,
  }) async {
    if ((tapStopwatch.elapsedMilliseconds > 1000 || holdCount == 0) &&
        !sessionNavigation.hasInitiatedBlur) {
      touchRipple.onTap(tapPosition, adjustColorBasedOnPosition: true);
      if (tapPlacement == GesturePlacement.bottomHalf) {
        await asyncTalkingTapCall();
        incrementHoldCount();
        tapStopwatch.reset();
      }
    }
  }

  @action
  onLetGo() {
    endSpeaking();
    setSmartTextVisibilities(false);

    rally.reset();
  }

  @action
  onSomeoneElseIsTalking() {
    othersAreTalkingTint.reverseMovie(const NoParams());
    navigationMenu.setWidgetVisibility(false);
  }

  @action
  onSomeoneElseIsDoneTalking() {
    othersAreTalkingTint.initMovie(const NoParams());
    navigationMenu.setWidgetVisibility(true);
  }

  @action
  onLetGoCompleted() {
    navigationMenu.setWidgetVisibility(true);
    resetSpeakingVariables();

    isASecondarySpeaker = false;
    speakingTimerStart = DateTime.fromMillisecondsSinceEpoch(0);
    if (!collaboratorHasLeft) {
      setSmartTextVisibilities(true);
      sessionNavigation.setWidgetVisibility(true);
    }
  }

  @action
  initFullScreenNotes() {
    baseInitFullScreenNotes(() {
      navigationMenu.setWidgetVisibility(false);
      setSmartTextVisibilities(false);
      purposeBanner.setWidgetVisibility(false);
      othersAreTalkingTint.reverseMovie(const NoParams());
    });
  }

  @action
  initBorderGlow() {
    if (isASecondarySpeaker) {
      rally.setRallyPhase(RallyPhase.activeRecipient);
      borderGlow.synchronizeGlow(speakingTimerStart);
    } else {
      borderGlow.initMovie(const NoParams());
      rally.setRallyPhase(RallyPhase.initial);
    }
  }

  @action
  synchronizeBorderGlow({
    required DateTime startTime,
    required String initiatorFullName,
  }) {
    speakingTimerStart = startTime;
    isASecondarySpeaker = true;
    navigationMenu.setWidgetVisibility(false);
    sessionNavigation.setWidgetVisibility(false);
    rally.setCurrentInitiator(initiatorFullName);
    beachWaves.setMovieMode(
      BeachWaveMovieModes.halfAndHalfToDrySand,
    );
    othersAreTalkingTint.reverseMovie(const NoParams());
    beachWaves.currentStore.initMovie(const NoParams());
    setSmartTextVisibilities(false);
  }

  @action
  initReactors() {
    disposers.add(borderGlowReactor());
    disposers.add(purposeBannerTapReactor());
    disposers.add(
      gestureCrossTapReactor(
        onInit: () {
          primarySmartText.setWidgetVisibility(false);
          purposeBanner.setWidgetVisibility(false);
        },
        onReverse: () {
          primarySmartText.setWidgetVisibility(true);
          purposeBanner.setWidgetVisibility(true);
        },
      ),
    );
  }

  @override
  borderGlowReactor() => reaction((p0) => borderGlow.currentWidth, (p0) {
        if (isASecondarySpeaker) return;
        borderGlowBody(p0);
      });

  purposeBannerTapReactor() => reaction((p0) => purposeBanner.tapCount, (p0) {
        openPurposeModal();
      });

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
  bool get hasTappedOnTheBottomHalf =>
      touchRipple.tapPlacement == GesturePlacement.bottomHalf;
}
