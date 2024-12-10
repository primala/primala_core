// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/connectivity/connectivity.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/presets/presets.dart';
import 'package:nokhte/app/modules/session/session.dart';
part 'session_presets_widgets_coordinator.g.dart';

class SessionPresetsWidgetsCoordinator = _SessionPresetsWidgetsCoordinatorBase
    with _$SessionPresetsWidgetsCoordinator;

abstract class _SessionPresetsWidgetsCoordinatorBase
    with Store, BaseWidgetsCoordinator, Reactions {
  final NavigationMenuStore navigationMenu;
  final PresetCardsStore presetCards;
  final SmartTextStore headerText;
  final PresetArticleStore presetArticle;
  @override
  final WifiDisconnectOverlayStore wifiDisconnectOverlay;
  final BeachWavesStore beachWaves;

  _SessionPresetsWidgetsCoordinatorBase({
    required this.navigationMenu,
    required this.presetCards,
    required this.headerText,
    required this.presetArticle,
    required this.wifiDisconnectOverlay,
  }) : beachWaves = navigationMenu.beachWaves {
    initBaseWidgetsCoordinatorActions();
  }

  @action
  constructor() {
    navigationMenu.setNavigationMenuType(NavigationMenuType.sessionPresets);
    beachWaves.setMovieMode(BeachWaveMovieModes.invertedDeeperBlueToDeepSea);
    headerText.setMessagesData(PresetsLists.presetsHeader);
    headerText.startRotatingText();
    initReactors();
  }

  initReactors() {
    disposers.add(presetCardHoldReactor());
    disposers.add(presetCardMovieStatusReactor());
    disposers.add(beachWavesMovieStatusReactor());
  }

  @observable
  bool firstCardIsSelected = false;

  @observable
  bool cardsHaveFadedIn = false;

  @observable
  bool hasNotSelectedPreset = false;

  @action
  setCardsHaveFadedIn(bool val) => cardsHaveFadedIn = val;

  @observable
  bool canHoldOnPresetCard = false;

  @action
  setCanHoldOnPresetCard(bool val) => canHoldOnPresetCard = val;

  @action
  onNoPresetSelected() {
    hasNotSelectedPreset = true;
  }

  @action
  onPreferredPresetReceived(
    String presetUID,
  ) {
    presetCards.setPreferredPresetUID(presetUID);
  }

  @action
  goBackToLobby() {
    beachWaves.currentStore.initMovie(const NoParams());
    navigationMenu.setWidgetVisibility(false);
    presetCards.setWidgetVisibility(false);
    headerText.setWidgetVisibility(false);
  }

  onCompanyPresetsReceived(CompanyPresetsEntity presetsEntity) {
    presetCards.setPresets(presetsEntity);
    if (presetArticle.articleSections.isEmpty) {
      presetCards.showAllCondensedPresets();
    }
  }

  presetCardMovieStatusReactor() =>
      reaction((p0) => presetCards.movieStatuses.first, (p0) {
        if (p0 == MovieStatus.finished) {
          if (presetCards.movieModes.first ==
              CondensedPresetCardMovieModes.fadeIn) {
            if (!cardsHaveFadedIn) {
              presetCards.setCurrentHeldIndex(
                presetCards.preferredPresetIndex,
                override: true,
              );
              setCardsHaveFadedIn(true);
            }
          }
        }
      });

  presetSelectionReactor(Function(String param) onSelected) =>
      reaction((p0) => presetCards.movieStatuses.toString(), (p0) async {
        if (presetCards.currentHeldIndex != -1) {
          hasNotSelectedPreset = false;
          final currentHeldIndex = presetCards.currentHeldIndex;
          if (presetCards.movieModes[currentHeldIndex] ==
                  CondensedPresetCardMovieModes.selectionInProgress &&
              presetCards.movieStatuses[currentHeldIndex] ==
                  MovieStatus.finished) {
            Timer(Seconds.get(1), () {
              presetCards.enableAllTouchFeedback();
            });
            Timer(Seconds.get(firstCardIsSelected ? 0 : 1), () async {
              await onSelected(presetCards.currentlySelectedSessionUID);

              presetCards.initSelectionMovie(currentHeldIndex);
              if (firstCardIsSelected) {
                goBackToLobby();
              }
              firstCardIsSelected = true;
            });
          }
        }
      });

  condensedPresetCardTapReactor({
    required Function onClose,
  }) =>
      reaction((p0) => presetCards.tapCount, (p0) {
        presetArticle.showBottomSheet(
          presetCards.companyPresetsEntity,
          activeIndex: presetCards.currentTappedIndex,
          onClose: () async {
            if (presetCards.currentArticleHasOptions) {
              await onClose();
            }
          },
        );
      });

  presetCardHoldReactor() =>
      reaction((p0) => presetCards.currentHeldIndex, (p0) {
        if (presetCards.pastHeldIndex != -1) {
          presetCards.initWindDown(presetCards.pastHeldIndex);
        }
        presetCards.selectPreset(p0);

        if (hasNotSelectedPreset) {
          firstCardIsSelected = true;
        }
      });

  beachWavesMovieStatusReactor() =>
      reaction((p0) => beachWaves.movieStatus, (p0) {
        if (p0 == beachWaves.movieStatus) {
          Modular.to.navigate(SessionConstants.lobby, arguments: {});
        }
      });
}
