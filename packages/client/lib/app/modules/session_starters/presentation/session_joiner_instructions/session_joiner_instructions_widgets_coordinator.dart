// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte/app/modules/session_starters/session_starters.dart';
part 'session_joiner_instructions_widgets_coordinator.g.dart';

class SessionJoinerInstructionsWidgetsCoordinator = _SessionJoinerInstructionsWidgetsCoordinatorBase
    with _$SessionJoinerInstructionsWidgetsCoordinator;

abstract class _SessionJoinerInstructionsWidgetsCoordinatorBase
    with
        Store,
        SmartTextPaddingAdjuster,
        SwipeNavigationUtils,
        InstructionWidgetsUtils,
        BaseWidgetsCoordinator,
        InstructionalNokhteWidgetUtils,
        SingleInstructionalNokhteWidgetUtils,
        Reactions,
        TouchRippleUtils,
        EnRoute,
        EnRouteConsumer,
        SessionStarterWidgetsUtils {
  final SwipeGuideStore swipeGuide;
  @override
  NokhteQrCodeStore qrCode;
  final InstructionalGradientNokhteStore homeInstructionalNokhte;
  @override
  final SmartTextStore smartText;
  @override
  final GestureCrossStore gestureCross;
  @override
  final TouchRippleStore touchRipple;
  @override
  final CenterInstructionalNokhteStore centerInstructionalNokhte;
  @override
  final NokhteBlurStore nokhteBlur;
  @override
  final InstructionalGradientNokhteStore focusInstructionalNokhte;
  @override
  final BeachWavesStore beachWaves;
  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;

  _SessionJoinerInstructionsWidgetsCoordinatorBase({
    required this.swipeGuide,
    required this.beachWaves,
    required this.touchRipple,
    required this.gestureCross,
    required this.smartText,
    required this.qrCode,
    required this.wifiDisconnectOverlay,
    required this.centerInstructionalNokhte,
    required this.nokhteBlur,
    required this.homeInstructionalNokhte,
    required this.focusInstructionalNokhte,
  }) {
    initSwipeNavigationUtils();
    initInstructionWidgetsUtils();
    initEnRouteActions();
    initBaseWidgetsCoordinatorActions();
    initSmartTextActions();
    setSmartTextTopPaddingScalar(0.2);
    setSmartTextBottomPaddingScalar(0);
    setSmartTextSubMessagePaddingScalar(110);
  }

  @action
  constructor(Offset center) {
    initInstructionalNokhteUtils(center);
    swipeGuide.setWidgetVisibility(false);
    qrCode.setWidgetVisibility(false);
    gestureCross.fadeInTheCross();
    consumeRoutingArgs(isInverted: true);
    smartText.setMessagesData(SessionStartersList.sessionJoinerInstructions);
    smartText.startRotatingText();
    focusInstructionalNokhte.prepareYellowDiamond(
      center,
      position: InstructionalNokhtePositions.right,
      colorway: GradientNokhteColorways.orangeSand,
    );
    initReactors();
  }

  @action
  onSwipeLeft() {
    if (centerInstructionalNokhte.movieStatus != MovieStatus.inProgress) {
      if (smartText.currentIndex == 1) {
        initToRightInstructionalNokhte();
        swipeGuide.setWidgetVisibility(false);
        homeInstructionalNokhte.setWidgetVisibility(false);
      } else if (smartText.currentIndex == 3) {
        qrCode.setWidgetVisibility(false);
        initEnterSessionJoiner();
      }
    }
  }

  @action
  onSwipeDown() {
    if (!hasInitiatedBlur && !hasSwiped()) {
      initExitSessionStarter();
      homeInstructionalNokhte.setWidgetVisibility(false);
    }
  }

  initReactors() {
    disposers.add(centerCrossNokhteReactor());
    disposers.add(gestureCrossTapReactor());
    disposers.add(beachWavesMovieStatusReactor());
    disposers.add(centerInstructionalNokhteReactor());
  }

  @action
  onGestureCrossTap() {
    if (!isDisconnected && smartText.currentIndex == 0) {
      baseOnInitInstructionMode();
      qrCode.setWidgetVisibility(false);
      homeInstructionalNokhte.setWidgetVisibility(true);
      homeInstructionalNokhte.initMovie(
        InstructionalGradientMovieParams(
          center: center,
          colorway: GradientNokhteColorways.beachWave,
          direction: InstructionalGradientDirections.enlarge,
          position: InstructionalNokhtePositions.bottom,
        ),
      );
    }
  }

  @action
  onSwipeRight() {
    if (smartText.currentIndex == 0 && !hasSwiped()) {
      smartText.setWidgetVisibility(false);
      initEnterPresets();
    }
  }

  @action
  onTap(Offset offset) {
    if (!touchIsDisabled) {
      if (smartText.currentIndex == 2) {
        dismissMovedInstructionalNokhte(
          offset,
          onDismiss: () {
            qrCode.setWidgetVisibility(true);
            setSmartTextTopPaddingScalar(0.2);
            setSmartTextBottomPaddingScalar(0);
            setSmartTextSubMessagePaddingScalar(110);
            homeInstructionalNokhte.setWidgetVisibility(true);
            homeInstructionalNokhte.initMovie(
              InstructionalGradientMovieParams(
                center: center,
                colorway: GradientNokhteColorways.beachWave,
                direction: InstructionalGradientDirections.shrink,
                position: InstructionalNokhtePositions.bottom,
              ),
            );
          },
          colorway: GradientNokhteColorways.orangeSand,
          gradPosition: InstructionalNokhtePositions.right,
          centerPosition: CenterNokhtePositions.right,
        );
      }
    }
  }

  @observable
  GestureCrossConfiguration gestureCrossConfig = GestureCrossConfiguration();

  @action
  onUserInfoLoaded(bool hasAssessedQrCode, String userUID) {
    Either<StrokeConfig, NokhteGradientConfig> homeConfig = Right(
      NokhteGradientConfig(
        gradientType: NokhteGradientTypes.home,
      ),
    );
    if (hasAssessedQrCode) {
      gestureCrossConfig = GestureCrossConfiguration(
        left: Right(
          NokhteGradientConfig(
            gradientType: NokhteGradientTypes.presets,
          ),
        ),
        bottom: homeConfig,
      );
      //
    } else {
      gestureCrossConfig = GestureCrossConfiguration(
        bottom: homeConfig,
      );
    }
    qrCode.setQrCodeData(userUID);
    qrCode.setWidgetVisibility(true);
    gestureCross.fadeIn();
  }

  centerInstructionalNokhteReactor() =>
      reaction((p0) => centerInstructionalNokhte.movieStatus, (p0) {
        if (p0 == MovieStatus.finished) {
          if (centerInstructionalNokhte.movieMode ==
              CenterInstructionalNokhteMovieModes.moveBack) {
            gestureCross.centerCrossNokhte.setWidgetVisibility(true);
            gestureCross.gradientNokhte.setWidgetVisibility(true);
            smartText.startRotatingText();
            setSwipeDirection(GestureDirections.initial);
            setTouchIsDisabled(false);
          } else if (centerInstructionalNokhte.movieMode ==
              CenterInstructionalNokhteMovieModes.moveToCenter) {
            swipeGuide.setWidgetVisibility(true);
          }
        }
      });

  centerCrossNokhteReactor() =>
      reaction((p0) => gestureCross.centerCrossNokhte.movieStatus, (p0) {
        if (p0 == MovieStatus.finished) {
          gestureCross.gradientNokhte.setWidgetVisibility(false);
          gestureCross.strokeCrossNokhte.setWidgetVisibility(false);
          homeInstructionalNokhte.setWidgetVisibility(false);
          focusInstructionalNokhte.setWidgetVisibility(false);
        }
      });

  gestureCrossTapReactor() => reaction(
        (p0) => gestureCross.tapCount,
        (p0) => onGestureCrossTap(),
      );
}
