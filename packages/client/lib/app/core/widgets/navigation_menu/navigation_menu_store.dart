// ignore_for_file: library_private_types_in_public_api, must_be_immutable
import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/home/home.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte/app/modules/session_starters/session_starters.dart';
part 'navigation_menu_store.g.dart';

class NavigationMenuStore = _NavigationMenuStoreBase with _$NavigationMenuStore;

abstract class _NavigationMenuStoreBase extends BaseWidgetStore
    with Store, Reactions {
  final BeachWavesStore beachWaves;
  final SwipeDetector swipe;
  final TintStore tint;
  final NokhteBlurStore blur;

  _NavigationMenuStoreBase({
    required this.beachWaves,
    required this.swipe,
    required this.blur,
    required this.tint,
  });

  @action
  constructor() {
    Timer(Seconds.get(0, milli: 1), () {
      swipeDownBannerVisibility = true;
    });
  }

  initReactors() {
    disposers.add(swipeReactor());
    disposers.add(actionSliderReactor());
  }

  @observable
  NavigationMenuType navigationMenuType = NavigationMenuType.homescreen;

  @observable
  ActionSliderOptions currentlySelectedSlider = ActionSliderOptions.none;

  @action
  setCurrentlySelectedSlider(ActionSliderOptions slider) {
    if (!showWidget) return;
    currentlySelectedSlider = slider;
  }

  @action
  setNavigationMenuType(
    NavigationMenuType type, {
    bool shouldInitReactors = true,
  }) {
    navigationMenuType = type;
    carouselPosition = configuration.startIndex.toDouble();
    if (shouldInitReactors) {
      initReactors();
    }
  }

  @observable
  double carouselPosition = 1.0;

  navigateQuickActions() {
    Modular.to.navigate(
      navigationMenuType == NavigationMenuType.inSession
          ? SessionConstants.actionSliderRouter
          : HomeConstants.quickActionsRouter,
      arguments: {
        HomeConstants.QUICK_ACTIONS_ROUTE: quickActionsRoute,
      },
    );
  }

// we need to add the functionality for basically having custom swipe down and swipe up higher level functions
  @action
  showNavigationMenu() {
    if (!showWidget ||
        hasSwipedDown ||
        tint.movieStatus == MovieStatus.inProgress ||
        blur.movieStatus == MovieStatus.inProgress ||
        carouselPosition % 1 != 0) return;
    swipeUpBannerVisibility = true;
    swipeDownBannerVisibility = false;
    hasSwipedDown = true;
    blur.init();
    tint.initMovie(const NoParams());
  }

  @action
  hideNavigationMenu() {
    if (!hasSwipedDown ||
        !showWidget ||
        tint.movieStatus == MovieStatus.inProgress ||
        blur.movieStatus == MovieStatus.inProgress ||
        carouselPosition % 1 != 0) return;
    blur.reverse();
    if (carouselPosition == configuration.startIndex) {
      swipeDownBannerVisibility = true;
    } else {
      Timer(Seconds.get(1), () {
        final route =
            configuration.carouselInfo.routes[carouselPosition.toInt()];
        Modular.to.navigate(
          route,
          arguments: route == SessionConstants.lobby ? {} : null,
        );
      });
    }
    swipeUpBannerVisibility = false;
    hasSwipedDown = false;
    tint.reverseMovie(const NoParams());
  }

  @action
  setCarouselPosition(double newPosition) => carouselPosition = newPosition;

  @observable
  bool hasSwipedDown = false;

  @observable
  bool swipeDownBannerVisibility = false;

  @observable
  bool swipeUpBannerVisibility = false;

  swipeReactor({
    Function? onSwipeUp,
  }) =>
      reaction((p0) => swipe.directionsType, (p0) async {
        switch (p0) {
          case GestureDirections.up:
            if (hasSwipedDown) {
              hideNavigationMenu();
            } else {
              await onSwipeUp?.call();
            }

          case GestureDirections.down:
            showNavigationMenu();

          default:
            break;
        }
      });

  actionSliderReactor({
    Function? onActionSliderSelected,
  }) =>
      reaction((p0) => currentlySelectedSlider, (p0) async {
        if (p0 != ActionSliderOptions.none) {
          await onActionSliderSelected?.call();
          navigateQuickActions();
        }
      });

  @computed
  NavigationMenuConfiguration get configuration => NavigationMenuConfiguration(
        navigationMenuType,
      );

  @computed
  String get quickActionsRoute {
    switch (currentlySelectedSlider) {
      case ActionSliderOptions.startSession:
        return SessionStarterConstants.sessionStarter;
      // case ActionSliderOptions.joinSession:
      //   return SessionJoinerConstants.sessionJoiner;
      case ActionSliderOptions.homeScreen:
        return HomeConstants.home;
      case ActionSliderOptions.sessionInformation:
        return SessionConstants.information;
      case ActionSliderOptions.endSession:
        return SessionConstants.exit;
      case ActionSliderOptions.pauseSession:
        return SessionConstants.pause;
      case ActionSliderOptions.none:
        return HomeConstants.home;
    }
  }
}
