import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';

mixin SessionSpeakingUtilities {
  BeachWavesStore get beachWaves;
  TouchRippleStore get touchRipple;
  BorderGlowStore get borderGlow;
  RefreshBannerStore? get refreshBanner;
  SpeakLessSmileMoreStore get speakLessSmileMore;

  SessionNavigationStore get sessionNavigation;

  final _isLettingGo = Observable(false);
  final _isHolding = Observable(false);
  final _canTap = Observable(false);
  final _canHold = Observable(true);
  final _collaboratorHasLeft = Observable(false);
  final _holdCount = Observable(0);
  final _isGoingToNotes = Observable(false);

  bool get isLettingGo => _isLettingGo.value;
  bool get isHolding => _isHolding.value;
  bool get canTap => _canTap.value;
  bool get canHold => _canHold.value;
  bool get collaboratorHasLeft => _collaboratorHasLeft.value;
  int get holdCount => _holdCount.value;
  bool get isGoingToNotes => _isGoingToNotes.value;

  _setIsLettingGo(bool value) => _isLettingGo.value = value;
  _setIsHolding(bool value) => _isHolding.value = value;
  _setCanTap(bool value) => _canTap.value = value;
  _setCanHold(bool value) => _canHold.value = value;
  _setCollaboratorHasLeft(bool value) => _collaboratorHasLeft.value = value;
  _setHoldCount(int value) => _holdCount.value = value;
  _setIsGoingToNotes(bool value) => _isGoingToNotes.value = value;

  late Action actionSetIsLettingGo;
  late Action actionSetIsHolding;
  late Action actionSetCanTap;
  late Action actionSetCanHold;
  late Action actionSetCollaboratorHasLeft;
  late Action actionSetHoldCount;
  late Action actionSetIsGoingToNotes;

  setIsLettingGo(bool value) => actionSetIsLettingGo([value]);
  setIsHolding(bool value) => actionSetIsHolding([value]);
  setCanTap(bool value) => actionSetCanTap([value]);
  setCanHold(bool value) => actionSetCanHold([value]);
  setCollaboratorHasLeft(bool value) => actionSetCollaboratorHasLeft([value]);
  incrementHoldCount() => actionSetHoldCount([holdCount + 1]);
  setIsGoingToNotes(bool value) => actionSetIsGoingToNotes([value]);

  initSpeaking(
    GesturePlacement gesturePlacement, {
    Function? onHold,
  }) {
    if (gesturePlacement == GesturePlacement.bottomHalf && canHold) {
      setIsHolding(true);
      setCanHold(false);
      incrementHoldCount();
      beachWaves.setMovieMode(
        BeachWaveMovieModes.halfAndHalfToDrySand,
      );
      refreshBanner?.setWidgetVisibility(false);

      beachWaves.currentStore.initMovie(const NoParams());
      sessionNavigation.setWidgetVisibility(false);
      onHold?.call();
    }
  }

  endSpeaking() {
    setIsHolding(false);
    setIsLettingGo(true);
    borderGlow.initGlowDown();
    beachWaves.setMovieMode(BeachWaveMovieModes.anyToHalfAndHalf);
    beachWaves.currentStore.initMovie(beachWaves.currentColorsAndStops);
  }

  resetSpeakingVariables() {
    setCanHold(true);
    setIsHolding(false);
    setIsLettingGo(false);
  }

  initSessionSpeakingUtilities() {
    actionSetIsLettingGo = Action(_setIsLettingGo);
    actionSetIsHolding = Action(_setIsHolding);
    actionSetCanTap = Action(_setCanTap);
    actionSetCanHold = Action(_setCanHold);
    actionSetCollaboratorHasLeft = Action(_setCollaboratorHasLeft);
    actionSetHoldCount = Action(_setHoldCount);
    actionSetIsGoingToNotes = Action(_setIsGoingToNotes);
  }

  baseInitFullScreenNotes(Function onInit) {
    if (!sessionNavigation.hasInitiatedBlur) {
      setIsGoingToNotes(true);
      refreshBanner?.setWidgetVisibility(false);
      sessionNavigation.setWidgetVisibility(false);
      beachWaves.setMovieMode(
        BeachWaveMovieModes.skyToHalfAndHalf,
      );
      beachWaves.currentStore.reverseMovie(const NoParams());
      onInit();
    }
  }

  baseBeachWavesMovieStatusReactor({
    required Function onReturnToEquilibrium,
    required Function onSkyTransition,
    required Function onBorderGlowInitialized,
  }) =>
      reaction((p0) => beachWaves.movieStatus, (p0) async {
        if (p0 == MovieStatus.finished) {
          if (beachWaves.movieMode == BeachWaveMovieModes.skyToHalfAndHalf) {
            onSkyTransition();
          } else if (beachWaves.movieMode ==
              BeachWaveMovieModes.anyToHalfAndHalf) {
            onReturnToEquilibrium();
          } else if (beachWaves.movieMode ==
              BeachWaveMovieModes.halfAndHalfToDrySand) {
            await onBorderGlowInitialized();
          }
        }
      });

  borderGlowBody(double param) {
    if (param == 200) {
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
  }

  borderGlowReactor() => reaction((p0) => borderGlow.currentWidth, (p0) {
        borderGlowBody(p0);
      });
}
