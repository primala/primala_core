// ignore_for_file: library_private_types_in_public_api, must_be_immutable
import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/session/session.dart';
part 'navigation_menu_store.g.dart';

class NavigationMenuStore = _NavigationMenuStoreBase with _$NavigationMenuStore;

abstract class _NavigationMenuStoreBase extends BaseWidgetStore
    with Store, Reactions {
  final BeachWavesStore beachWaves;
  final SwipeDetector swipe;
  final TintStore tint;
  final NokhteBlurStore blur;

  @observable
  NavigationMenuType navigationMenuType = NavigationMenuType.homescreen;

  @action
  setNavigationMenuType(NavigationMenuType type) {
    navigationMenuType = type;
    carouselPosition = configuration.startIndex.toDouble();
  }

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
    disposers.add(swipeReactor());
  }

  @observable
  double carouselPosition = 1.0;

  @action
  onSwipeDown() {
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
  onSwipeUp() {
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

  swipeReactor() => reaction((p0) => swipe.directionsType, (p0) {
        switch (p0) {
          case GestureDirections.up:
            onSwipeUp();

          case GestureDirections.down:
            onSwipeDown();

          default:
            break;
        }
      });

  @computed
  NavigationMenuConfiguration get configuration => NavigationMenuConfiguration(
        navigationMenuType,
      );
}
