// ignore_for_file: must_be_immutable, library_private_types_in_public_api
// * Mobx Import
import 'package:mobx/mobx.dart';
// * Equatable Import
import 'package:equatable/equatable.dart';
import 'package:primala/app/core/widgets/widgets.dart';
import 'package:primala/app/modules/p2p_purpose_session/presentation/mobx/main/check_if_user_has_the_question_store.dart';
import 'package:primala/app/modules/p2p_purpose_session/presentation/mobx/mobx.dart';
// * Mobx Codegen Inclusion
part 'p2p_purpose_phase2_coordinator_store.g.dart';

class P2PPurposePhase2CoordinatorStore = _P2PPurposePhase2CoordinatorStoreBase
    with _$P2PPurposePhase2CoordinatorStore;

abstract class _P2PPurposePhase2CoordinatorStoreBase extends Equatable
    with Store {
  final AgoraCallbacksStore agoraCallbacksStore;
  final VoiceCallActionsStore voiceCallActionsStore;
  final CheckIfUserHasTheQuestionStore checkIfUserHasTheQuestionStore;
  // widget stores
  final BeachWavesTrackerStore beachWaves;
  final SmartFadingAnimatedTextTrackerStore fadingText;
  final BreathingPentagonsStateTrackerStore breathingPentagons;

  @action
  screenConstructor() {
    beachWaves.initiateSuspendedAtTheDepths();
  }

  _P2PPurposePhase2CoordinatorStoreBase({
    required this.agoraCallbacksStore,
    required this.checkIfUserHasTheQuestionStore,
    required this.voiceCallActionsStore,
    required this.beachWaves,
    required this.fadingText,
    required this.breathingPentagons,
  });

  @action
  breathingPentagonsHoldStartCallback() {
    ///
  }

  @action
  breathingPentagonsHoldEndCallback() {
    ///
  }

  @override
  List<Object> get props => [];
}
