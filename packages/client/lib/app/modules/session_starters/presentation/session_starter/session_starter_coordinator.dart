// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/interfaces/logic.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/modules/user_information/user_information.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/presets/presets.dart';
import 'package:nokhte/app/modules/session_starters/session_starters.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte_backend/tables/company_presets.dart';
part 'session_starter_coordinator.g.dart';

class SessionStarterCoordinator = _SessionStarterCoordinatorBase
    with _$SessionStarterCoordinator;

abstract class _SessionStarterCoordinatorBase
    with Store, BaseCoordinator, Reactions {
  final SessionStarterWidgetsCoordinator widgets;
  final SwipeDetector swipe;
  final TapDetector tap;
  final SessionStartersLogicCoordinator starterLogic;
  final PresetsLogicCoordinator presetsLogic;
  final UserInformationCoordinator userInfo;
  @override
  final CaptureScreen captureScreen;

  _SessionStarterCoordinatorBase({
    required this.widgets,
    required this.userInfo,
    required this.tap,
    required this.swipe,
    required this.starterLogic,
    required this.presetsLogic,
    required this.captureScreen,
  }) {
    initBaseCoordinatorActions();
  }

  @observable
  bool isNavigatingAway = false;

  @observable
  StoreState presetsQueryState = StoreState.loaded;

  @action
  setPresetsQueryState(StoreState state) => presetsQueryState = state;

  @action
  toggleIsNavigatingAway() => isNavigatingAway = !isNavigatingAway;

  @action
  constructor() async {
    widgets.constructor();
    widgets.initReactors();
    initReactors();
    await presetsLogic.getCompanyPresets(Left(GetAllPresetsParams()));
    await captureScreen(SessionStarterConstants.sessionStarter);
    starterLogic.listenToSessionActivation();
  }

  initReactors() {
    disposers.add(swipeReactor());
    disposers.add(companyPresetsReactor());
    disposers.add(preferredPresetReactor());
    disposers.addAll(widgets.wifiDisconnectOverlay.initReactors(
      onQuickConnected: () => setDisableAllTouchFeedback(false),
      onLongReConnected: () {
        setDisableAllTouchFeedback(false);
        widgets.setIsDisconnected(false);
      },
      onDisconnected: () {
        setDisableAllTouchFeedback(true);
        widgets.setIsDisconnected(true);
      },
    ));
    disposers.add(nokhteSearchStatusReactor());
    disposers.add(hasUpdatedSessionTypeReactor());
    disposers.add(hasInitiatedSessionReactor());
    disposers.add(widgets.presetSelectionReactor(onSelected));
    disposers.add(widgets.condensedPresetCardTapReactor(
      onClose: () async {
        if (widgets.presetArticle.hasAdjustedSessionPreferences) {
          setPresetsQueryState(StoreState.loading);
          if (userInfo.preferredPreset.name == 'Solo') {
            widgets.presetHeader.presetIcons
                .setTags(widgets.presetArticle.articleSectionsTags);
          }
          await presetsLogic.upsertSessionPreferences(
            UpsertSessionPreferencesParams(
              type: PresetTypes.solo,
              newTags: widgets.presetArticle.articleSectionsTags,
            ),
          );
          await presetsLogic.getCompanyPresets(Left(GetAllPresetsParams()));
          await userInfo.getPreferredPreset();
          setPresetsQueryState(StoreState.loaded);
        }
      },
    ));
  }

  tapReactor() => reaction((p0) => tap.doubleTapCount, (p0) async {
        if (selectedSessionIsSolo && presetsQueryState == StoreState.loaded) {
          if (!widgets.isEnteringNokhteSession) {
            widgets.initTransition(true);
            await starterLogic.dispose();
          }
        }
      });

  swipeReactor() => reaction((p0) => swipe.directionsType, (p0) => onSwipe(p0));

  @action
  onSelected(String presetUID) async {
    await userInfo.updatePreferredPreset(presetUID);
    await userInfo.getPreferredPreset();
    await starterLogic.updateSessionType(presetUID);
  }

  @action
  onSwipe(GestureDirections direction) {
    if (!isNavigatingAway) {
      switch (direction) {
        case GestureDirections.down:
          ifTouchIsNotDisabled(() {
            widgets.onSwipeDown(() async {
              toggleIsNavigatingAway();
              await starterLogic.dispose(shouldNuke: true);
            });
          });
        default:
          break;
      }
    }
  }

  nokhteSearchStatusReactor() =>
      reaction((p0) => starterLogic.hasFoundNokhteSession, (p0) async {
        if (p0) {
          setDisableAllTouchFeedback(true);
          widgets.initTransition(false);
        }
      });

  preferredPresetReactor() =>
      reaction((p0) => userInfo.preferredPreset, (p0) async {
        if (userInfo.state == StoreState.loaded) {
          if (!userInfo.hasAccessedQrCode) {
            widgets.onNoPresetSelected();
            if (starterLogic.hasInitialized) return;
            await starterLogic.initialize(const Right(PresetTypes.solo));
          } else {
            if (starterLogic.hasInitialized) return;
            await starterLogic.initialize(const Left(NoParams()));
          }
        }
      });

  @action
  resetPresetInfo() {
    if (userInfo.preferredPreset.name.isNotEmpty &&
        !widgets.isEnteringNokhteSession) {
      final index = presetsLogic.presetsEntity.uids
          .indexOf(userInfo.preferredPreset.presetUID);
      final sections =
          presetsLogic.presetsEntity.articles[index].articleSections;
      final tags = <SessionTags>[];
      for (var section in sections) {
        tags.add(section.tag);
      }
      widgets.onPreferredPresetReceived(
        sessionName: userInfo.preferredPreset.name,
        tags: tags,
        presetUID: userInfo.preferredPreset.presetUID,
        userUID: userInfo.preferredPreset.userUID,
      );
    }
  }

  hasInitiatedSessionReactor() =>
      reaction((p0) => starterLogic.hasInitialized, (p0) async {
        if (p0) {
          resetPresetInfo();
          disposers.add(tapReactor());
        }
      });

  hasUpdatedSessionTypeReactor() =>
      reaction((p0) => starterLogic.hasUpdatedSessionType, (p0) async {
        if (p0) {
          resetPresetInfo();
        }
      });

  companyPresetsReactor() => reaction((p0) => presetsLogic.state, (p0) async {
        if (p0 == StoreState.loaded) {
          widgets.onCompanyPresetsReceived(presetsLogic.presetsEntity);
          await userInfo.getPreferredPreset();
          if (!userInfo.hasAccessedQrCode) {
            widgets.presetCards.enableAllTouchFeedback();
          }
        }
      });

  deconstructor() async {
    await starterLogic.dispose();
    dispose();
    widgets.dispose();
  }

  @computed
  bool get selectedSessionIsSolo => userInfo.preferredPreset.name == 'Solo';
}
