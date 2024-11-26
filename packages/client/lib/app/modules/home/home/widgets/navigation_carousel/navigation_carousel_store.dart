// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/settings/settings.dart';
import 'package:nokhte/app/modules/storage/storage.dart';
part 'navigation_carousel_store.g.dart';

class NavigationCarouselStore = _NavigationCarouselStoreBase
    with _$NavigationCarouselStore;

abstract class _NavigationCarouselStoreBase extends BaseWidgetStore
    with Store, Reactions {
  final BeachWavesStore beachWaves;
  final SwipeDetector swipe;
  final TintStore tint;

  _NavigationCarouselStoreBase({
    required this.beachWaves,
    required this.swipe,
    required this.tint,
  });

  @action
  constructor() {
    Timer(Seconds.get(0, milli: 1), () {
      swipeDownBannerVisibility = true;
    });
    disposers.add(swipeReactor());
  }

  List carouselItems = [
    "settings",
    "home",
    "storage",
  ];

  @observable
  double carouselPosition = 1.0;

  @action
  onSwipeDown() {
    if (hasSwipedDown ||
        tint.movieStatus == MovieStatus.inProgress ||
        carouselPosition % 1 != 0) return;
    // if (carouselPosition == 1) {
    // } else {
    //   Timer(Seconds.get(1), () {
    //     if (carouselPosition == 0) {
    //       Modular.to.navigate(SettingsConstants.settings);
    //     } else {
    //       Modular.to.navigate(StorageConstants.home);
    //     }
    //   });
    // }
    swipeUpBannerVisibility = true;
    swipeDownBannerVisibility = false;
    hasSwipedDown = true;
    tint.initMovie(const NoParams());
  }

  @action
  onSwipeUp() {
    if (!hasSwipedDown ||
        tint.movieStatus == MovieStatus.inProgress ||
        carouselPosition % 1 != 0) return;

    if (carouselPosition == 1) {
      swipeDownBannerVisibility = true;
    } else {
      Timer(Seconds.get(1), () {
        if (carouselPosition == 0) {
          Modular.to.navigate(SettingsConstants.settings);
        } else {
          Modular.to.navigate(StorageConstants.home);
        }
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
}
