// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte_backend/tables/company_presets.dart';
part 'polymorphic_solo_widgets_coordinator.g.dart';

class PolymorphicSoloWidgetsCoordinator = _PolymorphicSoloWidgetsCoordinatorBase
    with _$PolymorphicSoloWidgetsCoordinator;

abstract class _PolymorphicSoloWidgetsCoordinatorBase
    with Store, BaseWidgetsCoordinator, Reactions, SessionSpeakingUtilities {
  final MirroredTextStore mirroredText;
  final SmartTextStore primarySmartText;
  final SmartTextStore secondarySmartText;
  @override
  final BeachWavesStore beachWaves;
  @override
  final BorderGlowStore borderGlow;
  @override
  final TouchRippleStore touchRipple;
  @override
  final SpeakLessSmileMoreStore speakLessSmileMore;
  @override
  final SessionNavigationStore sessionNavigation;

  final TintStore tint;
  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;
  final BackButtonStore backButton;

  _PolymorphicSoloWidgetsCoordinatorBase({
    required this.wifiDisconnectOverlay,
    required this.mirroredText,
    required this.beachWaves,
    required this.borderGlow,
    required this.backButton,
    required this.primarySmartText,
    required this.secondarySmartText,
    required this.sessionNavigation,
    required this.tint,
    required this.touchRipple,
    required this.speakLessSmileMore,
  }) {
    initBaseWidgetsCoordinatorActions();
    initSessionSpeakingUtilities();
  }
  // also add back button reactor

  @action
  constructor() {
    beachWaves.setMovieMode(BeachWaveMovieModes.halfAndHalfToDrySand);
    mirroredText.setMessagesData(MirroredTextContent.tapSpeaking);
    primarySmartText.setMessagesData(SessionLists.tapToTalk);
    secondarySmartText.setMessagesData(SessionLists.tapToTakeANote);
    primarySmartText.setStaticAltMovie(SessionConstants.blue);
    setIsLeaving(false);
    borderGlow.initFadeIn();
    backButton.setWidgetVisibility(false);
    initReactors();
  }

  postConstructor(List<SessionTags> sessionTags) {
    if (sessionTags.contains(SessionTags.holdToSpeak)) {
      primarySmartText.setMessagesData(SessionLists.holdToTalk);
      mirroredText.setMessagesData(MirroredTextContent.holdSpeaking);
    }
    if (sessionTags.contains(SessionTags.deactivatedNotes)) {
      mirroredText.startBothRotatingText();
    } else {
      primarySmartText.startRotatingText();
      secondarySmartText.startRotatingText();
    }
    backButton.setWidgetVisibility(true);
  }

  @observable
  bool isLeaving = false;

  @action
  setIsLeaving(bool newBool) => isLeaving = newBool;

  @action
  initFullScreenNotes() {
    if (isLeaving) return;
    baseInitFullScreenNotes(() {
      setTextVisibilities(false);
    });
  }

  setTextVisibilities(bool val) {
    mirroredText.setWidgetVisibility(val);
    primarySmartText.setWidgetVisibility(val);
    secondarySmartText.setWidgetVisibility(val);
  }

  @action
  goHome() {
    setIsLeaving(true);
    setTextVisibilities(false);
    backButton.setWidgetVisibility(false);
    borderGlow.setWidgetVisibility(false);
    beachWaves.setMovieMode(BeachWaveMovieModes.anyToOnShore);
    beachWaves.currentStore.initMovie(
      const AnyToOnShoreParams(
        startingColors: WaterColorsAndStops.halfWaterAndSand,
      ),
    );
  }

  @action
  onHold(GesturePlacement holdPosition) {
    if (isLeaving) return;
    incrementHoldCount();
    setIsHolding(true);
    if (holdPosition == GesturePlacement.topHalf) {
      DurationAndGradient params = DurationAndGradient.initial();
      params = DurationAndGradient(
        gradient: beachWaves.currentColorsAndStops,
        duration: const Duration(seconds: 2),
      );
      beachWaves.setMovieMode(BeachWaveMovieModes.anyToSky);
      beachWaves.currentStore.initMovie(params);
    } else if (holdPosition == GesturePlacement.bottomHalf) {
      beachWaves.setMovieMode(BeachWaveMovieModes.halfAndHalfToDrySand);
      beachWaves.currentStore.initMovie(const NoParams());
    }
    setTextVisibilities(false);
  }

  @action
  onLetGo() {
    if (isLeaving) return;
    endSpeaking();
  }

  onLetGoCompleted() {
    resetSpeakingVariables();
    setTextVisibilities(true);
  }

  @action
  setHoldBeachWaveMovie() {}

  @action
  initBorderGlow() {
    borderGlow.initMovie(const NoParams());
  }

  @action
  initGlowDown() {
    borderGlow.initGlowDown();
  }

  @action
  adjustSpeakLessSmileMoreRotation(GesturePlacement holdPlacement) {
    if (holdPlacement == GesturePlacement.topHalf) {
      speakLessSmileMore.setShouldBeUpsideDown(true);
    } else {
      speakLessSmileMore.setShouldBeUpsideDown(false);
    }
  }

  @action
  initReactors() {
    disposers.add(borderGlowReactor());
    disposers.add(beachWavesMovieStatusReactor());
  }

  beachWavesMovieStatusReactor() =>
      reaction((p0) => beachWaves.movieStatus, (p0) {
        if (p0 == MovieStatus.finished) {
          if (beachWaves.movieMode == BeachWaveMovieModes.skyToHalfAndHalf) {
            Modular.to.navigate(SessionConstants.notes);
          } else if (beachWaves.movieMode ==
              BeachWaveMovieModes.anyToHalfAndHalf) {
            onLetGoCompleted();
          } else if (beachWaves.movieMode == BeachWaveMovieModes.anyToSky ||
              beachWaves.movieMode ==
                  BeachWaveMovieModes.halfAndHalfToDrySand) {
            initBorderGlow();
          } else if (beachWaves.movieMode == BeachWaveMovieModes.anyToOnShore) {
            Modular.to.navigate(HomeConstants.home);
          }
        }
      });
}
