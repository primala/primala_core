// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:ui';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte_backend/tables/company_presets.dart';
import 'package:simple_animations/simple_animations.dart';
part 'session_navigation_store.g.dart';

class SessionNavigationStore = _SessionNavigationStoreBase
    with _$SessionNavigationStore;

abstract class _SessionNavigationStoreBase extends BaseWidgetStore
    with Store, NokhteWidgetsUtils, SwipeNavigationUtils, Reactions {
  @override
  final CenterNokhteStore centerNokhte;
  final AuxiliaryNokhteStore exitNokhte;
  final AuxiliaryNokhteStore infoNokhte;
  final TintStore tint;
  final SwipeGuideStore swipeGuide;
  final GestureCrossStore gestureCross;
  final SwipeDetector swipe;
  @override
  final List<AuxiliaryNokhteStore> auxNokhtes;
  _SessionNavigationStoreBase({
    required this.centerNokhte,
    required this.exitNokhte,
    required this.infoNokhte,
    required this.swipeGuide,
    required this.gestureCross,
    required this.tint,
    required this.swipe,
  }) : auxNokhtes = [exitNokhte, infoNokhte] {
    initNokhteWidgetsUtils();
    initSwipeNavigationUtils();
    centerNokhte.setWidgetVisibility(false);
  }

  @observable
  PresetTypes presetType = PresetTypes.none;

  @action
  resetNokhtes(PresetTypes presetType) {
    centerNokhte.fadeIn();
    exitNokhte.setAndFadeIn(
      AuxiliaryNokhtePositions.bottom,
      AuxiliaryNokhteColorways.exitVibrantBlue,
    );
    infoNokhte.setAndFadeIn(
      AuxiliaryNokhtePositions.top,
      AuxiliaryNokhteColorways.informationTint,
    );
  }

  @action
  setup(
    SessionScreenTypes screenType,
    PresetTypes presetType, {
    initSwipeReactor = true,
  }) {
    this.presetType = presetType;
    Color color = SessionConstants.blue;
    gestureCross.cross.initStaticGlow(
      glowColor: color,
    );
    gestureCross.fadeInTheCross();
    resetNokhtes(presetType);
    initReactors(initSwipeReactor: initSwipeReactor);
  }

  @action
  onSwipeUp() {
    if (isAllowedToMakeGesture() && !hasSwiped() && showWidget) {
      setSwipeDirection(GestureDirections.up);
      centerNokhte.initMovie(AuxiliaryNokhtePositions.top);
      exitNokhte.disappear();
      gestureCross.fadeAllOut();
      swipeGuide.setWidgetVisibility(false);
    }
  }

  @action
  onSwipeDown() {
    if (isAllowedToMakeGesture() && !hasSwiped() && showWidget) {
      setSwipeDirection(GestureDirections.down);
      centerNokhte.initMovie(AuxiliaryNokhtePositions.bottom);
      infoNokhte.disappear();
      swipeGuide.setWidgetVisibility(false);
    }

    //
  }

  @override
  setWidgetVisibility(bool visibility) {
    centerNokhte.setControl(Control.stop);
    exitNokhte.setControl(Control.stop);
    infoNokhte.setControl(Control.stop);
    tint.setControl(Control.stop);
    swipeGuide.setControl(Control.stop);
    super.setWidgetVisibility(visibility);
  }

  swipeReactor({
    required Function onSwipeUp,
    required Function onSwipeDown,
  }) =>
      reaction((p0) => swipe.directionsType, (p0) async {
        switch (p0) {
          case GestureDirections.down:
            if (hasInitiatedBlur) {
              this.onSwipeDown();
            } else {
              onSwipeDown();
            }
            break;
          case GestureDirections.up:
            if (hasInitiatedBlur) {
              this.onSwipeUp();
            } else {
              onSwipeUp();
            }
          default:
            break;
        }
      });

  initReactors({
    bool initSwipeReactor = true,
  }) {
    if (initSwipeReactor) {
      disposers.add(swipeReactor(
        onSwipeDown: () {},
        onSwipeUp: () {},
      ));
    }

    disposers.add(centerNokhteReactor());
    disposers.add(exitNokhteReactor());
    disposers.add(infoNokhteReactor());
  }

  exitNokhteReactor() => reaction((p0) => exitNokhte.movieStatus, (p0) {
        if (p0 == MovieStatus.finished &&
            exitNokhte.movieMode == AuxiliaryNokhteMovieModes.explode) {
          // if (presetType == PresetTypes.socratic) {
          // Modular.to.navigate(SessionConstants.socraticSpeakingExit);
          // } else {
          Modular.to.navigate(SessionConstants.exit);
          // }
        }
      });

  centerNokhteReactor() => reaction(
        (p0) => centerNokhte.movieStatus,
        (p0) {
          if (p0 == MovieStatus.finished &&
              centerNokhte.movieMode == CenterNokhteMovieModes.moveAround) {
            if (centerNokhte.position == AuxiliaryNokhtePositions.bottom) {
              exitNokhte.explode();
            } else if (centerNokhte.position == AuxiliaryNokhtePositions.top) {
              centerNokhte.setWidgetVisibility(false);
              infoNokhte.explode();
            }
          }
        },
      );

  infoNokhteReactor() => reaction((p0) => infoNokhte.movieStatus, (p0) {
        if (p0 == MovieStatus.finished &&
            infoNokhte.movieMode == AuxiliaryNokhteMovieModes.explode) {
          Modular.to.navigate(SessionConstants.information);
        }
      });

  onGestureCrossTap(Function onInit, Function onReverse) {
    if (isAllowedToMakeGesture() && showWidget) {
      if (!hasInitiatedBlur) {
        setHasInitiatedBlur(true);
        tint.initMovie(const NoParams());
        centerNokhte.moveToCenter();
        swipeGuide.fadeIn();
        moveAuxNokhtes(shouldExpand: true);
        onInit();
      } else if (hasInitiatedBlur && !hasSwiped()) {
        dismissNokhte();
        onReverse();
      }
    }
  }

  @action
  dismissNokhte() {
    swipeGuide.setWidgetVisibility(false);
    setHasInitiatedBlur(false);
    setSwipeDirection(GestureDirections.initial);
    centerNokhte.moveBackToCross();
    moveAuxNokhtes(shouldExpand: false);
    tint.reverseMovie(const NoParams());
  }

  @action
  moveAuxNokhtes({required bool shouldExpand}) {
    final dir =
        shouldExpand ? NokhteScaleState.enlarge : NokhteScaleState.shrink;
    infoNokhte.initMovie(dir);
    exitNokhte.initMovie(dir);
  }
}
