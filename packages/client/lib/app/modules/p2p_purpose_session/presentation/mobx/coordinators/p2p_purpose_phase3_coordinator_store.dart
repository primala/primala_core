// ignore_for_file: must_be_immutable, library_private_types_in_public_api
// * Mobx Import
import 'package:mobx/mobx.dart';
// * Equatable Import
import 'package:equatable/equatable.dart';
import 'package:primala/app/core/widgets/mobx.dart';
// * Mobx Codegen Inclusion
part 'p2p_purpose_phase3_coordinator_store.g.dart';

class P2PPurposePhase3CoordinatorStore = _P2PPurposePhase3CoordinatorStoreBase
    with _$P2PPurposePhase3CoordinatorStore;

abstract class _P2PPurposePhase3CoordinatorStoreBase extends Equatable
    with Store {
  final BeachWavesTrackerStore beachWaves;
  final TextEditorTrackerStore textEditor;

  _P2PPurposePhase3CoordinatorStoreBase({
    required this.beachWaves,
    required this.textEditor,
  });

  @action
  screenConstructor() {
    beachWaves.initiateSuspendedAtTheDepths();
    textEditor.addEventListeners();
  }

  @override
  List<Object> get props => [];
}
