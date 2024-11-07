// ignore_for_file: must_be_immutable, library_private_types_in_public_api
import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:mobx/mobx.dart';
import 'package:nokhte/app/core/mobx/mobx.dart';
import 'package:nokhte/app/core/modules/posthog/posthog.dart';
import 'package:nokhte/app/core/types/types.dart';
import 'package:nokhte/app/core/widgets/utilities/utilities.dart';
import 'package:nokhte/app/core/widgets/widgets.dart';
import 'package:nokhte/app/modules/presets/presets.dart';
import 'package:nokhte/app/modules/session/session.dart';
import 'package:nokhte/app/modules/session_starters/session_starters.dart';
import 'package:nokhte_backend/tables/company_presets.dart';
part 'polymorphic_solo_coordinator.g.dart';

class PolymorphicSoloCoordinator = _PolymorphicSoloCoordinatorBase
    with _$PolymorphicSoloCoordinator;

abstract class _PolymorphicSoloCoordinatorBase
    with Store, BaseCoordinator, Reactions {
  final PolymorphicSoloWidgetsCoordinator widgets;
  final HoldDetector hold;
  final SessionPresenceCoordinator presence;
  @override
  final CaptureScreen captureScreen;
  final SessionStartersLogicCoordinator sessionStartersLogic;
  final TapDetector tap;
  final CaptureSessionStart captureStart;
  final CaptureSessionEnd captureEnd;
  final SessionMetadataStore sessionMetadata;
  final PresetsLogicCoordinator presets;

  _PolymorphicSoloCoordinatorBase({
    required this.captureScreen,
    required this.captureStart,
    required this.sessionStartersLogic,
    required this.captureEnd,
    required this.widgets,
    required this.presence,
    required this.hold,
    required this.tap,
  })  : sessionMetadata = presence.sessionMetadataStore,
        presets = presence.sessionMetadataStore.presetsLogic {
    initBaseCoordinatorActions();
  }

  @action
  constructor() async {
    widgets.constructor();
    initReactors();
    if (getTags().isEmpty) {
      await sessionStartersLogic.initialize(const Right(PresetTypes.solo));
    } else {
      widgets.postConstructor(getTags());
      initPostConstructorReactors();
    }
    await captureScreen(SessionConstants.polymorphicSolo);
  }

  initReactors() {
    disposers.add(sessionPresetReactor());
    disposers.add(sessionInitializationReactor());
  }

  initPostConstructorReactors() {
    if (getTags().contains(SessionTags.holdToSpeak)) {
      disposers.add(holdReactor());
      disposers.add(letGoReactor());
    }
    disposers.add(tapReactor());
    disposers.add(backButtonReactor());
  }

  sessionInitializationReactor() =>
      reaction((p0) => sessionStartersLogic.hasInitialized, (p0) async {
        if (p0) {
          await presence.listen();
        }
      });

  sessionPresetReactor() =>
      reaction((p0) => sessionMetadata.presetsLogic.state, (p0) async {
        if (p0 == StoreState.loaded) {
          widgets.postConstructor(getTags());
          initPostConstructorReactors();
          await captureStart(CaptureSessionStartParams(
            numberOfCollaborators: sessionMetadata.numberOfCollaborators,
            presetType: sessionMetadata.presetType,
          ));
        }
      });

  tapTalkingLogic(GesturePlacement placement) {
    if (widgets.isHolding) {
      widgets.onLetGo();
    } else {
      widgets.adjustSpeakLessSmileMoreRotation(placement);
      widgets.onHold(placement);
    }
  }

  tapReactor() => reaction((p0) => tap.tapCount, (p0) {
        if (tap.currentTapPlacement == GesturePlacement.topHalf) {
          if (getTags().contains(SessionTags.deactivatedNotes)) {
            if (getTags().contains(SessionTags.tapToSpeak)) {
              tapTalkingLogic(tap.currentTapPlacement);
            }
          } else {
            widgets.initFullScreenNotes();
          }
        } else {
          if (getTags().contains(SessionTags.tapToSpeak)) {
            tapTalkingLogic(tap.currentTapPlacement);
          }
        }
      });

  backButtonReactor() =>
      reaction((p0) => widgets.backButton.tapCount, (p0) async {
        if (widgets.backButton.showWidget) {
          widgets.goHome();
          await presence.completeTheSession();
          await captureEnd(
            CaptureSessionEndParams(
              sessionsStartTime: sessionMetadata.sessionStartTime,
              presetType: sessionMetadata.presetType,
              numberOfCollaborators: sessionMetadata.numberOfCollaborators,
            ),
          );
          await presence.dispose();
          await presets.reset();
        }
      });

  holdReactor() => reaction((p0) => hold.holdCount, (p0) {
        if (hold.placement == GesturePlacement.bottomHalf) {
          widgets.adjustSpeakLessSmileMoreRotation(hold.placement);
          widgets.onHold(hold.placement);
        } else {
          if (getTags().contains(SessionTags.deactivatedNotes)) {
            widgets.adjustSpeakLessSmileMoreRotation(hold.placement);
            widgets.onHold(hold.placement);
          }
        }
      });

  letGoReactor() => reaction((p0) => hold.letGoCount, (p0) async {
        widgets.onLetGo();
        Timer(Seconds.get(2), () {
          setDisableAllTouchFeedback(false);
        });
      });

  deconstructor() {
    dispose();
    widgets.dispose();
  }

  List<SessionTags> getTags() {
    if (presets.presetsEntity.articles.isEmpty) return [];
    final list = <SessionTags>[];
    for (var section in presets.presetsEntity.articles.first.articleSections) {
      list.add(section.tag);
    }
    return list;
  }
}
