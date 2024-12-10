// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/modules/user_information/user_information.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/presets/presets.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte/app/modules/session_starters/session_starters.dart';
import 'package:nokhte_backend/tables/company_presets.dart';
part 'session_presets_coordinator.g.dart';

class SessionPresetsCoordinator = _SessionPresetsCoordinatorBase
    with _$SessionPresetsCoordinator;

abstract class _SessionPresetsCoordinatorBase
    with Store, BaseCoordinator, Reactions {
  final SessionPresetsWidgetsCoordinator widgets;
  final TapDetector tap;
  final PresetsLogicCoordinator presetsLogic;
  final UserInformationCoordinator userInfo;
  final SessionStartersLogicCoordinator starterLogic;

  @override
  final CaptureScreen captureScreen;

  _SessionPresetsCoordinatorBase({
    required this.widgets,
    required this.tap,
    required this.captureScreen,
    required this.starterLogic,
    required this.presetsLogic,
    required this.userInfo,
  }) {
    initBaseCoordinatorActions();
  }

  @action
  constructor() async {
    widgets.constructor();
    initReactors();
    await presetsLogic.getCompanyPresets(Left(GetAllPresetsParams()));
  }

  @action
  initReactors() {
    disposers.addAll(widgets.wifiDisconnectOverlay.initReactors(
      onQuickConnected: () => setDisableAllTouchFeedback(false),
      onLongReConnected: () {
        setDisableAllTouchFeedback(false);
      },
      onDisconnected: () {
        setDisableAllTouchFeedback(true);
      },
    ));
    disposers.add(widgets.condensedPresetCardTapReactor(
      onClose: () async {
        if (widgets.presetArticle.hasAdjustedSessionPreferences) {
          await presetsLogic.upsertSessionPreferences(
            UpsertSessionPreferencesParams(
              type: PresetTypes.solo,
              newTags: widgets.presetArticle.articleSectionsTags,
            ),
          );
          await presetsLogic.getCompanyPresets(Left(GetAllPresetsParams()));
          await userInfo.getPreferredPreset();
        }
      },
    ));
    disposers.add(widgets.presetSelectionReactor(onSelected));
    disposers.addAll([
      preferredPresetReactor(),
      hasUpdatedSessionTypeReactor(),
      companyPresetsReactor(),
    ]);
  }

  @action
  onSelected(String presetUID) async {
    await userInfo.updatePreferredPreset(presetUID);
    await userInfo.getPreferredPreset();
    await starterLogic.updateSessionType(presetUID);
  }

  @action
  resetPresetInfo() {
    if (userInfo.preferredPreset.name.isNotEmpty) {
      final index = presetsLogic.presetsEntity.uids
          .indexOf(userInfo.preferredPreset.presetUID);
      final sections =
          presetsLogic.presetsEntity.articles[index].articleSections;
      final tags = <SessionTags>[];
      for (var section in sections) {
        tags.add(section.tag);
      }
      widgets.onPreferredPresetReceived(
        userInfo.preferredPreset.presetUID,
      );
    }
  }

  preferredPresetReactor() =>
      reaction((p0) => userInfo.preferredPreset, (p0) async {
        if (userInfo.state == StoreState.loaded) {
          if (!userInfo.hasAccessedQrCode) {
            widgets.onNoPresetSelected();
          } else {
            widgets
                .onPreferredPresetReceived(userInfo.preferredPreset.presetUID);
          }
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
    dispose();
    widgets.dispose();
  }
}
