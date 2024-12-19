// ignore_for_file: library_private_types_in_public_api, must_be_immutable
import 'package:flutter_modular/flutter_modular.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
part 'navigation_carousels_store.g.dart';

class NavigationCarouselsStore = _NavigationCarouselsStoreBase
    with _$NavigationCarouselsStore;

abstract class _NavigationCarouselsStoreBase extends BaseWidgetStore
    with Store, Reactions {
  final BeachWavesStore beachWaves;

  _NavigationCarouselsStoreBase({
    required this.beachWaves,
  });

  @action
  constructor() {
    disposers.add(positionReactor());
  }

  @observable
  bool canScroll = true;

  @action
  setCanScroll(bool value) => canScroll = value;

  @observable
  NavigationCarouselsType navigationCarouselsType =
      NavigationCarouselsType.homescreen;

  @observable
  ActionSliderOptions currentlySelectedSlider = ActionSliderOptions.none;

  @observable
  NavigationCarouselsSectionTypes currentlySelectedSection =
      NavigationCarouselsSectionTypes.qrCodeIcon;

  @action
  setCurrentlySelectedSection(NavigationCarouselsSectionTypes section) =>
      currentlySelectedSection = section;

  @action
  setNavigationCarouselsType(
    NavigationCarouselsType type,
  ) {
    navigationCarouselsType = type;
    carouselPosition = configuration.startIndex.toDouble();
  }

  @observable
  double carouselPosition = 1.0;

  positionReactor() => reaction(
        (_) => carouselPosition,
        (position) {
          if (position % 1 == 0 && position != configuration.startIndex) {
            final route = configuration.routes[position.toInt()];
            Modular.to.navigate(route);

            // setCanScroll(false);
          }
          // else {
          //   setCanScroll(true);
          // }
        },
      );

  @action
  setCarouselPosition(double newPosition) => carouselPosition = newPosition;

  @computed
  NavigationCarouselsConfiguration get configuration =>
      NavigationCarouselsConfiguration(
        navigationCarouselsType,
      );
}
