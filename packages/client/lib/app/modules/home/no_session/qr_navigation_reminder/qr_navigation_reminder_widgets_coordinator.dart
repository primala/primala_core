// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/extensions/extensions.dart';
import 'package:nokhte/app/core/mixins/mixin.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/home.dart';
import 'package:simple_animations/simple_animations.dart';
part 'qr_navigation_reminder_widgets_coordinator.g.dart';

class QrNavigationReminderWidgetsCoordinator = _QrNavigationReminderWidgetsCoordinatorBase
    with _$QrNavigationReminderWidgetsCoordinator;

abstract class _QrNavigationReminderWidgetsCoordinatorBase
    extends BaseHomeScreenWidgetsCoordinator
    with
        Store,
        Reactions,
        EnRoute,
        EnRouteConsumer,
        SwipeNavigationUtils,
        InstructionWidgetsUtils,
        TouchRippleUtils,
        HomeScreenWidgetsUtils,
        InstructionalNokhteWidgetUtils,
        SingleInstructionalNokhteWidgetUtils {
  @override
  InstructionalGradientNokhteStore? focusInstructionalNokhte;
  InstructionalGradientNokhteStore sessionStarterInstructionalNokhte;
  _QrNavigationReminderWidgetsCoordinatorBase({
    required super.nokhteBlur,
    required super.beachWaves,
    required super.wifiDisconnectOverlay,
    required super.gestureCross,
    required super.smartText,
    required super.touchRipple,
    required super.centerInstructionalNokhte,
    required this.sessionStarterInstructionalNokhte,
  });

  @action
  constructor(Offset center) {
    setSmartTextBottomPaddingScalar(0.3);
    initHomeUtils();
    consumeRoutingArgs();
    initInstructionalNokhteUtils(center);
    smartText.setMessagesData(HomeLists.qrNavigationReminder);
    smartText.startRotatingText();
    gestureCross.fadeIn(onFadeIn: Left(() {
      sessionStarterInstructionalNokhte.initMovie(
        InstructionalGradientMovieParams(
          center: center,
          colorway: GradientNokhteColorways.invertedBeachWave,
          direction: InstructionalGradientDirections.enlarge,
          position: InstructionalNokhtePositions.top,
        ),
      );
      sessionStarterInstructionalNokhte.setControl(Control.stop);
      centerInstructionalNokhte.setWidgetVisibility(true);
      sessionStarterInstructionalNokhte.setWidgetVisibility(true);
    }));
    initReactors();
  }

  @action
  initReactors() {
    disposers.add(gestureCrossTapReactor());
    disposers.add(centerInstructionalNokhteReactor());
    disposers.add(centerCrossNokhteReactor(() {
      sessionStarterInstructionalNokhte.setWidgetVisibility(false);
    }));
  }

  @action
  onSwipeUp() {
    if (!isDisconnected && isAllowedToMakeGesture()) {
      if (hasInitiatedBlur) {
        initToTopInstructionalNokhte(excludePaddingAdjuster: true);
      } else if (smartText.currentIndex.isLessThan(1)) {
        initSessionStarterTransition();
      }
    }
  }

  @action
  onTap(Offset offset) {
    if (!isDisconnected && isAllowedToMakeGesture() && hasInitiatedBlur) {
      if (smartText.currentIndex == 2) {
        smartText.startRotatingText(isResuming: true);
        touchRipple.onTap(offset);
        nokhteBlur.reverse();
        setTouchIsDisabled(true);
        beachWaves.currentStore.setControl(Control.mirror);
        setHasInitiatedBlur(false);
        Timer(Seconds.get(1, milli: 500), () {
          centerInstructionalNokhte.moveBackToCross(
            startingPosition: CenterNokhtePositions.top,
          );
          sessionStarterInstructionalNokhte.initMovie(
            InstructionalGradientMovieParams(
              center: center,
              colorway: GradientNokhteColorways.invertedBeachWave,
              direction: InstructionalGradientDirections.shrink,
              position: InstructionalNokhtePositions.top,
            ),
          );
          setSmartTextBottomPaddingScalar(0.3);
          smartText.reset();
          smartText.startRotatingText();
        });
      } else {
        dismissInstructionalNokhte();
      }
    }
  }

  centerInstructionalNokhteReactor() =>
      reaction((p0) => centerInstructionalNokhte.movieStatus, (p0) {
        if (p0 == MovieStatus.finished &&
            centerInstructionalNokhte.movieMode ==
                CenterInstructionalNokhteMovieModes.moveBack) {
          gestureCross.centerCrossNokhte.setWidgetVisibility(true);
          gestureCross.gradientNokhte.setWidgetVisibility(true);
          setSwipeDirection(GestureDirections.initial);
          setTouchIsDisabled(false);
        }
      });

  gestureCrossTapReactor() => reaction(
        (p0) => gestureCross.tapCount,
        (p0) => onGestureCrossTap(),
      );

  @action
  dismissInstructionalNokhte() {
    setSwipeDirection(GestureDirections.initial);
    centerInstructionalNokhte.moveBackToCross(
      startingPosition: CenterNokhtePositions.center,
    );
    sessionStarterInstructionalNokhte.initMovie(
      InstructionalGradientMovieParams(
        center: center,
        colorway: GradientNokhteColorways.invertedBeachWave,
        direction: InstructionalGradientDirections.shrink,
        position: InstructionalNokhtePositions.top,
      ),
    );
    nokhteBlur.reverse();
    beachWaves.currentStore.setControl(Control.mirror);
    setHasInitiatedBlur(false);
    setSmartTextBottomPaddingScalar(0.3);
    smartText.reset();
    smartText.startRotatingText();
    delayedEnableTouchFeedback();
  }

  @action
  onGestureCrossTap() {
    if (!isDisconnected && isAllowedToMakeGesture() && !hasSwiped()) {
      if (!hasInitiatedBlur) {
        baseOnInitInstructionMode(excludePaddingAdjuster: true);
        sessionStarterInstructionalNokhte.initMovie(
          InstructionalGradientMovieParams(
            center: center,
            colorway: GradientNokhteColorways.invertedBeachWave,
            direction: InstructionalGradientDirections.enlarge,
            position: InstructionalNokhtePositions.top,
          ),
        );
        setSmartTextPadding(bottomPadding: .14);
        delayedEnableTouchFeedback();
      } else if (hasInitiatedBlur) {
        dismissInstructionalNokhte();
      }
    }
  }
}
