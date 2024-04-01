// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/presentation/mobx/mobx.dart';
import 'package:simple_animations/simple_animations.dart';
part 'home_screen_phase2_widgets_coordinator.g.dart';

class HomeScreenPhase2WidgetsCoordinator = _HomeScreenPhase2WidgetsCoordinatorBase
    with _$HomeScreenPhase2WidgetsCoordinator;

abstract class _HomeScreenPhase2WidgetsCoordinatorBase
    extends BaseHomeScreenWidgetsCoordinator with Store {
  _HomeScreenPhase2WidgetsCoordinatorBase({
    required super.nokhteBlur,
    required super.beachWaves,
    required super.wifiDisconnectOverlay,
    required super.gestureCross,
    required super.primarySmartText,
    required super.errorSmartText,
    required super.secondaryErrorSmartText,
    required super.touchRipple,
  });

  @observable
  bool gracePeriodHasExpired = false;

  @observable
  bool crossHasBeenTapped = false;

  @action
  toggleGracePeriodHasExpired() =>
      gracePeriodHasExpired = !gracePeriodHasExpired;

  @override
  @action
  constructor(Offset offset) {
    super.constructor(offset);
    primarySmartText.setMessagesData(MessagesData.firstTimeHomeList);
    Timer(Seconds.get(3), () {
      if (!hasSwipedUp) {
        gestureCross.startBlinking();
        primarySmartText.startRotatingText();
        toggleGracePeriodHasExpired();
      }
    });
    initReactors();
  }

  @action
  @override
  initReactors() {
    gestureCrossTapReactor();
    super.initReactors();
  }

  @action
  onSwipeUp() => prepForNavigation(excludeUnBlur: !hasInitiatedBlur);

  gestureCrossTapReactor() => reaction(
        (p0) => gestureCross.tapCount,
        (p0) => onGestureCrossTap(),
      );

  @action
  onGestureCrossTap() {
    if (!hasInitiatedBlur && !isEnteringNokhteSession && !hasSwipedUp) {
      nokhteBlur.init();
      beachWaves.currentStore.setControl(Control.stop);
      toggleHasInitiatedBlur();
      gestureCross.stopBlinking();
      if (gracePeriodHasExpired) {
        primarySmartText.startRotatingText(isResuming: true);
      } else {
        primarySmartText.setCurrentIndex(1);
        primarySmartText.startRotatingText();
      }
    }
  }
}
